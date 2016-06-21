//
//  CGImageTableViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/5.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGImageTableViewController.h"
#import "CGNetWorkingTool.h"
#import "CGJokeOfImage.h"
#import "MJRefresh.h"
#import "CGImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface CGImageTableViewController ()
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *JokeOfImageArray;
@end

@implementation CGImageTableViewController
- (NSMutableArray*)JokeOfImageArray {
    if (!_JokeOfImageArray) {
        _JokeOfImageArray = [NSMutableArray array];
    }
    return _JokeOfImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CGNetWorkingTool setJokeType:@"pic"];
    [self addRefreshControl];
    [self.tableView registerNib:[UINib nibWithNibName:@"CGImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.pagingEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [self setBackGroundImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackGroundImage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
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
        [CGNetWorkingTool getAllJokeData:^(NSArray *jokeOfDataArray) {
            if (self.page == 1) {
                [self.JokeOfImageArray removeAllObjects];
            }
            [self.JokeOfImageArray addObjectsFromArray:jokeOfDataArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.JokeOfImageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CGJokeOfImage *jokeOfImage = self.JokeOfImageArray[indexPath.row];
    cell.titleLabel.text = jokeOfImage.title;
    NSURL *url = [NSURL URLWithString:jokeOfImage.img];
    [cell.detailImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.bounds.size.height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
