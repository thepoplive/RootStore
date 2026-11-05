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
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scroll];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 24;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:stack];

    // Sections
    [stack addArrangedSubview:[self sectionHeader:@"Недавно добавленные репозитории"]];
    [stack addArrangedSubview:[self repoCards]];

    [stack addArrangedSubview:[self sectionHeader:@"Твики" withButton:@"Открыть весь список"]];
    [stack addArrangedSubview:[self itemCards:@"tweak"]];

    [stack addArrangedSubview:[self sectionHeader:@"Приложения" withButton:@"Открыть весь список"]];
    [stack addArrangedSubview:[self itemCards:@"app"]];

    [stack addArrangedSubview:[self sectionHeader:@"Игры" withButton:@"Открыть весь список"]];
    [stack addArrangedSubview:[self itemCards:@"game"]];

    [stack addArrangedSubview:[self sectionHeader:@"Темы" withButton:@"Открыть весь список"]];
    [stack addArrangedSubview:[self itemCards:@"theme"]];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [stack.topAnchor constraintEqualToAnchor:scroll.topAnchor constant:16],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.leadingAnchor constant:16],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.trailingAnchor constant:-16],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.bottomAnchor constant:-16]
    ]];
}

- (UIView *)sectionHeader:(NSString *)title {
    return [self sectionHeader:title withButton:nil];
}

- (UIView *)sectionHeader:(NSString *)title withButton:(NSString *)btnTitle {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *l = [[UILabel alloc] init];
    l.text = title;
    l.font = [[RSTheme shared] titleFont];
    l.textColor = [[RSTheme shared] textColor];
    l.translatesAutoresizingMaskIntoConstraints = NO;
    [row addSubview:l];

    if (btnTitle) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTitle:btnTitle forState:UIControlStateNormal];
        b.titleLabel.font = [[RSTheme shared] captionFont];
        [b setTitleColor:[[RSTheme shared] accentColor] forState:UIControlStateNormal];
        b.translatesAutoresizingMaskIntoConstraints = NO;
        [row addSubview:b];
        [NSLayoutConstraint activateConstraints:[
            [b.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
            [b.centerYAnchor constraintEqualToAnchor:l.centerYAnchor]
        ]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [l.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [l.topAnchor constraintEqualToAnchor:row.topAnchor],
        [l.bottomAnchor constraintEqualToAnchor:row.bottomAnchor],
        [row.heightAnchor constraintGreaterThanOrEqualToConstant:30]
    ]];
    return row;
}

- (UIView *)repoCards {
    UIStackView *s = [[UIStackView alloc] init];
    s.axis = UILayoutConstraintAxisHorizontal;
    s.spacing = 12;
    s.distribution = UIStackViewDistributionFillEqually;
    s.translatesAutoresizingMaskIntoConstraints = NO;

    // Mock repos
    for (NSInteger i = 0; i < 4; i++) {
        RSGlassView *card = [[RSGlassView alloc] init];
        card.translatesAutoresizingMaskIntoConstraints = NO;
        card.cornerRadius = 16;

        UILabel *title = [[UILabel alloc] init];
        title.text = @[@"BigBoss", @"ModMyi", @"Chariz", @"Elucubratus"][i];
        title.font = [[RSTheme shared] buttonFont];
        title.textColor = [[RSTheme shared] textColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.translatesAutoresizingMaskIntoConstraints = NO;
        [card addSubview:title];

        [NSLayoutConstraint activateConstraints:@[
            [card.heightAnchor constraintEqualToConstant:100],
            [title.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
            [title.centerYAnchor constraintEqualToAnchor:card.centerYAnchor]
        ]];
        [s addArrangedSubview:card];
    }
    return s;
}

- (UIView *)itemCards:(NSString *)type {
    UIStackView *s = [[UIStackView alloc] init];
    s.axis = UILayoutConstraintAxisVertical;
    s.spacing = 12;
    s.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *names = @[@"SBSettings", @"Zeppelin", @"WinterBoard", @"Activator"];
    if ([type isEqualToString:@"app"]) names = @[@"Filza", @"NewTerm", @"iFile", @"Terminal"];
    if ([type isEqualToString:@"game"]) names = @[@"Flappy Bird", @"Pokemon GO", @"Crossy Road", @"Candy Crush"];
    if ([type isEqualToString:@"theme"]) names = @[@"SnowBoard", @"Anemone", @"Whiteshift", @"Cyberduck"];

    for (NSInteger i = 0; i < 3; i++) {
        RSGlassView *card = [[RSGlassView alloc] init];
        card.translatesAutoresizingMaskIntoConstraints = NO;
        card.cornerRadius = 12;

        UILabel *title = [[UILabel alloc] init];
        title.text = names[i];
        title.font = [[RSTheme shared] bodyFont];
        title.textColor = [[RSTheme shared] textColor];
        title.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *desc = [[UILabel alloc] init];
        desc.text = @"Описание пакета...";
        desc.font = [[RSTheme shared] captionFont];
        desc.textColor = [[RSTheme shared] secondaryTextColor];
        desc.translatesAutoresizingMaskIntoConstraints = NO;

        [card addSubview:title];
        [card addSubview:desc];

        [NSLayoutConstraint activateConstraints:@[
            [card.heightAnchor constraintEqualToConstant:72],
            [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:12],
            [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:12],
            [desc.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4],
            [desc.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:12]
        ]];
        [s addArrangedSubview:card];
    }
    return s;
}

@end