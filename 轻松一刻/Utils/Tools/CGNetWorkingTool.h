//
//  CGNetWorkingTool.h
//  轻松一刻
//
//  Created by Tarena on 16/6/2.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^JOKE_BlOCK) (NSArray *jokeOfDataArray);
@interface CGNetWorkingTool : NSObject
@property (nonatomic,assign) BOOL joke;
+ (void)getAllJokeData:(JOKE_BlOCK)block;
+ (void)getAllHuaBianData:(JOKE_BlOCK)block;

+ (void)setJokeType:(NSString *)type;
+ (NSString *)getJokeType;

+ (void)setJokePage:(NSInteger)page;
+ (NSInteger)getJokePage;

+ (void)setHuaBianNum:(NSInteger)num;
+ (NSInteger)getHuaBianNum;

+ (CGNetWorkingTool *)shareNetWorkingTool;
@end
