//
//  AudioPlayTool.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/6/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "AudioPlayTool.h"
#import <AVFoundation/AVFoundation.h>
static AudioPlayTool *instance = nil;
@implementation AudioPlayTool
+ (instancetype)sharedAudioPlayTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
