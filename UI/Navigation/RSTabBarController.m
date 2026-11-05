#import "RSTabBarController.h"
#import "RSTheme.h"
#import "RSHomeViewController.h"
#import "RSRepositoriesViewController.h"
#import "RSSearchViewController.h"
#import "RSProfileViewController.h"

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

    // Placeholder VCs replaced by real ones
    NSArray *classes = @[[RSHomeViewController class], [RSRepositoriesViewController class],
                         [RSSearchViewController class], [RSProfileViewController class]];
    NSMutableArray *vcs = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *vc = [[classes[i] alloc] init];
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
    self.tabBar.selectedIndex = RSTabIndexHome;
    UIViewController *first = self.viewControllers[RSTabIndexHome];
    self.currentVC = first;
    [self addChildViewController:first];
    first.view.frame = _containerView.bounds;
    [_containerView addSubview:first.view];
    [first didMoveToParentViewController:self];

    // Theme observer
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