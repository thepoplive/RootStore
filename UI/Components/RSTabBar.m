#import "RSTabBar.h"
#import "RSTheme.h"

@interface RSTabBar ()
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *pill;
@property (nonatomic, assign) CGFloat tabWidth;
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, assign) CGFloat pillHeight;
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;
@end

@implementation RSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    _barHeight = 58.0;
    _pillHeight = 44.0;

    _feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];

    // Кнопки
    NSArray *titles = @[@"Главная", @"Репозитории", @"Поиск", @"Профиль"];
    NSMutableArray *btns = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
        [btn setTitleColor:[[RSTheme shared] secondaryTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tintColor = [[RSTheme shared] secondaryTextColor];
        [btn setImage:[self iconForIndex:i selected:NO] forState:UIControlStateNormal];
        [btn setImage:[self iconForIndex:i selected:YES] forState:UIControlStateSelected];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleEdgeInsets = UIEdgeInsetsMake(24, -24, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btns addObject:btn];
    }
    self.buttons = btns;

    // Pill (капля)
    _pill = [[UIView alloc] init];
    _pill.backgroundColor = [[RSTheme shared] accentColor];
    _pill.layer.cornerRadius = _pillHeight / 2.0;
    _pill.layer.shadowColor = [UIColor blackColor].CGColor;
    _pill.layer.shadowOffset = CGSizeMake(0, 2);
    _pill.layer.shadowRadius = 6;
    _pill.layer.shadowOpacity = 0.25;
    [self insertSubview:_pill belowSubview:self.buttons[0]];

    // Pan gesture для перетаскивания pill
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pillDrag:)];
    [_pill addGestureRecognizer:pan];
    _pill.userInteractionEnabled = YES;

    _selectedIndex = 0;
    [self updateAppearance];
}

- (UIImage *)iconForIndex:(NSInteger)idx selected:(BOOL)sel {
    CGSize s = CGSizeMake(22, 22);
    UIGraphicsBeginImageContextWithOptions(s, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *c = sel ? [UIColor whiteColor] : [[RSTheme shared] secondaryTextColor];
    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextSetLineWidth(ctx, 1.6);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    switch (idx) {
        case 0: {
            CGContextMoveToPoint(ctx, 5, 10);
            CGContextAddLineToPoint(ctx, 11, 5);
            CGContextAddLineToPoint(ctx, 17, 10);
            CGContextAddLineToPoint(ctx, 17, 17);
            CGContextAddLineToPoint(ctx, 5, 17);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 1: {
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
        case 2: {
            CGContextAddArc(ctx, 8, 8, 4, 0, 6.28, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 12, 12);
            CGContextAddLineToPoint(ctx, 17, 17);
            CGContextStrokePath(ctx);
            break;
        }
        case 3: {
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
    CGPoint translation = [gesture translationInView:self];
    CGFloat newX = _pill.center.x + translation.x;
    CGFloat minX = _pill.bounds.size.width / 2.0 + 4;
    CGFloat maxX = self.bounds.size.width - _pill.bounds.size.width / 2.0 - 4;
    newX = MIN(MAX(newX, minX), maxX);
    _pill.center = CGPointMake(newX, _pill.center.y);
    [gesture setTranslation:CGPointZero inView:self];

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        NSInteger nearest = [self nearestTabToX:_pill.center.x];
        if (nearest != _selectedIndex) {
            _selectedIndex = nearest;
            [_feedback impactOccurred];
            if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
                [self.delegate tabBar:self didSelectIndex:_selectedIndex];
            }
        }
        [self animatePillToSelected];
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
    [self animatePillToSelected];
    [self updateButtons];
}

- (void)animatePillToSelected {
    UIButton *btn = self.buttons[_selectedIndex];
    CGFloat targetX = btn.center.x;

    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pill.center = CGPointMake(targetX, self.pill.center.y);
    } completion:nil];
}

- (void)updateButtons {
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.selected = (i == _selectedIndex);
        [btn setImage:[self iconForIndex:i selected:(i == _selectedIndex)] forState:UIControlStateNormal];
    }
}

- (void)updateAppearance {
    [self updateButtons];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat barInset = 24.0;
    CGFloat availableW = w - barInset * 2;
    _tabWidth = availableW / 4.0;

    // Кнопки по центру
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(barInset + i * _tabWidth, 0, _tabWidth, h);
    }

    // Pill
    _pill.bounds = CGRectMake(0, 0, _tabWidth - 4, _pillHeight);
    UIButton *selBtn = self.buttons[_selectedIndex];
    _pill.center = CGPointMake(selBtn.center.x, h / 2.0);
}

@end