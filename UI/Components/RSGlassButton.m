#import "RSGlassButton.h"
#import "RSTheme.h"

@implementation RSGlassButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self setup];
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 20.0;
    self.titleLabel.font = [[RSTheme shared] buttonFont];
    [self setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateNormal];
    self.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24);
    [self updateAppearance];
}

- (void)setIsPrimary:(BOOL)isPrimary {
    _isPrimary = isPrimary;
    [self updateAppearance];
}

- (void)updateAppearance {
    RSTheme *t = [RSTheme shared];
    if (_isPrimary) {
        self.backgroundColor = [t accentColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        // Glass style
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        [self setTitleColor:[t accentColor] forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = highlighted ? 0.7 : 1.0;
}

@end