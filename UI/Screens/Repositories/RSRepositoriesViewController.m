#import "RSRepositoriesViewController.h"
#import "RSTheme.h"
#import "RSGlassView.h"
#import "RSGlassButton.h"
#import "RSGlassSegmentedControl.h"

@implementation RSRepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Репозитории";
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    self.navigationController.navigationBarHidden = YES;

    // Верхние кнопки
    UIStackView *topBtns = [[UIStackView alloc] initWithFrame:CGRectMake(16, 16, self.view.bounds.size.width - 32, 44)];
    topBtns.axis = UILayoutConstraintAxisHorizontal;
    topBtns.distribution = UIStackViewDistributionFillEqually;
    topBtns.spacing = 12;

    RSGlassButton *updateBtn = [[RSGlassButton alloc] init];
    [updateBtn setTitle:@"Обновить" forState:UIControlStateNormal];
    [topBtns addArrangedSubview:updateBtn];

    RSGlassButton *editBtn = [[RSGlassButton alloc] init];
    [editBtn setTitle:@"Изменить" forState:UIControlStateNormal];
    [topBtns addArrangedSubview:editBtn];

    [self.view addSubview:topBtns];

    // Сегменты
    RSGlassSegmentedControl *seg = [[RSGlassSegmentedControl alloc] initWithItems:@[@"Разделы", @"Весь список"]];
    seg.frame = CGRectMake(16, 76, self.view.bounds.size.width - 32, 32);
    [self.view addSubview:seg];

    // Список репозиториев
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height - 120)];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scroll];

    NSArray *repos = @[@"BigBoss", @"ModMyi", @"Chariz", @"Elucubratus", @"ZodTTD"];
    CGFloat y = 16;
    for (NSString *name in repos) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16, y, scroll.bounds.size.width - 32, 80)];
        card.cornerRadius = 16;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, card.bounds.size.width - 24, 20)];
        title.text = name;
        title.font = [[RSTheme shared] bodyFont];
        title.textColor = [[RSTheme shared] textColor];
        [card addSubview:title];

        UILabel *url = [[UILabel alloc] initWithFrame:CGRectMake(12, 36, card.bounds.size.width - 24, 16)];
        url.text = [NSString stringWithFormat:@"https://%@.getsu.org", [name lowercaseString]];
        url.font = [[RSTheme shared] captionFont];
        url.textColor = [[RSTheme shared] secondaryTextColor];
        [card addSubview:url];

        [scroll addSubview:card];
        y += 96;
    }
    scroll.contentSize = CGSizeMake(scroll.bounds.size.width, y + 16);
}

@end