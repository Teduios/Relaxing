//
//  CGImageTableViewCell.h
//  轻松一刻
//
//  Created by Tarena on 16/6/5.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@end
