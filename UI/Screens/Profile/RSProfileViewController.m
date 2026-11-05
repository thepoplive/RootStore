#import "RSProfileViewController.h"
#import "RSTheme.h"
#import "RSGlassView.h"

@implementation RSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Профиль";
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    self.navigationController.navigationBarHidden = YES;

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    // Заголовок - название приложения
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, w - 32, 44)];
    appName.text = @"RootStore";
    appName.font = [[RSTheme shared] headlineFont];
    appName.textColor = [[RSTheme shared] textColor];
    appName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appName];

    // Версия
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 110, w - 32, 20)];
    verLabel.text = [NSString stringWithFormat:@"Версия %@", version];
    verLabel.font = [[RSTheme shared] bodyFont];
    verLabel.textColor = [[RSTheme shared] secondaryTextColor];
    verLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verLabel];

    // Ссылка на GitHub
    RSGlassView *githubCard = [[RSGlassView alloc] initWithFrame:CGRectMake(16, 160, w - 32, 60)];
    githubCard.cornerRadius = 16;
    githubCard.enableShadow = NO;

    UILabel *githubTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, w - 56, 20)];
    githubTitle.text = @"GitHub";
    githubTitle.font = [[RSTheme shared] bodyFont];
    githubTitle.textColor = [[RSTheme shared] textColor];
    [githubCard addSubview:githubTitle];

    UILabel *githubUrl = [[UILabel alloc] initWithFrame:CGRectMake(12, 34, w - 56, 16)];
    githubUrl.text = @"github.com/thepoplive/RootStore";
    githubUrl.font = [[RSTheme shared] captionFont];
    githubUrl.textColor = [[RSTheme shared] accentColor];
    [githubCard addSubview:githubUrl];

    [self.view addSubview:githubCard];

    // Футер
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(16, h - 80, w - 32, 40)];
    footer.text = @"Сделано blxckfvde, с любовью <3";
    footer.font = [[RSTheme shared] captionFont];
    footer.textColor = [[RSTheme shared] secondaryTextColor];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.numberOfLines = 0;
    [self.view addSubview:footer];
}

@end