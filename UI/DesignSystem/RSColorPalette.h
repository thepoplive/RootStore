#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSColorPalette : NSObject

@property (nonatomic, readonly) UIColor *primary;          // #6750A4 (MD3 Purple)
@property (nonatomic, readonly) UIColor *onPrimary;        // #FFFFFF
@property (nonatomic, readonly) UIColor *primaryContainer; // #EADDFF
@property (nonatomic, readonly) UIColor *onPrimaryContainer;

@property (nonatomic, readonly) UIColor *secondary;        // #625B71
@property (nonatomic, readonly) UIColor *onSecondary;      // #FFFFFF
@property (nonatomic, readonly) UIColor *secondaryContainer;
@property (nonatomic, readonly) UIColor *onSecondaryContainer;

@property (nonatomic, readonly) UIColor *surface;          // #FFFBFE (light) / #1C1B1F (dark)
@property (nonatomic, readonly) UIColor *onSurface;
@property (nonatomic, readonly) UIColor *surfaceVariant;   // #E7E0EC
@property (nonatomic, readonly) UIColor *onSurfaceVariant;

@property (nonatomic, readonly) UIColor *background;
@property (nonatomic, readonly) UIColor *onBackground;

@property (nonatomic, readonly) UIColor *error;            // #B3261E
@property (nonatomic, readonly) UIColor *onError;

@property (nonatomic, readonly) UIColor *outline;          // #79747E
@property (nonatomic, readonly) UIColor *shadow;

+ (instancetype)shared;

- (UIColor *)colorWithHex:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END