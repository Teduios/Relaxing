//
//  CGNetWorkingTool.m
//  轻松一刻
//
//  Created by Tarena on 16/6/2.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGNetWorkingTool.h"
#import "CGJokeOfText.h"
#import "CGJokeOfImage.h"
#import "CGHuoBian.h"

typedef void(^BLOCK) (NSArray *jokeOfDataArray);
@interface CGNetWorkingTool()<NSURLSessionDownloadDelegate>
@property (nonatomic,copy) BLOCK dataBlock;
@end
@implementation CGNetWorkingTool
static  NSMutableArray *dataArray = nil;
#pragma mark -- 网络请求参数的存取
static NSInteger _page = 0;
+ (void)setJokePage:(NSInteger)page{
    _page = page;
}
+ (NSInteger)getJokePage{
    return _page;
}
static NSString *_type = nil;
+ (void)setJokeType:(NSString *)type{
    _type = type;
}
+ (NSString *)getJokeType{
    return _type;
}
static  NSInteger _num = 10;
+ (void)setHuaBianNum:(NSInteger)num {
    _num = num;
}
+ (NSInteger)getHuaBianNum {
    return _num;
}

#pragma mark -- 网络相关的方法
+ (void)getAllJokeData:(JOKE_BlOCK)block {
    [[self shareNetWorkingTool] newLoadData];
    [self shareNetWorkingTool].dataBlock = block;
}
+ (void)getAllHuaBianData:(JOKE_BlOCK)block {
    [[self shareNetWorkingTool] newLoadData];
    [self shareNetWorkingTool].dataBlock = block;
}
- (void)newLoadData {
    NSURLRequest *request = [self getRequest];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
}
- (NSURLRequest *)getRequest {
    NSURL *url = [self getURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"8f21a99d73b8e408fca2184ed02d7401" forHTTPHeaderField: @"apikey"];
    return request;
}
#pragma mark  url的拼接
- (NSURL*)getURL {
    if ([CGNetWorkingTool shareNetWorkingTool].joke) {
        NSString *httpUrl = [NSString stringWithFormat:@"http://apis.baidu.com/showapi_open_bus/showapi_joke/joke_%@",_type];
        NSString *httpArg = [NSString stringWithFormat:@"page=%ld",_page];
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl,httpArg];
        return [NSURL URLWithString: urlStr];
    } else {
        NSString *httpUrl = @"http://apis.baidu.com/txapi/huabian/newtop";
        NSString *httpArg = [NSString stringWithFormat:@"num=%ld&page=%ld",_num,_page];
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl,httpArg];
        return [NSURL URLWithString: urlStr];
    }
}
#pragma mark -- NSURLSessionDownloadDelegate 方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        if ([CGNetWorkingTool shareNetWorkingTool].joke) {
            NSArray *array = dic[@"showapi_res_body"][@"contentlist"];
            self.dataBlock([self parseJokeOfTextData:array]);
        } else {
            NSArray *array = dic[@"newslist"];
            self.dataBlock([self parseHuaBianData:array]);
        }

    } else {
        NSArray *array = @[@"请求失败"];
        self.dataBlock([self parseJokeOfTextData:array]);
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

#pragma mark -- 数据解析方法
/** 数组套字典的模型 */
- (NSArray *)parseJokeOfTextData:(NSArray *)textArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *textDic in textArray) {
        if ([_type isEqualToString:@"text"]) {
            CGJokeOfText *jokeText = [[CGJokeOfText alloc]init];
            [jokeText setValuesForKeysWithDictionary:textDic];
            [array addObject:jokeText];
        } else {
            CGJokeOfImage *jokeImage = [[CGJokeOfImage alloc]init];
            [jokeImage setValuesForKeysWithDictionary:textDic];
            [array addObject:jokeImage];
        }
        
    }
    return array;
}
/** 字典套字典的模型 */
- (NSArray *)parseHuaBianData:(NSArray*)dic {
   NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *contentDic in dic) {
        CGHuoBian *content = [[CGHuoBian alloc]init];
        [content setValuesForKeysWithDictionary:contentDic];
        [array addObject:content];
    }
    return array;
}
#pragma mark -- 单例方法
+ (CGNetWorkingTool *)shareNetWorkingTool {
    static CGNetWorkingTool *netWorkingTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkingTool = [[CGNetWorkingTool alloc] init];
    });
    return netWorkingTool;
}


@end
