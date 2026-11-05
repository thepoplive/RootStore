#import "RSColorPalette.h"

@implementation RSColorPalette

+ (instancetype)shared {
    static RSColorPalette *s;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [[RSColorPalette alloc] init]; });
    return s;
}

- (UIColor *)colorWithHex:(NSString *)hex {
    if (hex.length == 0) return [UIColor clearColor];
    NSString *clean = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:clean];
    if (![scanner scanHexInt:&rgb]) return [UIColor clearColor];
    return [UIColor colorWithRed:((rgb >> 16) & 0xFF) / 255.0
                           green:((rgb >> 8) & 0xFF) / 255.0
                            blue:(rgb & 0xFF) / 255.0
                           alpha:1.0];
}

#pragma mark - Primary

- (UIColor *)primary { return [self colorWithHex:@"#6750A4"]; }
- (UIColor *)onPrimary { return [UIColor whiteColor]; }
- (UIColor *)primaryContainer { return [self colorWithHex:@"#EADDFF"]; }
- (UIColor *)onPrimaryContainer { return [self colorWithHex:@"#21005D"]; }

#pragma mark - Secondary

- (UIColor *)secondary { return [self colorWithHex:@"#625B71"]; }
- (UIColor *)onSecondary { return [UIColor whiteColor]; }
- (UIColor *)secondaryContainer { return [self colorWithHex:@"#E8DEF8"]; }
- (UIColor *)onSecondaryContainer { return [self colorWithHex:@"#1D192B"]; }

#pragma mark - Surface (Light theme as default - toggle later)

- (UIColor *)surface { return [self colorWithHex:@"#FFFBFE"]; }
- (UIColor *)onSurface { return [self colorWithHex:@"#1C1B1F"]; }
- (UIColor *)surfaceVariant { return [self colorWithHex:@"#E7E0EC"]; }
- (UIColor *)onSurfaceVariant { return [self colorWithHex:@"#49454F"]; }

- (UIColor *)background { return [self surface]; }
- (UIColor *)onBackground { return [self onSurface]; }

#pragma mark - Error

- (UIColor *)error { return [self colorWithHex:@"#B3261E"]; }
- (UIColor *)onError { return [UIColor whiteColor]; }

#pragma mark - Misc

- (UIColor *)outline { return [self colorWithHex:@"#79747E"]; }
- (UIColor *)shadow { return [UIColor colorWithWhite:0 alpha:0.15]; }

@end