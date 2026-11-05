#import "RSTheme.h"
#import "RSColorPalette.h"

NSNotificationName const RSThemeDidChangeNotification = @"RSThemeDidChangeNotification";

@implementation RSTheme {
    BOOL _dark;
}

+ (instancetype)shared {
    static RSTheme *s;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [[RSTheme alloc] init]; });
    return s;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dark = NO; // default light
    }
    return self;
}

- (BOOL)isDark { return _dark; }

- (void)setDarkMode:(BOOL)dark {
    _dark = dark;
    [[NSNotificationCenter defaultCenter] postNotificationName:RSThemeDidChangeNotification object:self];
}

- (void)notifyChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:RSThemeDidChangeNotification object:self];
}

- (RSColorPalette *)palette { return [RSColorPalette shared]; }

#pragma mark - Colors

- (UIColor *)backgroundColor {
    if (_dark) return [self colorWithHex:@"#1C1B1F"];
    return [self palette].surface;
}

- (UIColor *)textColor {
    if (_dark) return [UIColor colorWithWhite:0.94 alpha:1.0];
    return [self palette].onSurface;
}

- (UIColor *)secondaryTextColor {
    if (_dark) return [UIColor colorWithWhite:0.62 alpha:1.0];
    return [self palette].onSurfaceVariant;
}

- (UIColor *)cardColor {
    if (_dark) return [UIColor colorWithRed:0.14 green:0.13 blue:0.17 alpha:0.88];
    return [self palette].surfaceVariant;
}

- (UIColor *)accentColor { return [self palette].primary; }

- (UIColor *)colorWithHex:(NSString *)hex { return [[RSColorPalette shared] colorWithHex:hex]; }

#pragma mark - Typography (MD3)

- (UIFont *)headlineFont { return [UIFont systemFontOfSize:32.0 weight:UIFontWeightBold]; }
- (UIFont *)titleFont { return [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium]; }
- (UIFont *)bodyFont { return [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular]; }
- (UIFont *)captionFont { return [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular]; }
- (UIFont *)buttonFont { return [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]; }

@end