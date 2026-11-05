#import "RSTabBar.h"
#import "RSTheme.h"

@interface RSTabBar ()
@property (nonatomic, strong) NSArray *buttons;
@end

@implementation RSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];

    NSArray *titles = @[@"Главная", @"Репозитории", @"Поиск", @"Профиль"];
    NSMutableArray *btns = [NSMutableArray array];

    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [[RSTheme shared] captionFont];
        [btn setTitleColor:[[RSTheme shared] secondaryTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateSelected];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleEdgeInsets = UIEdgeInsetsMake(24, -24, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setImage:[self iconForIndex:i] forState:UIControlStateNormal];
        [btn setImage:[self iconSelectedForIndex:i] forState:UIControlStateSelected];
        btn.tintColor = [[RSTheme shared] secondaryTextColor];
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btns addObject:btn];
    }
    self.buttons = btns;
    [self updateAppearance];
}

- (UIImage *)iconForIndex:(NSInteger)idx {
    CGSize s = CGSizeMake(24, 24);
    UIGraphicsBeginImageContextWithOptions(s, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *c = [[RSTheme shared] secondaryTextColor];
    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    CGPoint p = CGPointMake(12, 12);
    CGFloat m = 4;

    switch (idx) {
        case 0: { // house
            CGContextMoveToPoint(ctx, 4, 10);
            CGContextAddLineToPoint(ctx, 12, 4);
            CGContextAddLineToPoint(ctx, 20, 10);
            CGContextAddLineToPoint(ctx, 20, 20);
            CGContextAddLineToPoint(ctx, 4, 20);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 1: { // folder
            CGContextMoveToPoint(ctx, 3, 7);
            CGContextAddLineToPoint(ctx, 10, 7);
            CGContextAddLineToPoint(ctx, 12, 5);
            CGContextAddLineToPoint(ctx, 21, 5);
            CGContextAddLineToPoint(ctx, 21, 19);
            CGContextAddLineToPoint(ctx, 3, 19);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case 2: { // search
            CGContextAddArc(ctx, 9, 9, 5, 0, 2*M_PI, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 13, 13);
            CGContextAddLineToPoint(ctx, 19, 19);
            CGContextStrokePath(ctx);
            break;
        }
        case 3: { // person
            CGContextAddArc(ctx, 12, 7, 3, 0, 2*M_PI, 0);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx, 5, 19);
            CGContextAddCurveToPoint(ctx, 5, 14, 19, 14, 19, 19);
            CGContextStrokePath(ctx);
            break;
        }
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)iconSelectedForIndex:(NSInteger)idx {
    UIImage *img = [self iconForIndex:idx];
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width / 4.0;
    CGFloat h = self.bounds.size.height;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        self.buttons[i].frame = CGRectMake(i * w, 0, w, h);
    }
}

@end