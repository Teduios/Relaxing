//
//  CGSetUpTableViewController.m
//  轻松一刻
//
//  Created by happy on 16/6/2.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGSetUpTableViewController.h"
#import "CGCollectionViewController.h"
#import "CGBaseNavController.h"

@interface CGSetUpTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *trashLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation CGSetUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.separatorColor = [UIColor blueColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self setImageView];
    [self showTrashText];
    [self showTextLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -- 与界面相关的设置
- (void)setImageView {
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"]];
    if (!self.headImageView.image) {
        self.headImageView.image = [UIImage imageNamed:@"scroll0"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
}
- (void)showTextLabel {
    self.textLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"座右铭"];
    if (!self.textLabel.text) {
        self.textLabel.text = @"您还没有设置自己的签名";
    }
}

#pragma mark -- 与清理缓存相关的方法
- (IBAction)clearTrash:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清空缓存" message:@"是否清理?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearCaches];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearCaches{
    NSString *cachesFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    [[NSFileManager defaultManager] removeItemAtPath:cachesFilePath error:nil];
    [self showTrashText];
}

-(void)showTrashText{
    NSString *cachesFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:cachesFilePath error:nil];
    float fileSize = [dic[@"NSFileSize"] floatValue];
    self.trashLabel.text = [NSString stringWithFormat:@"%.02fMB",fileSize/1024.0];
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        //跳转到设置背景界面上
        CGCollectionViewController *collectionViewController = [[CGCollectionViewController alloc] initWithNibName:@"CGCollectionViewController" bundle:nil];
        CGBaseNavController *navController = [[CGBaseNavController alloc]initWithRootViewController:collectionViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    if (indexPath.section == 1 && indexPath.row ==1) {
        [self clearTrash:nil];
    }
}


@end
