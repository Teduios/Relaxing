//
//  CGJokeOfImage.h
//  轻松一刻
//
//  Created by happy on 16/6/2.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGJokeOfImage : NSObject
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 日期 */
@property (nonatomic,copy) NSString *ct;
/** 内容 */
@property (nonatomic,copy) NSString *img;
/** 类型 */
@property (nonatomic,strong) NSNumber *type;
@end
