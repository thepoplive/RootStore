#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSGlassView : UIView

@property (nonatomic, strong, nullable) UIColor *tintColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL enableHighlight;
@property (nonatomic, assign) BOOL enableShadow;

@end

NS_ASSUME_NONNULL_END