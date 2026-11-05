#!/bin/bash
# RootStore build script — no Theos.
#
# Toolchain notes (iOS 8.4.1 / ARMv7):
#  - Compile with the current Xcode iOS SDK headers (proven on macos runner).
#  - LINK against a legacy SDK (iPhoneOS10.3.sdk): modern SDKs dropped armv7
#    .tbd stubs, so auto-linking UIKit/Foundation for armv7 fails there.
#  - Deployment target 8.4.1 makes ld64 emit LC_VERSION_MIN_IPHONEOS (not
#    LC_BUILD_VERSION), which is what iOS 8 dyld understands.
#  - -Wl,-U,_objc_msgSend_stret: same workaround as the reference project.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="RootStore"
ARCH="armv7"
MIN_OS="8.4.1"
LEGACY_SDK="$ROOT/third_party/theos-sdks/iPhoneOS10.3.sdk"
BUILD="$ROOT/build"
OBJ="$BUILD/obj"
STAGE="$BUILD/stage"
CONTROL="$ROOT/Packaging/DEBIAN/control"
FRAMEWORKS="-framework UIKit -framework Foundation -framework CoreGraphics -framework QuartzCore"
LIBS="-lsqlite3"

die() { echo "build.sh: ERROR: $*" >&2; exit 1; }

require_macos() {
    [ "$(uname -s)" = "Darwin" ] || die "iOS build requires macOS (Xcode). Local check: ./scripts/build.sh check"
    command -v xcrun >/dev/null 2>&1 || die "xcrun not found (install Xcode)"
}

VERSION="$(sed -n 's/^Version: *//p' "$CONTROL" | tr -d '[:space:]')"
[ -n "$VERSION" ] || die "cannot read Version from $CONTROL"

# Include dirs: every directory in the project that holds headers.
include_flags() {
    local dirs="" d
    while IFS= read -r d; do
        dirs="$dirs -I$d"
    done < <(find "$ROOT/App" "$ROOT/UI" "$ROOT/Core" -name '*.h' 2>/dev/null | xargs -n1 dirname | sort -u)
    echo "$dirs"
}

