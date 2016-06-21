//
//  CGJokeTableViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/2.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGJokeTableViewController.h"
#import "CGNetWorkingTool.h"
#import "CGJokeOfText.h"
#import "MJRefresh.h"
#import "CGCategoryView.h"
#import "UIView+Extension.h"
#import "MBProgressHUD.h"
#import "CGBaseNavController.h"
#import "CGJokeContentViewController.h"

@interface CGJokeTableViewController ()
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *JokeOfTextArray;
@property (nonatomic,strong) CGCategoryView *categoryView;
//@property (nonatomic,strong) CGImageTableViewController *imageTableViewController;
@end

@implementation CGJokeTableViewController

- (NSMutableArray *)JokeOfTextArray {
    if (!_JokeOfTextArray) {
        _JokeOfTextArray = [NSMutableArray array];
    }
    return _JokeOfTextArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CGNetWorkingTool setJokeType:@"text"];
    [self addRefreshControl];
    self.navigationItem.title = @"开心每一刻";
//    [self addHeaderView];
//    [self addChildController];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [self setBackGroundImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma mark -- 和子视图控制器相关的方法
//- (void)addChildController {
//    self.imageTableViewController = [[CGImageTableViewController alloc]init];
//    [self addChildViewController:self.imageTableViewController];
//}

#pragma mark -- 和界面相关的方法
- (void)setBackGroundImage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
}
//#pragma mark -- 头部视图相关的方法
//- (void)addHeaderView {
//    self.categoryView  = [[[NSBundle mainBundle] loadNibNamed:@"CGCategoryView" owner:self options:nil]firstObject];
//    self.categoryView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 50);
//    [self.view addSubview:self.categoryView];
//    self.tableView.y = 114;
//    [self addButtonChick];
//}

//- (void)addButtonChick {
//    [self.categoryView.textButton addTarget:self action:@selector(chickTextButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.categoryView.imageViewButton addTarget:self action:@selector(chickImageViewButton) forControlEvents:UIControlEventTouchUpInside];
//}

//- (void)chickTextButton {
//    [self.imageTableViewController.tableView removeFromSuperview];
//    self.type = @"text";
//    [CGNetWorkingTool setJokeType:self.type];
//    [self loadNewData];
//}

//- (void)chickImageViewButton {
//    self.type = @"pic";
//    [CGNetWorkingTool setJokeType:self.type];
//    [self loadNewData];
//    self.imageTableViewController.tableView.y = 64;
//    [self.view addSubview:self.imageTableViewController.tableView];
//}
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
                [self.JokeOfTextArray removeAllObjects];
            }
            [self.JokeOfTextArray addObjectsFromArray:jokeOfDataArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
//            if ([jokeOfDataArray[0] isEqualToString:@"请求失败"]) {
//                [self creatProgressHUD:@"网络繁忙，请稍后再试"];
//            }
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.JokeOfTextArray.count) {
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.JokeOfTextArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CGJokeOfText *jokeOfText = self.JokeOfTextArray[indexPath.row];
    cell.textLabel.text = jokeOfText.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGJokeContentViewController *jokeContentViewController = [[CGJokeContentViewController alloc]init];
    CGJokeOfText *jokeOfText = self.JokeOfTextArray[indexPath.row];
    jokeContentViewController.detailContent = jokeOfText.text;
    CGBaseNavController *navi = [[CGBaseNavController alloc]initWithRootViewController:jokeContentViewController];
    [self presentViewController:navi animated:YES completion:nil];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    CGBaseNavController *navi = segue.destinationViewController;
//    CGJokeDetailViewController *detailViewController = navi.viewControllers[0];
////    CGJokeDetailViewController *detailViewController = segue.destinationViewController;
//    NSIndexPath *indexPath = sender;
//    CGJokeOfText *jokeOfText = self.JokeOfTextArray[indexPath.row];
//    detailViewController.detailContent = jokeOfText.text;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

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
