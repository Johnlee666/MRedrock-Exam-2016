//
//  AudioPlayTool.h
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/6/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayTool : AVAudioPlayer
@property (strong, nonatomic) AVAudioPlayer *player;
+(instancetype) sharedAudioPlayTool;
@end
