# RootStore

Alternative package manager and app store for jailbroken legacy iOS
(like Cydia). Native Objective-C + UIKit, no WebView, no SwiftUI.

- **Target:** iOS 8.4.1, ARMv7 (iPhone 4s and other 32-bit devices)
- **Package:** `com.blxckfvde.rootstore`, installed to `/Applications`
- **Language:** Objective-C (ARC), iOS 8-compatible APIs only
- **UI:** Material Design 3 typography + Liquid Glass-style components (RSGlass*)

## Build

Local builds are not supported (requires Xcode + legacy iOS SDK).
CI builds the `.deb`:

```sh
# GitHub Actions (.github/workflows/build.yml)
make package   # clang armv7 → link vs iPhoneOS10.3.sdk → ldid → dpkg-deb
make validate  # dpkg-deb -I/-c, armv7 + LC_VERSION_MIN_IPHONEOS 8.4.1 checks
```

Locally you can run static checks only:

```sh
./scripts/build.sh check
```

The legacy `iPhoneOS10.3.sdk` is used **only as link sysroot** (modern Xcode
SDKs dropped armv7 `.tbd` stubs). Theos is intentionally not used.

## Install

Copy the built `.deb` to the device and install with dpkg
(or add the repo once repository hosting is implemented):

```sh
dpkg -i RootStore_0.1.0_iphoneos-arm.deb
```

`postinst` runs `uicache` to refresh the SpringBoard icon cache.

## Structure

```
App/            entry point + AppDelegate
Core/           repository/package managers, network, database, models (no UI)
UI/Components/  reusable glass components (RSGlass*)
UI/DesignSystem/ theme, colors, typography
UI/Screens/     Home, Repositories, Search, Profile, PackageDetails
Resources/      Info.plist, icons (Tools/gen_icon.py)
Packaging/      DEBIAN/control, postinst, postrm
scripts/        build.sh (single build entry point)
```

## License

See [LICENSE](LICENSE).
