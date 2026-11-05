#import "RSRootViewController.h"

@implementation RSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.059 green:0.055 blue:0.078 alpha:1.0];

    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"RootStore";
    title.font = [UIFont boldSystemFontOfSize:34.0];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];

    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.text = [NSString stringWithFormat:@"версия %@", version];
    subtitle.font = [UIFont systemFontOfSize:14.0];
    subtitle.textColor = [UIColor colorWithWhite:0.62 alpha:1.0];
    subtitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subtitle];

    UILabel *status = [[UILabel alloc] init];
    // TODO(phase-3): replace with real tab navigation + screens.
    status.text = @"Phase 1: сборка и упаковка.\nИнтерфейс — Phase 2–3.";
    status.font = [UIFont systemFontOfSize:13.0];
    status.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    status.textAlignment = NSTextAlignmentCenter;
    status.numberOfLines = 0;
    [self.view addSubview:status];

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    title.frame = CGRectMake(16.0, h * 0.32, w - 32.0, 44.0);
    subtitle.frame = CGRectMake(16.0, title.frame.origin.y + 50.0, w - 32.0, 20.0);
    status.frame = CGRectMake(24.0, h - 90.0, w - 48.0, 44.0);
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    subtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    status.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
