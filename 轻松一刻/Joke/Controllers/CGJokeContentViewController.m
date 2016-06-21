//
//  CGJokeContentViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGJokeContentViewController.h"
#import "MBProgressHUD.h"
#import "CGNetWorkingTool.h"
#import "CGJokeOfText.h"

@interface CGJokeContentViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detaliImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSMutableArray *JokeOfImageArray;
@property (nonatomic,assign) NSInteger page;
@end

@implementation CGJokeContentViewController
- (NSMutableArray*)JokeOfImageArray {
    if (!_JokeOfImageArray) {
        _JokeOfImageArray = [NSMutableArray array];
    }
    return _JokeOfImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CGNetWorkingTool setJokeType:@"text"];
    self.detailTextView.text = self.detailContent;
    [self setNavigationItem];
    [self setScrollView];
    [self openTimer];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self setBackgroundImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 与获取数据相关的方法
- (IBAction)previousGroup:(id)sender {
    [self loadPreviousData];
}
- (IBAction)nextGroup:(id)sender {
    [self loadMoreData];
}
- (IBAction)previousPage:(id)sender {
    if (self.JokeOfImageArray.count) {
        if (self.count < 0) {
            [self creatProgressHUD:@"这是第一则，请换组"];
            self.count = 0;
            return;
        }
        CGJokeOfText *jokeOfText = self.JokeOfImageArray[self.count];
        self.count --;
        self.detailTextView.text = jokeOfText.text;
    }
}
- (IBAction)nextPage:(id)sender {
    if (self.JokeOfImageArray.count) {
        if (self.count > 19) {
            [self creatProgressHUD:@"已经是最后一则，请换组"];
            self.count = 19;
            return;
        }
       CGJokeOfText *jokeOfText = self.JokeOfImageArray[self.count];
        self.count ++;
        self.detailTextView.text = jokeOfText.text;
    } else {
       [self creatProgressHUD:@"请按下一组"];
    }
}
- (void)loadNewData {
    self.page = 1;
    [CGNetWorkingTool setJokePage:self.page];
    [self sendRequestToServer];
}

- (void)loadMoreData {
    self.page ++;
    self.count = 0;
    [CGNetWorkingTool setJokePage:self.page];
    [self sendRequestToServer];
}
- (void)loadPreviousData {
    if (self.page > 1) {
        self.page --;
    }
    self.count = 0;
    [CGNetWorkingTool setJokePage:self.page];
    [self sendRequestToServer];
}
#pragma mark -- 与界面相关的方法
- (void)setBackgroundImage{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.detaliImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]];
    } else {
        self.detaliImageView.image = [UIImage imageNamed:@"background0"];
    }
}

- (void)setNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backPrevious)];
}

- (void)backPrevious {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setScrollView {
    self.scrollView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = 200;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, self.scrollView.bounds.size.height);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addImageViews:screenWidth withHeight:screenHeight];
}
- (void)addImageViews:(CGFloat)screenWidth withHeight:(CGFloat)screenHeight {
    for (int i = 0; i < 3; i++) {
        //创建UIImageView，添加到scrollView
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth*i, 0, screenWidth, screenHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"scroll%d",i]]];
        imageView.frame = CGRectMake(screenWidth*i, 0, screenWidth, screenHeight);
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"scroll%d",i]];
        [self.scrollView addSubview:imageView];
    }
}
#pragma mark -- 与定时器相关的方法
- (void)openTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moveScrollView) userInfo:nil repeats:YES];
}

- (void)moveScrollView {
    static CGFloat x = 0;
    x += self.view.bounds.size.width;
    if (x >= 3*self.view.bounds.size.width) {
        x = 0;
    }
    self.scrollView.contentOffset = CGPointMake(x,0);
}
- (void)creatProgressHUD:(NSString*)content{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置提示用户文本+显示时间+边距值
    hud.mode = MBProgressHUDModeText;
    hud.labelText = content;
    hud.margin = 10;
    //隐藏
    [hud hide:YES afterDelay:3];
    [hud removeFromSuperViewOnHide];
}
- (void)sendRequestToServer{
    //由子线程执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [CGNetWorkingTool getAllJokeData:^(NSArray *jokeOfDataArray) {
            //            if (self.page == 1) {
            [self.JokeOfImageArray removeAllObjects];
            //            }
            [self.JokeOfImageArray addObjectsFromArray:jokeOfDataArray];
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.JokeOfImageArray.count == 0) {
            [self creatProgressHUD:@"请检查一下您的手机是否有联网"];
        }
    });
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
