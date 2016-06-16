//
//  ViewController.m
//  ZLWeiboPersonalPage
//
//  Created by angelen on 16/6/16.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ViewController.h"
#import "BaseTableViewController.h"
#import "LeftTableViewController.h"
#import "MiddleTableViewController.h"
#import "RightTableViewController.h"
#import "ZLTopView.h"
#import "ZLTitleLabel.h"
#import "Masonry.h"

static CGFloat const kTitleScrollViewHeight = 40;
static CGFloat const kIndicatorViewHeight = 3;

@interface ViewController ()<TableViewScrollingProtocol, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL stausBarColorIsBlack;

@property (nonatomic, weak) UIView *navView;

/**
 *  标题列表
 */
@property (nonatomic, strong) NSArray  *titleList;

/**
 *  小标题
 */
@property (nonatomic, strong) UIView *titleView;

/**
 *  指示器
 */
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIButton *segCtrl; // 待删除

// 头像 view + 小标题 + 指示器 的父 view
@property (nonatomic, strong) ZLTopView *headerView;

// 内容 Scroll view
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@property (nonatomic, strong) UITableViewController *contentTVC;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleList = @[@"主页", @"微博", @"相册"];
    
    [self configNav];
    [self addHeaderView];
    [self addController];
    [self addTitles];
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = 0;
    [self didTapButton:btn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return _stausBarColorIsBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

#pragma mark - Private
- (void)configNav {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
    titleLabel.text = @"小良GG";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view addSubview:navView];
    
    _navView = navView;
}

- (void)addController {
    LeftTableViewController *vc1 = [[LeftTableViewController alloc] init];
    vc1.delegate = self;
    MiddleTableViewController *vc2 = [[MiddleTableViewController alloc] init];
    vc2.delegate = self;
    RightTableViewController *vc3 = [[RightTableViewController alloc] init];
    vc3.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    
//    vc1.tableView.frame = CGRectMake(0, 0, self.contentScrollView.frame.size.width, 300);
//    vc2.tableView.frame = CGRectMake(kScreenWidth, 0, self.contentScrollView.frame.size.width, 300);
//    vc3.tableView.frame = CGRectMake(kScreenWidth * 2, 0, self.contentScrollView.frame.size.width, 300);

//    CGRect rect1 = vc1.tableView.frame;
//    rect1.origin.x = 0;
//    vc1.tableView.frame = rect1;
//    
//    CGRect rect2 = vc2.tableView.frame;
//    rect2.origin.x = kScreenWidth;
//    vc2.tableView.frame = rect2;
//    
//    CGRect rect3 = vc3.tableView.frame;
//    rect3.origin.x = kScreenWidth * 2;
//    vc3.tableView.frame = rect3;
    
//    [self.contentScrollView addSubview:vc1.tableView];
//    [self.contentScrollView addSubview:vc2.tableView];
//    [self.contentScrollView addSubview:vc3.tableView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"sdjfks:%f", scrollView.contentOffset.x);
}

/**
 *  添加顶部标题s
 */
- (void)addTitles {
    for (int index = 0; index < self.titleList.count; index++) {
        CGFloat titleWidth = kScreenWidth / self.titleList.count;
        CGFloat titleHeight = kTitleScrollViewHeight;
        CGFloat titleX = index * titleWidth;
        CGFloat titleY = 0;
        
        ZLTitleLabel *titleLabel = [[ZLTitleLabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
        [titleLabel setTitle:self.titleList[index] forState:UIControlStateNormal];
        titleLabel.tag = index;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 目测用 UIButton 也是可以的，也比较方便，所以我就去改咯🌚
        [titleLabel addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:titleLabel];
    }
}

- (void)didTapButton:(UIButton *)sender {
    NSLog(@"点击了：%ld", (long)sender.tag);
    [_showingVC.view removeFromSuperview];
    
    BaseTableViewController *newVC = self.childViewControllers[sender.tag];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = self.view.bounds;
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    if (offsetY <= headerImgHeight - topBarHeight) {
        [newVC.view addSubview:_headerView];
        for (UIView *view in newVC.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [newVC.view insertSubview:_headerView belowSubview:view];
                break;
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }  else {
        [self.view insertSubview:_headerView belowSubview:_navView];
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    }
    _showingVC = newVC;
}

- (void)addHeaderView {
    
    
    CGSize scrollSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64 - 40)];
    self.contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.titleList.count * kScreenWidth, scrollSize.height - 64 - 40);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:self.contentScrollView];
    
    self.contentScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2];
    
    ZLTopView *topView = [[ZLTopView alloc] init];
    topView.frame = CGRectMake(0, 0, kScreenWidth, headerImgHeight + switchBarHeight);
    topView.backgroundColor = [UIColor orangeColor];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView = topView;
    
    // 不需要初始化了
    topView.label.text = @"头像，昵称";
    topView.label.textColor = [UIColor blueColor];
    
    self.titleView = topView.titleView;
    
    // 测试按钮，不用管
