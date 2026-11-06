#import "RSTabBarController.h"
#import "RSTheme.h"

@interface RSTabBarController () <RSTabBarDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) RSTabBar *tabBar;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation RSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];

    // 4 простых placeholder VC
    NSMutableArray *vcs = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [[RSTheme shared] backgroundColor];
        UILabel *l = [[UILabel alloc] init];
        l.text = @[@"Главная", @"Репозитории", @"Поиск", @"Профиль"][i];
        l.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        l.textColor = [[RSTheme shared] textColor];
        l.frame = CGRectMake(0, 200, self.view.bounds.size.width, 40);
        l.textAlignment = NSTextAlignmentCenter;
        [vc.view addSubview:l];
        [vcs addObject:vc];
    }
    self.viewControllers = vcs;

    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];

    _tabBar = [[RSTabBar alloc] init];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];

    self.selectedIndex = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:RSThemeDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged {
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    _containerView.backgroundColor = [UIColor clearColor];
    [_tabBar setNeedsLayout];
    [_tabBar layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat h = self.view.bounds.size.height;
    CGFloat tabBarH = 60.0;

    _tabBar.frame = CGRectMake(0, h - tabBarH - 8, self.view.bounds.size.width, tabBarH);
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    _containerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, _tabBar.frame.origin.y - 8);
}

#pragma mark - RSTabBarDelegate

- (void)tabBar:(id)tabBar didSelectIndex:(RSTabIndex)index {
    UIViewController *vc = self.viewControllers[index];
    if (_currentVC == vc) return;

    UIViewController *from = _currentVC;
    UIViewController *to = vc;
    _currentVC = to;

    [from willMoveToParentViewController:nil];
    [from.view removeFromSuperview];
    [from removeFromParentViewController];

    [self addChildViewController:to];
    to.view.frame = _containerView.bounds;
    [_containerView addSubview:to.view];
    [to didMoveToParentViewController:self];
}

@end