compile_all() {
    local compile_sysroot src obj incs newest
    compile_sysroot="$(xcrun --sdk iphoneos --show-sdk-path)"
    [ -d "$compile_sysroot" ] || die "iphoneos SDK not found"
    incs="$(include_flags)"
    mkdir -p "$OBJ"
    while IFS= read -r src; do
        obj="$OBJ/$(echo "${src#"$ROOT"/}" | tr '/' '_').o"
        # Skip when object is newer than the source and than every project header.
        if [ -f "$obj" ] && [ "$obj" -nt "$src" ]; then
            newest="$(find "$ROOT/App" "$ROOT/UI" "$ROOT/Core" -name '*.h' -newer "$obj" 2>/dev/null | head -1)"
            [ -z "$newest" ] && continue
        fi
        echo "  CC ${src#"$ROOT"/}"
        # shellcheck disable=SC2086
        xcrun clang -arch "$ARCH" -miphoneos-version-min="$MIN_OS" \
            -isysroot "$compile_sysroot" -fobjc-arc -Os -Wall \
            -Wunguarded-availability $incs -c "$src" -o "$obj" \
            || die "compile failed: $src"
    done < <(find "$ROOT/App" "$ROOT/UI" "$ROOT/Core" -name '*.m' 2>/dev/null | sort)
    [ -n "$(ls -A "$OBJ" 2>/dev/null)" ] || die "no object files produced"
}

link_binary() {
    [ -d "$LEGACY_SDK" ] || die "legacy SDK missing at $LEGACY_SDK (CI clones theos/sdks sparse)"
    echo "  LD $APP_NAME (sysroot: $(basename "$LEGACY_SDK"))"
    # shellcheck disable=SC2086
    xcrun clang -arch "$ARCH" -miphoneos-version-min="$MIN_OS" \
        -isysroot "$LEGACY_SDK" -Wl,-U,_objc_msgSend_stret \
        -o "$BUILD/$APP_NAME" "$OBJ"/*.o $FRAMEWORKS $LIBS \
        || die "link failed"
    command -v ldid >/dev/null 2>&1 || die "ldid not found (brew install ldid)"
    ldid -S "$BUILD/$APP_NAME" || die "ldid signing failed"
}

stage_bundle() {
    local app="$STAGE/Applications/$APP_NAME.app"
    rm -rf "$STAGE"
    mkdir -p "$app" "$STAGE/DEBIAN"
    cp "$BUILD/$APP_NAME" "$app/$APP_NAME"
    cp "$ROOT/Resources/Info.plist" "$app/Info.plist"
    cp "$ROOT/Resources/AppIcon.png" "$ROOT/Resources/AppIcon@2x.png" "$app/"
    chmod 755 "$app/$APP_NAME"
    chmod 644 "$app/Info.plist" "$app/AppIcon.png" "$app/AppIcon@2x.png"
    cp "$CONTROL" "$STAGE/DEBIAN/control"
    chmod 644 "$STAGE/DEBIAN/control"
    chmod 755 "$STAGE" "$STAGE/Applications" "$app" "$STAGE/DEBIAN"
    local script
    for script in postinst postrm; do
        if [ -f "$ROOT/Packaging/DEBIAN/$script" ]; then
            cp "$ROOT/Packaging/DEBIAN/$script" "$STAGE/DEBIAN/$script"
            chmod 755 "$STAGE/DEBIAN/$script"
        fi
    done
    # Version must stay in sync between control and Info.plist.
    local plist_version
    plist_version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Info.plist")"
    [ "$plist_version" = "$VERSION" ] || die "version mismatch: control=$VERSION Info.plist=$plist_version"
}

make_deb() {
    command -v dpkg-deb >/dev/null 2>&1 || die "dpkg-deb not found (brew install dpkg)"
    local deb="$BUILD/${APP_NAME}_${VERSION}_iphoneos-arm.deb"
    dpkg-deb -Zgzip --root-owner-group -b "$STAGE" "$deb" || die "dpkg-deb failed"
    echo "  OK $deb"
}

validate_deb() {
    local deb
    deb="$(ls "$BUILD/${APP_NAME}_"*.deb 2>/dev/null | head -1)"
    [ -n "$deb" ] || die "no .deb in build/ — run ./scripts/build.sh package first"
    echo "== dpkg-deb -I =="
    dpkg-deb -I "$deb"
    echo "== dpkg-deb -c (bundle) =="
    dpkg-deb -c "$deb" | grep -E "Applications/${APP_NAME}\.app/($APP_NAME|Info\.plist)$" \
        || die "bundle entries missing in deb"
    # Architecture of the compiled binary must match control (iphoneos-arm = 32-bit iOS).
    dpkg-deb --fsys-tarfile "$deb" | tar -xO "./Applications/$APP_NAME.app/$APP_NAME" > "$BUILD/_check_bin" \
        || die "cannot extract binary from deb"
    python3 - "$BUILD/_check_bin" <<'PY' || die "binary arch check failed"
import struct, sys
with open(sys.argv[1], "rb") as f:
    data = f.read(8)
if len(data) < 8:
    sys.exit("binary too short")
magic, cputype = struct.unpack("<II", data)
# MH_MAGIC (32-bit LE Mach-O) = 0xfeedface, CPU_TYPE_ARM = 12.
if magic != 0xFEEDFACE or cputype != 12:
    sys.exit("not a 32-bit ARM Mach-O: magic=%#x cputype=%#x" % (magic, cputype))
print("  arch check: 32-bit ARM (armv7) OK")
PY
    if command -v otool >/dev/null 2>&1; then
        otool -l "$BUILD/_check_bin" | grep -q "LC_VERSION_MIN_IPHONEOS" \
            || die "missing LC_VERSION_MIN_IPHONEOS (wrong load command for iOS 8)"
        otool -l "$BUILD/_check_bin" | grep -A3 "LC_VERSION_MIN_IPHONEOS" | grep -q "version $MIN_OS" \
            || die "min version is not $MIN_OS"
    fi
    rm -f "$BUILD/_check_bin"
    echo "== validation OK =="
}

check_local() {
    # Static verification usable on non-macOS hosts.
    echo "local static check:"
    local bad
    bad="$(grep -rnE 'UIStackView|NSLayoutAnchor|WKWebView|systemImageNamed|SFSymbol' \
        "$ROOT/App" "$ROOT/UI" "$ROOT/Core" 2>/dev/null || true)"
    [ -z "$bad" ] || { echo "$bad"; die "iOS 9+ API usage found"; }
    echo "  no iOS9+ API markers: OK"
}

cmd="${1:-package}"
case "$cmd" in
    build)    require_macos; compile_all; link_binary ;;
    package)  require_macos; compile_all; link_binary; stage_bundle; make_deb ;;
    validate) validate_deb ;;
    check)    check_local ;;
    clean)    rm -rf "$BUILD" ;;
    *) die "unknown command: $cmd (build|package|validate|check|clean)" ;;
esac