//    UIButton *button0 = [[UIButton alloc] init];
//    button0.tag = 0;
//    [button0 setTitle:@"主页" forState:UIControlStateNormal];
//    [button0 setBackgroundColor:[UIColor greenColor]];
//    [button0 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button0 addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button0];
//    
//    UIButton *button1 = [[UIButton alloc] init];
//    button1.tag = 1;
//    [button1 setTitle:@"微博" forState:UIControlStateNormal];
//    [button1 setBackgroundColor:[UIColor greenColor]];
//    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//    
//    UIButton *button2 = [[UIButton alloc] init];
//    button2.tag = 2;
//    [button2 setTitle:@"相册" forState:UIControlStateNormal];
//    [button2 setBackgroundColor:[UIColor greenColor]];
//    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button2 addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button2];
//    
//    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(button1);
//        make.width.mas_equalTo(button2);
//        make.top.mas_equalTo(self.view.mas_bottom).offset(-100);
//        make.top.mas_equalTo(button1);
//        make.top.mas_equalTo(button2);
//        make.height.mas_equalTo(100);
//        make.height.mas_equalTo(button1);
//        make.height.mas_equalTo(button2);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(button1.mas_left);
//    }];
//    
//    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(button2.mas_left);
//    }];
//    
//    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view);
//    }];
    
    
    
    
//    CommualHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommualHeaderView" owner:nil options:nil] lastObject];
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, headerImgHeight+switchBarHeight);
//    headerView.label.text = @"我帮你打水";
//    self.headerView = headerView;
//    self.segCtrl = headerView.segCtrl;
//    
//    _segCtrl.sectionTitles = _titleList;
//    _segCtrl.backgroundColor = [ColorUtility colorWithHexString:@"e9e9e9"];
//    _segCtrl.selectionIndicatorHeight = 2.0f;
//    _segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    _segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    _segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
//    _segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtility colorWithHexString:@"fea41a"]};
//    _segCtrl.selectionIndicatorColor = [ColorUtility colorWithHexString:@"fea41a"];
//    _segCtrl.selectedSegmentIndex = 0;
//    _segCtrl.borderType = HMSegmentedControlBorderTypeBottom;
//    _segCtrl.borderColor = [UIColor lightGrayColor];
//    
//    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

//- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
//    [_showingVC.view removeFromSuperview];
//    
//    BaseTableViewController *newVC = self.childViewControllers[sender.selectedSegmentIndex];
//    if (!newVC.view.superview) {
//        [self.view addSubview:newVC.view];
//        newVC.view.frame = self.view.bounds;
//    }
//    
//    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
//    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
//    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
//    
//    [self.view insertSubview:newVC.view belowSubview:self.navView];
//    if (offsetY <= headerImgHeight - topBarHeight) {
//        [newVC.view addSubview:_headerView];
//        for (UIView *view in newVC.view.subviews) {
//            if ([view isKindOfClass:[UIImageView class]]) {
//                [newVC.view insertSubview:_headerView belowSubview:view];
//                break;
//            }
//        }
//        CGRect rect = self.headerView.frame;
//        rect.origin.y = 0;
//        self.headerView.frame = rect;
//    }  else {
//        [self.view insertSubview:_headerView belowSubview:_navView];
//        CGRect rect = self.headerView.frame;
//        rect.origin.y = topBarHeight - headerImgHeight;
//        self.headerView.frame = rect;
//    }
//    _showingVC = newVC;
//}

- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > headerImgHeight - topBarHeight) {
        if (![_headerView.superview isEqual:self.view]) {
            [self.view insertSubview:_headerView belowSubview:_navView];
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    } else {
        if (![_headerView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headerView belowSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }
    
    
    if (offsetY>0) {
        CGFloat alpha = offsetY/136;
        self.navView.alpha = alpha;
        
        if (alpha > 0.6 && !_stausBarColorIsBlack) {
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            _stausBarColorIsBlack = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else if (alpha <= 0.6 && _stausBarColorIsBlack) {
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            _stausBarColorIsBlack = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } else {
        self.navView.alpha = 0;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _stausBarColorIsBlack = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = NO;
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = NO;
}



#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}


@end
