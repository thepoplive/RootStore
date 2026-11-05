#import "RSTabBar.h"
#import "RSTheme.h"
#import "RSGlassView.h"

@interface RSTabBar ()
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) RSGlassView *glassContainer;
@property (nonatomic, strong) UIView *selectionIndicator;
@end

@implementation RSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];

    // Glass контейнер - плавающая капсула
    _glassContainer = [[RSGlassView alloc] init];
    _glassContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _glassContainer.cornerRadius = 28;
    _glassContainer.enableShadow = YES;
    _glassContainer.clipsToBounds = NO;
    [self addSubview:_glassContainer];

    NSArray *titles = @[@"Главная", @"Репозитории", @"Поиск", @"Профиль"];
    NSMutableArray *btns = [NSMutableArray array];

    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        btn.titleLabel.numberOfLines = 1;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.minimumScaleFactor = 0.7;
        [btn setTitleColor:[[RSTheme shared] secondaryTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateSelected];
        btn.tintColor = [[RSTheme shared] secondaryTextColor];
        [btn setImage:[self iconForIndex:i selected:NO] forState:UIControlStateNormal];
        [btn setImage:[self iconForIndex:i selected:YES] forState:UIControlStateSelected];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleEdgeInsets = UIEdgeInsetsMake(2, -24, -16, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 14, 0);
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_glassContainer addSubview:btn];
        [btns addObject:btn];
    }
    self.buttons = btns;

    // Индикатор выбора (точка)
    _selectionIndicator = [[UIView alloc] init];
    _selectionIndicator.backgroundColor = [[RSTheme shared] accentColor];
    _selectionIndicator.layer.cornerRadius = 4;
    [_glassContainer addSubview:_selectionIndicator];

    [self updateAppearance];
}

- (UIImage *)iconForIndex:(NSInteger)idx selected:(BOOL)sel {
    CGSize s = CGSizeMake(24, 24);
    UIGraphicsBeginImageContextWithOptions(s, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *c = sel ? [[RSTheme shared] accentColor] : [[RSTheme shared] secondaryTextColor];
    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextSetLineWidth(ctx, 1.8);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    switch (idx) {
        case 0: { // house
            CGContextMoveToPoint(ctx, 5, 11);
            CGContextAddLineToPoint(ctx, 12, 5);
            CGContextAddLineToPoint(ctx, 19, 11);
            CGContextAddLineToPoint(ctx, 19, 19);
            CGContextAddLineToPoint(ctx, 5, 19);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 1: { // folder
            CGContextMoveToPoint(ctx, 4, 8);
            CGContextAddLineToPoint(ctx, 10, 8);
            CGContextAddLineToPoint(ctx, 12, 6);
            CGContextAddLineToPoint(ctx, 20, 6);
            CGContextAddLineToPoint(ctx, 20, 18);
            CGContextAddLineToPoint(ctx, 4, 18);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 2: { // search
            CGContextAddArc(ctx, 9, 9, 5, 0, 6.28, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 14, 14);
            CGContextAddLineToPoint(ctx, 19, 19);
            CGContextStrokePath(ctx);
            break;
        }
        case 3: { // person
            CGContextAddArc(ctx, 12, 8, 3, 0, 6.28, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 6, 19);
            CGContextAddCurveToPoint(ctx, 6, 15, 18, 15, 18, 19);
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
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:self.selectedIndex];
    }
}

- (void)setSelectedIndex:(RSTabIndex)selectedIndex {
    _selectedIndex = selectedIndex;
    [self updateAppearance];
}

- (void)updateAppearance {
    RSTheme *t = [RSTheme shared];
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        BOOL sel = (i == _selectedIndex);
        btn.selected = sel;
        btn.tintColor = sel ? [t accentColor] : [t secondaryTextColor];
    }

    // Анимация индикатора
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat glassH = h - 4; // отступы сверху/снизу

    // Контейнер - плавающая капсула
    _glassContainer.frame = CGRectMake(8, 2, w - 16, glassH);
    _glassContainer.layer.cornerRadius = glassH / 2;

    CGFloat btnW = (w - 16) / 4.0;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, glassH);
    }

    // Индикатор - точка под выбранной кнопкой
    if (self.buttons.count > 0 && _selectedIndex < (NSInteger)self.buttons.count) {
        CGFloat indicatorW = 6;
        CGFloat indicatorX = _selectedIndex * btnW + (btnW - indicatorW) / 2;
        _selectionIndicator.frame = CGRectMake(indicatorX + 8, glassH - 10, indicatorW, indicatorW);
    }
}

@end