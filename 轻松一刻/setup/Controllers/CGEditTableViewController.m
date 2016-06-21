//
//  CGEditTableViewController.m
//  轻松一刻
//
//  Created by happy on 16/6/3.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGEditTableViewController.h"

@interface CGEditTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CGEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- 修改签名
- (IBAction)personTextFied:(id)sender {
    [self.textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:self.textField.text forKey:@"座右铭"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)buttonChick:(id)sender {
    [self.textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:self.textField.text forKey:@"座右铭"];
}
#pragma mark -- 设置背景的图像视图的相关方法
- (void)setAllImageView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
    self.headerImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"]];
    if (!self.headerImageView.image) {
        self.headerImageView.image = [UIImage imageNamed:@"head"];
    }
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self changeHeaderImage];
        
    }
}

-(void)changeHeaderImage {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"本地图库" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self choosePhotoImage];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseCameraImage];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)choosePhotoImage{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)chooseCameraImage {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headerImageView.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"headerImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}










@end
