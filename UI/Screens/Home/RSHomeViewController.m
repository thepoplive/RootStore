#import "RSHomeViewController.h"
#import "RSTheme.h"
#import "RSGlassView.h"
#import "RSGlassButton.h"

@implementation RSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Главная";
    self.view.backgroundColor = [[RSTheme shared] backgroundColor];
    self.navigationController.navigationBarHidden = YES;

    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scroll];

    CGFloat w = scroll.frame.size.width;
    CGFloat y = 16;

    // Заголовок RootStore по центру
    UILabel *appTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, y, w - 32, 44)];
    appTitle.text = @"RootStore";
    appTitle.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    appTitle.textColor = [[RSTheme shared] textColor];
    appTitle.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:appTitle];
    y += 50;

    // Версия
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, y, w - 32, 18)];
    verLabel.text = [NSString stringWithFormat:@"Версия %@", version];
    verLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    verLabel.textColor = [[RSTheme shared] secondaryTextColor];
    verLabel.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:verLabel];
    y += 32;

    // Новинки (вместо "Недавно добавленные")
    y = [self addSectionTitle:@"Новинки" y:y toScroll:scroll];
    y = [self addTwoBigCards:y toScroll:scroll width:w];

    // Твики
    y = [self addSectionTitle:@"Твики" withButton:@"Открыть весь список" y:y toScroll:scroll];
    y = [self addItemCards:y section:@"tweak" toScroll:scroll width:w];

    // Приложения
    y = [self addSectionTitle:@"Приложения" withButton:@"Открыть весь список" y:y toScroll:scroll];
    y = [self addItemCards:y section:@"app" toScroll:scroll width:w];

    // Игры
    y = [self addSectionTitle:@"Игры" withButton:@"Открыть весь список" y:y toScroll:scroll];
    y = [self addItemCards:y section:@"game" toScroll:scroll width:w];

    // Темы
    y = [self addSectionTitle:@"Темы" withButton:@"Открыть весь список" y:y toScroll:scroll];
    y = [self addItemCards:y section:@"theme" toScroll:scroll width:w];

    scroll.contentSize = CGSizeMake(scroll.frame.size.width, y + 16);
}

- (CGFloat)addSectionTitle:(NSString *)title y:(CGFloat)y toScroll:(UIScrollView *)scroll {
    return [self addSectionTitle:title withButton:nil y:y toScroll:scroll];
}

- (CGFloat)addSectionTitle:(NSString *)title withButton:(NSString *)btnTitle y:(CGFloat)y toScroll:(UIScrollView *)scroll {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(16, y, scroll.frame.size.width - 32, 30)];
    l.text = title;
    l.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    l.textColor = [[RSTheme shared] textColor];
    [scroll addSubview:l];

    if (btnTitle) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTitle:btnTitle forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [b setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateNormal];
        b.frame = CGRectMake(scroll.frame.size.width - 120, y, 110, 30);
        [scroll addSubview:b];
    }

    return y + 36;
}

- (CGFloat)addTwoBigCards:(CGFloat)y toScroll:(UIScrollView *)scroll width:(CGFloat)w {
    CGFloat cardW = (w - 16 * 3) / 2.0;
    CGFloat cardH = 90.0;
    NSArray *names = @[@"Chariz", @"ZodTTD"];

    for (NSInteger i = 0; i < 2; i++) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16 + i * (cardW + 16), y, cardW, cardH)];
        card.cornerRadius = 16;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, cardW - 24, 24)];
        title.text = names[i];
        title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        title.textColor = [[RSTheme shared] textColor];
        [card addSubview:title];

        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, cardW - 24, 30)];
        desc.text = @"Стабильные пакеты";
        desc.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        desc.textColor = [[RSTheme shared] secondaryTextColor];
        desc.numberOfLines = 2;
        [card addSubview:desc];

        [scroll addSubview:card];
    }
    return y + cardH + 24;
}

- (CGFloat)addItemCards:(CGFloat)y section:(NSString *)type toScroll:(UIScrollView *)scroll width:(CGFloat)w {
    NSArray *names;
    if ([type isEqualToString:@"tweak"]) names = @[@"SBSettings", @"Zeppelin", @"WinterBoard"];
    else if ([type isEqualToString:@"app"]) names = @[@"Filza", @"NewTerm", @"iFile"];
    else if ([type isEqualToString:@"game"]) names = @[@"Flappy Bird", @"Pokemon GO", @"Crossy Road"];
    else names = @[@"SnowBoard", @"Anemone", @"Whiteshift"];

    for (NSInteger i = 0; i < 3; i++) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16, y + i * 80, w - 32, 64)];
        card.cornerRadius = 14;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, w - 80, 20)];
        title.text = names[i];
        title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        title.textColor = [[RSTheme shared] textColor];
        [card addSubview:title];

        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(16, 34, w - 80, 16)];
        desc.text = @"Описание пакета...";
        desc.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        desc.textColor = [[RSTheme shared] secondaryTextColor];
        [card addSubview:desc];

        [scroll addSubview:card];
    }
    return y + 3 * 80 + 24;
}

@end