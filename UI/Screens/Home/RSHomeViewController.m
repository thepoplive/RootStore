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

    CGFloat y = 16;
    CGFloat w = scroll.frame.size.width - 32;

    // Недавно добавленные репозитории
    y = [self addSectionTitle:@"Недавно добавленные репозитории" y:y toScroll:scroll];
    y = [self addRepoCards:y toScroll:scroll width:w];

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
    l.font = [[RSTheme shared] titleFont];
    l.textColor = [[RSTheme shared] textColor];
    [scroll addSubview:l];

    if (btnTitle) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTitle:btnTitle forState:UIControlStateNormal];
        b.titleLabel.font = [[RSTheme shared] captionFont];
        [b setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateNormal];
        b.frame = CGRectMake(scroll.frame.size.width - 120, y, 110, 30);
        [scroll addSubview:b];
    }

    return y + 36;
}

- (CGFloat)addRepoCards:(CGFloat)y toScroll:(UIScrollView *)scroll width:(CGFloat)w {
    CGFloat cardW = (w - 12 * 3) / 4;
    NSArray *names = @[@"BigBoss", @"ModMyi", @"Chariz", @"Elucubratus"];
    for (NSInteger i = 0; i < 4; i++) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16 + i * (cardW + 12), y, cardW, 100)];
        card.cornerRadius = 16;
        card.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(4, 40, cardW - 8, 20)];
        title.text = names[i];
        title.font = [[RSTheme shared] buttonFont];
        title.textColor = [[RSTheme shared] textColor];
        title.textAlignment = NSTextAlignmentCenter;
        [card addSubview:title];
        [scroll addSubview:card];
    }
    return y + 116;
}

- (CGFloat)addItemCards:(CGFloat)y section:(NSString *)type toScroll:(UIScrollView *)scroll width:(CGFloat)w {
    NSArray *names;
    if ([type isEqualToString:@"tweak"]) names = @[@"SBSettings", @"Zeppelin", @"WinterBoard"];
    else if ([type isEqualToString:@"app"]) names = @[@"Filza", @"NewTerm", @"iFile"];
    else if ([type isEqualToString:@"game"]) names = @[@"Flappy Bird", @"Pokemon GO", @"Crossy Road"];
    else names = @[@"SnowBoard", @"Anemone", @"Whiteshift"];

    for (NSInteger i = 0; i < 3; i++) {
        RSGlassView *card = [[RSGlassView alloc] initWithFrame:CGRectMake(16, y + i * 88, w, 72)];
        card.cornerRadius = 12;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, w - 24, 20)];
        title.text = names[i];
        title.font = [[RSTheme shared] bodyFont];
        title.textColor = [[RSTheme shared] textColor];
        [card addSubview:title];

        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(12, 36, w - 24, 16)];
        desc.text = @"Описание пакета...";
        desc.font = [[RSTheme shared] captionFont];
        desc.textColor = [[RSTheme shared] secondaryTextColor];
        [card addSubview:desc];

        [scroll addSubview:card];
    }
    return y + 3 * 88 + 24;
}

@end