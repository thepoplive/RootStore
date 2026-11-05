#import "RSGlassView.h"
#import "RSTheme.h"

@implementation RSGlassView {
    UIVisualEffectView *_blurView;
    CAGradientLayer *_gradientLayer;
    CALayer *_highlightLayer;
    CALayer *_shadowLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    return self;
}

- (void)commonInit {
    self.clipsToBounds = NO;
    _cornerRadius = 20.0;
    _enableHighlight = YES;
    _enableShadow = YES;
    self.backgroundColor = [UIColor clearColor];

    // Blur effect (iOS 8+)
    UIBlurEffectStyle blurStyle = UIBlurEffectStyleLight;
    if (@available(iOS 13.0, *)) {
        blurStyle = UIBlurEffectStyleSystemThinMaterialLight;
    }
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:blurStyle];
    _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _blurView.translatesAutoresizingMaskIntoConstraints = NO;
    _blurView.layer.cornerRadius = _cornerRadius;
    _blurView.clipsToBounds = YES;
    [self addSubview:_blurView];

    // Gradient overlay (subtle tint)
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[
        (id)[[UIColor colorWithWhite:1.0 alpha:0.1] CGColor],
        (id)[[UIColor colorWithWhite:0.9 alpha:0.05] CGColor]
    ];
    _gradientLayer.locations = @[@0.0, @0.3];
    _gradientLayer.cornerRadius = _cornerRadius;
    [_blurView.contentView.layer addSublayer:_gradientLayer];

    // Inner highlight (top edge)
    _highlightLayer = [CALayer layer];
    _highlightLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    _highlightLayer.cornerRadius = _cornerRadius;
    [_blurView.contentView.layer addSublayer:_highlightLayer];

    // Shadow
    _shadowLayer = [CALayer layer];
    _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    _shadowLayer.shadowOffset = CGSizeMake(0, 4);
    _shadowLayer.shadowRadius = 12.0;
    _shadowLayer.shadowOpacity = 0.15;
    [self.layer insertSublayer:_shadowLayer below:_blurView.layer];

    // Border
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;

    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = self.bounds;

    _blurView.frame = bounds;
    _gradientLayer.frame = bounds;
    _highlightLayer.frame = CGRectMake(0, 0, bounds.size.width, 1);
    _shadowLayer.frame = bounds;
    _shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:_cornerRadius].CGPath;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _blurView.layer.cornerRadius = cornerRadius;
    _gradientLayer.cornerRadius = cornerRadius;
    _highlightLayer.cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    _shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
}

- (void)setEnableHighlight:(BOOL)enableHighlight {
    _enableHighlight = enableHighlight;
    _highlightLayer.hidden = !enableHighlight;
}

- (void)setEnableShadow:(BOOL)enableShadow {
    _enableShadow = enableShadow;
    _shadowLayer.hidden = !enableShadow;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (tintColor) {
        self.layer.borderColor = [tintColor colorWithAlphaComponent:0.3].CGColor;
    }
}

@end