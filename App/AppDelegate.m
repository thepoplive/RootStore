#import "AppDelegate.h"
#import "RSRootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.059 green:0.055 blue:0.078 alpha:1.0];
    self.window.rootViewController = [[RSRootViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
