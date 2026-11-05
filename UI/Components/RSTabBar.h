#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RSTabIndex) {
    RSTabIndexHome = 0,
    RSTabIndexRepos,
    RSTabIndexSearch,
    RSTabIndexProfile
};

@protocol RSTabBarDelegate <NSObject>
- (void)tabBar:(id)tabBar didSelectIndex:(RSTabIndex)index;
@end

@interface RSTabBar : UIView

@property (nonatomic, weak, nullable) id<RSTabBarDelegate> delegate;
@property (nonatomic, assign) RSTabIndex selectedIndex;

@end

NS_ASSUME_NONNULL_END