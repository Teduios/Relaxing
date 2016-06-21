//
//  CGHuoBian.h
//  轻松一刻
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGHuoBian : NSObject
/** 日期 */
@property (nonatomic,copy) NSString *time;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 描述 */
@property (nonatomic,copy) NSString *dic;
/** 图片url */
@property (nonatomic,copy) NSString *picUrl;
/** 网址 */
@property (nonatomic,copy) NSString *url;
@end
