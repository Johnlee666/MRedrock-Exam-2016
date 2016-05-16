//
//  ViewController1.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "ViewController1.h"
#import "ViewController3.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController1 ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *last;
@property AVAudioPlayer *voicePlayer;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic)NSTimer *timer;
@property NSMutableDictionary *list;
@property NSArray *array;
@property NSInteger index;
@end

@implementation ViewController1
- (void)viewDidLoad {
    [self.button addTarget:self action:@selector(loop) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor colorWithRed:119/255.0 green:178/255.0 blue:252/255.0 alpha:1];
    [super viewDidLoad];
    self.voicePlayer.numberOfLoops = 0;
    self.voicePlayer.volume =0.5;
    self.voicePlayer.delegate = self;
    [self.voicePlayer prepareToPlay];
    self.index = 0;
    [self method];
    [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(method)name: @"下载完成"object: nil];
    // Do any additional setup after loading the view.
}
-(void)loop{
    if(self.voicePlayer.numberOfLoops==-1){
        self.voicePlayer.numberOfLoops = 0;
    }
    if (self.voicePlayer.numberOfLoops ==0) {
        self.voicePlayer.numberOfLoops = 1;
    }
    if (self.voicePlayer.numberOfLoops==1) {
        self.voicePlayer.numberOfLoops =-1;
    }
}
-(void)method{
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    self.list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    self.array = [self.list allKeys];
    if(self.array.count==0){
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    判断文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {//如果文件不存在则创建
        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath:[plistPath stringByExpandingTildeInPath]];
        NSData *d = [[NSData alloc]init];
        [fileManager createFileAtPath:plistPath contents:d attributes:nil];
        NSDictionary *dict = [[NSDictionary alloc]init];
        [dict writeToFile:plistPath atomically:YES];
        }
        return;
    }

    self.songName.text = self.array[self.index];
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.mp3",docDirPath,self.array[self.index]]];
//    NSLog(@"%@",self.array[self.index]);
    NSData *data1 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",docDirPath,self.array[self.index]]];
    self.imageView.image = [UIImage imageWithData:data1];
    self.voicePlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
//    NSLog(@"%@",plistPath);
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updatePlayprogress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
    
-(IBAction)tapProgressBg:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:sender.view];
    self.voicePlayer.currentTime = (point.x/sender.view.frame.size.width)*self.voicePlayer.duration;
    [self updatePlayprogress];
}


-(IBAction)playButtonAction:(UIButton *)sender{
    if (!sender.selected) {
        [self.voicePlayer play];
        self.timer.fireDate = [NSDate distantPast];
    }
    else{
        [self.voicePlayer pause];
        self.timer.fireDate = [NSDate distantFuture];
    }
    sender.selected =!sender.selected;
}

-(IBAction)ButtonAction:(UIButton *)sender{
    [self.voicePlayer stop];
    if (sender.tag) {
        if (_index != self.array.count-1)
        _index++;
        else
        _index = 0;
    }
    else{
        if (_index == 0)
            _index = self.array.count-1;
        else
        _index --;
    }
    [self method];
    self.play.selected = YES;
    [self.voicePlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    if (_index != self.array.count-1)
//        _index++;
//    else
//        _index = 0;
//    [self method];
//    self.play.selected = YES;
//    [self.voicePlayer play];
//    NSLog(@"音乐播放完成...");
}

-(void)updatePlayprogress{
    float progress = self.voicePlayer.currentTime/self.voicePlayer.duration;
    [self.progressview setProgress:progress animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sounds:(UIButton *)sender{
    if (sender.tag) {
        if (self.voicePlayer.volume<1.0)
        self.voicePlayer.volume += 0.1;
    }
    else{
        if (self.voicePlayer.volume>0.0)
        self.voicePlayer.volume -= 0.1;
    }
}

@end
