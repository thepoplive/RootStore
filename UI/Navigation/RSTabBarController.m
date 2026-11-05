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

    // Placeholder VCs (will be replaced in Phase 3)
    NSMutableArray *vcs = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [[RSTheme shared] backgroundColor];
        UILabel *l = [[UILabel alloc] init];
        l.text = @[@"Главная", @"Репозитории", @"Поиск", @"Профиль"][i];
        l.font = [[RSTheme shared] titleFont];
        l.textColor = [[RSTheme shared] textColor];
        l.textAlignment = NSTextAlignmentCenter;
        [vc.view addSubview:l];
        l.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [NSLayoutConstraint constraintWithItem:l attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:vc.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:l attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:vc.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
        ]];
        [vcs addObject:vc];
    }
    self.viewControllers = vcs;

    // Container for child VCs
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];

    // Glass tab bar
    _tabBar = [[RSTabBar alloc] init];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];

    // Add first VC
    self.selectedIndex = RSTabIndexHome;

    // Theme observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:RSThemeDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged {
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    _containerView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat h = self.view.bounds.size.height;
    CGFloat tabBarH = 80.0;
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    }

    _tabBar.frame = CGRectMake(16, h - tabBarH - safeBottom - 16, self.view.bounds.size.width - 32, tabBarH);
    _tabBar.layer.cornerRadius = tabBarH / 2.0;
    _tabBar.backgroundColor = [[[RSTheme shared] cardColor] colorWithAlphaComponent:0.95];
    _tabBar.clipsToBounds = YES;

    _containerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, _tabBar.frame.origin.y - 16);
}

#pragma mark - RSTabBarDelegate

- (void)tabBar:(id)tabBar didSelectIndex:(RSTabIndex)index {
    UIViewController *vc = self.viewControllers[index];
    if (_currentVC == vc) return;

    // Transition
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