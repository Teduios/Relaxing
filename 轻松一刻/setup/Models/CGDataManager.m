//
//  CGDataManager.m
//  轻松一刻
//
//  Created by happy on 16/6/5.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "CGDataManager.h"

@implementation CGDataManager
static NSArray *_imageArray = nil;
+ (NSArray *)getAllBackgrounpImage {
    if (!_imageArray) {
        _imageArray = @[@"background0",@"background1",@"background2",@"background3",@"background4",@"background5",@"background6",@"background7",@"background8"];
    }
    return _imageArray;
}
@end
