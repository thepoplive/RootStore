#import "AppDelegate.h"
#import "RSTheme.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [[RSTheme shared] backgroundColor];
    
    // Simple test view
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [[RSTheme shared] backgroundColor];
    
    UILabel *l = [[UILabel alloc] init];
    l.text = @"RootStore Test";
    l.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    l.textColor = [[RSTheme shared] textColor];
    l.frame = CGRectMake(0, 200, self.window.bounds.size.width, 40);
    l.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:l];
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end