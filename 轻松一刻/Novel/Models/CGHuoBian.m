//
//  CGHuoBian.m
//  轻松一刻
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGHuoBian.h"

@implementation CGHuoBian
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.dic = value;
    }
}
@end
