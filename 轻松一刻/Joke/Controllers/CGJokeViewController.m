//
//  CGJokeViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGJokeViewController.h"
#import "CGImageTableViewController.h"
#import "CGJokeTableViewController.h"
#import "CGCategoryView.h"
#import "UIView+Extension.h"
#import "CGNetWorkingTool.h"
#import "CGImageViewController.h"

@interface CGJokeViewController ()
@property (nonatomic,strong)CGImageViewController *imageViewController;
@property (nonatomic,strong)CGJokeTableViewController *jokeTableViewController;
@property (nonatomic,strong) CGCategoryView *categoryView;
@property (nonatomic,strong) UIView *currentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation CGJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildController];
    [self addHeaderView];
    [self chickTextButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [CGNetWorkingTool shareNetWorkingTool].joke = YES;
    [self setBackGroundImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 和界面相关的方法
- (void)setBackGroundImage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        self.backgroundImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"background0"];
    }
}
#pragma mark -- 和子视图控制器相关的方法
- (void)addChildController {
    self.imageViewController = [[CGImageViewController alloc]init];
    self.jokeTableViewController = [[CGJokeTableViewController alloc]init];
    [self addChildViewController:self.imageViewController];
    [self addChildViewController:self.jokeTableViewController];
}

#pragma mark -- 头部视图相关的方法
- (void)addHeaderView {
    self.categoryView  = [[[NSBundle mainBundle] loadNibNamed:@"CGCategoryView" owner:self options:nil]firstObject];
    self.categoryView.frame = CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:self.categoryView];
    [self addButtonChick];
}

- (void)addButtonChick {
    [self.categoryView.textButton addTarget:self action:@selector(chickTextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryView.imageViewButton addTarget:self action:@selector(chickImageViewButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chickTextButton {
    [self.currentView removeFromSuperview];
    self.currentView = self.jokeTableViewController.tableView;
    self.currentView.y = 114;
    [self.view addSubview:self.currentView];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)chickImageViewButton {
    [self.currentView removeFromSuperview];
    self.currentView = self.imageViewController.view;
    self.currentView.frame = CGRectMake(0, 114, self.view.bounds.size.width, self.view.bounds.size.height - 114);
//    self.currentView.y = 114;
    [self.view addSubview:self.currentView];
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
}



@end
