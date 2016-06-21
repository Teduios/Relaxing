//
//  WelcomeViewController.m
//  轻松一刻
//
//  Created by happy on 16/5/31.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pc;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollViewAttibute];
    [self creatPageControl];
}
#pragma mark -- 和界面相关的方法
- (void)setScrollViewAttibute{
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(screenWidth*3, screenHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    //3.添加UIImageView+UIButton
    [self addImageViews:screenWidth withHeight:screenHeight];
}

- (void)creatPageControl {
    self.pc = [[UIPageControl alloc]init];
    self.pc.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 40);
    //有几个点
    self.pc.numberOfPages = 3;
    //当前 选中的时第几个点  默认不设置是0
    self.pc.currentPage = 0;
    //每个点的颜色是什么
    self.pc.pageIndicatorTintColor = [UIColor redColor];
    //当前 选中的 点 颜色是什么
    self.pc.currentPageIndicatorTintColor = [UIColor greenColor];
    //关闭用户交互
    self.pc.userInteractionEnabled = YES;
    
    [self.view addSubview:self.pc];
}

- (void)addImageViews:(CGFloat)screenWidth withHeight:(CGFloat)screenHeight {
    for (int i = 0; i < 3; i++) {
        //创建UIImageView，添加到scrollView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth*i, 0, screenWidth, screenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome-%d",i]];
        [self.scrollView addSubview:imageView];
        //最后一个UIImageView上添加UIButton
        if (i == 2) {
            imageView.userInteractionEnabled = YES;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5-60, self.view.bounds.size.height-100, 120, 40)];
            [button setBackgroundImage:[UIImage imageNamed:@"button5"] forState:UIControlStateNormal];
            [button setTitle:@"welcome" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
}
#pragma mark -- UIScrollViewDelegate method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pc.currentPage = currentPageNum;
}
- (void)clickButton {
    //1.获取viewController对象
    //2.跳转到主控制器对象(设置window的根视图控制器)
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isVisibledKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
