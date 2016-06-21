//
//  CGCollectionViewController.m
//  轻松一刻
//
//  Created by happy on 16/6/5.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGCollectionViewController.h"
#import "CGDataManager.h"

@interface CGCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSArray *imageArray;

@end

@implementation CGCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [CGDataManager getAllBackgrounpImage];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self setAllImageView];
    [self setNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 界面相关的方法
- (void)setAllImageView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]]];
    } else {
        self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background0"]];
    }
}

- (void)setNavBar {
    self.navigationItem.title = @"更换背景";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backSetController)];
}

- (void)backSetController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ;
    NSString *imageStr =self.imageArray[indexPath.row];
    cell.backgroundView = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:imageStr]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setObject:self.imageArray[indexPath.row] forKey:@"背景"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setAllImageView];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    CGFloat width = (self.view.bounds.size.width - 140)/3.0;
    return CGSizeMake(width, width);
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
