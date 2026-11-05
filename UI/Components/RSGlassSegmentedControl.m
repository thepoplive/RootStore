#import "RSGlassSegmentedControl.h"
#import "RSTheme.h"

@implementation RSGlassSegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    if (self) [self setup];
    return self;
}

- (void)setup {
    RSTheme *t = [RSTheme shared];
    self.backgroundColor = [UIColor clearColor];
    if (@available(iOS 13.0, *)) {
        self.selectedSegmentTintColor = [t accentColor];
    } else {
        self.tintColor = [t accentColor];
    }

    NSDictionary *normal = @{
        NSForegroundColorAttributeName: [t textColor],
        NSFontAttributeName: [t buttonFont]
    };
    NSDictionary *selected = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [t buttonFont]
    };
    [self setTitleTextAttributes:normal forState:UIControlStateNormal];
    [self setTitleTextAttributes:selected forState:UIControlStateSelected];
}

@end