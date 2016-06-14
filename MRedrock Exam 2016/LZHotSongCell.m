//
//  HotSongCell.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "LZHotsongCell.h"

@implementation LZHotsongCell

- (void)awakeFromNib {
    // Initialization code
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 45.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
