//
//  CGImageViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGImageViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CGNetWorkingTool.h"
#import "CGJokeOfImage.h"
@interface CGImageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageContent;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImageView;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *JokeOfImageArray;
@property (nonatomic,assign) int count;
@end

@implementation CGImageViewController
- (NSMutableArray*)JokeOfImageArray {
    if (!_JokeOfImageArray) {
        _JokeOfImageArray = [NSMutableArray array];
    }
    return _JokeOfImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CGNetWorkingTool setJokeType:@"pic"];
    [self loadNewData];
    self.count = 0;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self setBackGroundImage];
    
}
#pragma mark -- 与界面相关的方法
- (void)setBackGroundImage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.backgrounpImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]];
    } else {
        self.backgrounpImageView.image = [UIImage imageNamed:@"background0"];
    }
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
            [self creatProgressHUD:@"这是第一张图片，请按下一组"];
            self.count = 0;
            return;
        }
        CGJokeOfImage *jokeOfImage = self.JokeOfImageArray[self.count];
        self.count --;
        self.titleLabel.text = jokeOfImage.title;
        NSURL *url = [NSURL URLWithString:jokeOfImage.img];
        [self.imageContent sd_setImageWithURL:url placeholderImage:nil];
    }
}
- (IBAction)nextPage:(id)sender {
    if (self.JokeOfImageArray.count) {
        if (self.count > 19) {
            [self creatProgressHUD:@"已经是最后一张了，请按下一组"];
            self.count = 19;
            return;
        }
        CGJokeOfImage *jokeOfImage = self.JokeOfImageArray[self.count];
        self.count ++;
        self.titleLabel.text = jokeOfImage.title;
        NSURL *url = [NSURL URLWithString:jokeOfImage.img];
        [self.imageContent sd_setImageWithURL:url placeholderImage:nil];
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
#pragma mark -- 跟数据源相关的方法
- (void)sendRequestToServer{
    //由子线程执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [CGNetWorkingTool getAllJokeData:^(NSArray *jokeOfDataArray) {
//            if (self.page == 1) {
                [self.JokeOfImageArray removeAllObjects];
//            }
            [self.JokeOfImageArray addObjectsFromArray:jokeOfDataArray];
            //            if ([jokeOfDataArray[0] isEqualToString:@"请求失败"]) {
            //                [self creatProgressHUD:@"网络繁忙，请稍后再试"];
            //            }
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.JokeOfImageArray.count == 0) {
            [self creatProgressHUD:@"请检查一下您的手机是否有联网"];
        }
    });
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
