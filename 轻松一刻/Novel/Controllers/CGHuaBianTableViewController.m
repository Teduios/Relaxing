//
//  CGHuaBianTableViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGHuaBianTableViewController.h"
#import "CGNetWorkingTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CGHuoBian.h"
#import "CGMyCell.h"
#import "UIImageView+WebCache.h"
#import "CGHuaBinaViewController.h"
#import "CGBaseNavController.h"

@interface CGHuaBianTableViewController ()
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation CGHuaBianTableViewController
- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControl];
    [self.tableView registerNib:[UINib nibWithNibName:@"CGMyCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}
- (void)viewWillAppear:(BOOL)animated{
    [self setBackGroundImage];
    [CGNetWorkingTool shareNetWorkingTool].joke = NO;
    
}
- (void)setBackGroundImage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 刷新控件相关的方法
- (void)addRefreshControl {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData {
    self.page = 1;
    [CGNetWorkingTool setJokePage:self.page];
    [self sendRequestToServer];
}

- (void)loadMoreData {
    self.page ++;
    [CGNetWorkingTool setJokePage:self.page];
    [self sendRequestToServer];
}
#pragma mark -- 跟数据源相关的方法
- (void)sendRequestToServer{
    //由子线程执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [CGNetWorkingTool getAllHuaBianData:^(NSArray *jokeOfDataArray) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:jokeOfDataArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataArray.count == 0) {
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CGHuoBian *content = self.dataArray[indexPath.row];
    cell.titleLabel.text = content.title;
    
    cell.timeLable.text = content.time;
    NSURL *url = [NSURL URLWithString:content.picUrl];
    NSString *imageStr = [NSString stringWithFormat:@"placeholder%d",arc4random()%11];
    [cell.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageStr]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGHuaBinaViewController *viewController = [[CGHuaBinaViewController alloc]init];
    CGHuoBian *content = self.dataArray[indexPath.row];
    viewController.urlStr = content.url;
//    CGBaseNavController *nav = [[CGBaseNavController alloc]initWithRootViewController:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}



@end
