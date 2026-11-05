#import "RSSearchViewController.h"
#import "RSTheme.h"
#import "RSGlassView.h"
#import "RSGlassButton.h"
#import "RSGlassSegmentedControl.h"

@implementation RSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Поиск";
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    self.navigationController.navigationBarHidden = YES;

    CGFloat w = self.view.bounds.size.width;

    // Поле поиска
    RSGlassView *searchBox = [[RSGlassView alloc] initWithFrame:CGRectMake(16, 16, w - 32, 48)];
    searchBox.cornerRadius = 24;
    searchBox.enableHighlight = NO;

    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, w - 72, 24)];
    field.placeholder = @"Поиск пакетов...";
    field.font = [[RSTheme shared] bodyFont];
    field.textColor = [[RSTheme shared] textColor];
    [field setValue:[[RSTheme shared] secondaryTextColor] forKeyPath:@"placeholderColor"];
    [searchBox addSubview:field];
    [self.view addSubview:searchBox];

    // Кнопка поиска
    RSGlassButton *searchBtn = [[RSGlassButton alloc] init];
    [searchBtn setTitle:@"Поиск" forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(w - 100, 16, 84, 48);
    searchBtn.layer.cornerRadius = 24;
    [self.view addSubview:searchBtn];

    // Фильтры
    RSGlassSegmentedControl *filters = [[RSGlassSegmentedControl alloc] initWithItems:@[@"Все", @"Названия", @"Репо", @"По описанию"]];
    filters.frame = CGRectMake(16, 80, w - 32, 32);
    [self.view addSubview:filters];

    // Результаты (mock)
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 128, w, self.view.bounds.size.height - 128)];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scroll];

    NSArray *results = @[@"SBSettings", @"WinterBoard", @"Activator", @"Zeppelin", @"Filza", @"NewTerm"];
    CGFloat y = 16;
    for (NSString *name in results) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16, y, w - 32, 72)];
        card.cornerRadius = 12;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, w - 56, 20)];
        title.text = name;
        title.font = [[RSTheme shared] bodyFont];
        title.textColor = [[RSTheme shared] textColor];
        [card addSubview:title];

        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(12, 36, w - 56, 16)];
        desc.text = @"Описание твика...";
        desc.font = [[RSTheme shared] captionFont];
        desc.textColor = [[RSTheme shared] secondaryTextColor];
        [card addSubview:desc];

        UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake(w - 56, 12, 44, 16)];
        ver.text = @"1.0.0";
        ver.font = [[RSTheme shared] captionFont];
        ver.textColor = [[RSTheme shared] accentColor];
        [card addSubview:ver];

        [scroll addSubview:card];
        y += 88;
    }
    scroll.contentSize = CGSizeMake(w, y + 16);
}

@end