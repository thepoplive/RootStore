#import "AppDelegate.h"
#import "RSTheme.h"
#import "RSTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [[RSTheme shared] backgroundColor];
    self.window.rootViewController = [[RSTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end