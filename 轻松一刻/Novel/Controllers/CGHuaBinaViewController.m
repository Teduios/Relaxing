//
//  CGHuaBinaViewController.m
//  轻松一刻
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGHuaBinaViewController.h"
#import <WebKit/WebKit.h>

@interface CGHuaBinaViewController ()
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation CGHuaBinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
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
