#import "RSTabBar.h"
#import "RSTheme.h"

@interface RSTabBar ()
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *pill;
@property (nonatomic, assign) CGFloat tabWidth;
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, assign) CGFloat pillWidth;
@end

@implementation RSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    _barHeight = 52.0;
    _pillWidth = 60.0;

    _feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];

    // Glass blur background (серый овал)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _blurView.translatesAutoresizingMaskIntoConstraints = NO;
    _blurView.layer.cornerRadius = _barHeight / 2.0;
    _blurView.clipsToBounds = YES;
    [self addSubview:_blurView];

    // Inner highlight (edge highlight как в Liquid Glass)
    UIView *highlight = [[UIView alloc] init];
    highlight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    highlight.translatesAutoresizingMaskIntoConstraints = NO;
    highlight.layer.cornerRadius = _barHeight / 2.0;
    highlight.userInteractionEnabled = NO;
    [_blurView.contentView addSubview:highlight];

    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 12;
    self.layer.shadowOpacity = 0.3;

    // Pill (активный индикатор) - Liquid Glass style
    _pill = [[UIView alloc] init];
    _pill.backgroundColor = [[RSTheme shared] accentColor];
    _pill.layer.cornerRadius = _pillWidth / 2.0;
    _pill.layer.shadowColor = [UIColor blackColor].CGColor;
    _pill.layer.shadowOffset = CGSizeMake(0, 2);
    _pill.layer.shadowRadius = 6;
    _pill.layer.shadowOpacity = 0.4;
    _pill.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pill];

    // Кнопки
    NSArray *titles = @[@"", @"", @"", @""];
    NSMutableArray *btns = [NSMutableArray array];
    NSArray *icons = @[@0, @1, @2, @3];
    
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.tintColor = [[RSTheme shared] secondaryTextColor];
        [btn setImage:[self iconForIndex:i selected:NO] forState:UIControlStateNormal];
        [btn setImage:[self iconForIndex:i selected:YES] forState:UIControlStateSelected];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btns addObject:btn];
    }
    self.buttons = btns;

    // Pan gesture для pill
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pillDrag:)];
    [_pill addGestureRecognizer:pan];
    _pill.userInteractionEnabled = YES;

    // Layout constraints для blurView
    [NSLayoutConstraint activateConstraints:@[
        [_blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [_blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [_blurView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [_blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4],
        [highlight.leadingAnchor constraintEqualToAnchor:_blurView.contentView.leadingAnchor],
        [highlight.trailingAnchor constraintEqualToAnchor:_blurView.contentView.trailingAnchor],
        [highlight.topAnchor constraintEqualToAnchor:_blurView.contentView.topAnchor],
        [highlight.heightAnchor constraintEqualToConstant:18]
    ]];

    _selectedIndex = 0;
    [self updateAppearance];
}

- (UIImage *)iconForIndex:(NSInteger)idx selected:(BOOL)sel {
    CGSize s = CGSizeMake(24, 24);
    UIGraphicsBeginImageContextWithOptions(s, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *c = sel ? [UIColor whiteColor] : [[RSTheme shared] secondaryTextColor];
    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextSetLineWidth(ctx, 1.6);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    switch (idx) {
        case 0: { // home
            CGContextMoveToPoint(ctx, 5, 10);
            CGContextAddLineToPoint(ctx, 11, 5);
            CGContextAddLineToPoint(ctx, 17, 10);
            CGContextAddLineToPoint(ctx, 17, 17);
            CGContextAddLineToPoint(ctx, 5, 17);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 1: { // folder
            CGContextMoveToPoint(ctx, 4, 7);
            CGContextAddLineToPoint(ctx, 9, 7);
            CGContextAddLineToPoint(ctx, 11, 5);
            CGContextAddLineToPoint(ctx, 18, 5);
            CGContextAddLineToPoint(ctx, 18, 17);
            CGContextAddLineToPoint(ctx, 4, 17);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 2: { // search
            CGContextAddArc(ctx, 8, 8, 4, 0, 6.28, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 12, 12);
            CGContextAddLineToPoint(ctx, 17, 17);
            CGContextStrokePath(ctx);
            break;
        }
        case 3: { // person
            CGContextAddArc(ctx, 11, 7, 3, 0, 6.28, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 5, 17);
            CGContextAddCurveToPoint(ctx, 5, 13, 17, 13, 17, 17);
            CGContextStrokePath(ctx);
            break;
        }
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)btnTapped:(UIButton *)sender {
    self.selectedIndex = (RSTabIndex)sender.tag;
    [_feedback impactOccurred];
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:self.selectedIndex];
    }
}

- (void)pillDrag:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [_feedback impactOccurred];
    }
    
    CGPoint translation = [gesture translationInView:self];
    CGFloat newX = _pill.center.x + translation.x;
    
    CGFloat minX = _pill.bounds.size.width / 2.0 + 20;
    CGFloat maxX = self.bounds.size.width - _pill.bounds.size.width / 2.0 - 20;
    newX = MIN(MAX(newX, minX), maxX);
    
    _pill.center = CGPointMake(newX, _pill.center.y);
    [gesture setTranslation:CGPointZero inView:self];

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        NSInteger nearest = [self nearestTabToX:_pill.center.x];
        
        // Snap анимация
        UIButton *btn = self.buttons[nearest];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.pill.center = CGPointMake(btn.center.x, self.pill.center.y);
        } completion:^(BOOL finished) {
            if (nearest != self.selectedIndex) {
                self.selectedIndex = nearest;
                [self->_feedback impactOccurred];
                if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
                    [self.delegate tabBar:self didSelectIndex:self.selectedIndex];
                }
            }
        }];
    }
}

- (NSInteger)nearestTabToX:(CGFloat)x {
    NSInteger nearest = 0;
    CGFloat minDist = CGFLOAT_MAX;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        CGFloat btnCenter = btn.center.x;
        CGFloat dist = fabs(x - btnCenter);
        if (dist < minDist) {
            minDist = dist;
            nearest = i;
        }
    }
    return nearest;
}

- (void)setSelectedIndex:(RSTabIndex)selectedIndex {
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    
    UIButton *btn = self.buttons[selectedIndex];
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pill.center = CGPointMake(btn.center.x, self.pill.center.y);
    } completion:nil];
    
    [self updateButtons];
}

- (void)updateButtons {
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        BOOL sel = (i == _selectedIndex);
        btn.selected = sel;
        btn.tintColor = sel ? [UIColor whiteColor] : [[RSTheme shared] secondaryTextColor];
        [btn setImage:[self iconForIndex:i selected:sel] forState:UIControlStateNormal];
    }
}

- (void)updateAppearance {
    [self updateButtons];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    // Buttons centered in bar
    CGFloat btnW = (w - 40) / 4.0;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(20 + i * btnW + (btnW - 24) / 2, (h - 24) / 2, 24, 24);
    }

    // Pill centered on selected button
    UIButton *selBtn = self.buttons[_selectedIndex];
    _pill.bounds = CGRectMake(0, 0, _pillWidth, h - 16);
    _pill.center = CGPointMake(selBtn.center.x, h / 2.0);
}

@end