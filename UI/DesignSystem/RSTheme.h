#import <UIKit/UIKit.h>
#import "RSColorPalette.h"

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const RSThemeDidChangeNotification;

@interface RSTheme : NSObject

+ (instancetype)shared;

@property (nonatomic, readonly) BOOL isDark;
- (void)setDarkMode:(BOOL)dark;

- (UIColor *)backgroundColor;
- (UIColor *)textColor;
- (UIColor *)secondaryTextColor;
- (UIColor *)cardColor;
- (UIColor *)accentColor;

- (UIFont *)headlineFont;   // 32pt Bold
- (UIFont *)titleFont;      // 22pt Medium
- (UIFont *)bodyFont;       // 16pt Regular
- (UIFont *)captionFont;    // 12pt Regular
- (UIFont *)buttonFont;     // 14pt Medium

@end

NS_ASSUME_NONNULL_END