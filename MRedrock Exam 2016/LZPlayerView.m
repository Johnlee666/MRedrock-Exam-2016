//
//  ViewController1.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "LZPlayerView.h"
#import "LZRecordView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayTool.h"
@interface LZPlayerView ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *last;
@property (weak, nonatomic) IBOutlet UIButton *button;

//@property AVAudioPlayer *voicePlayer;
@property (strong, nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;

@property NSArray *array;
@property NSMutableDictionary *list;
@property NSInteger index;
@end

@implementation LZPlayerView
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [session setActive:YES error:nil];
    [self.button addTarget:self action:@selector(loop) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(play:)name: @"播放"object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(addsong)name: @"下载完成"object: nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(way:) name:@"删除列表" object:nil];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/3;
//    self.view.backgroundColor = [UIColor colorWithRed:38/255.0 green:185/255.0 blue:96/255.0 alpha:1];
    self.index = 0;
    self.progressview.progress = 0;
//    playerTool.player.numberOfLoops = 0;
//    playerTool.player.volume =0.5;
    AudioPlayTool *playTool = [AudioPlayTool sharedAudioPlayTool];
    playTool.player.delegate = self;
//    [playerTool.player prepareToPlay];
    [self method];
   
    // Do any additional setup after loading the view.
}


-(void)addsong{
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    self.list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    self.array = [self.list allKeys];
}

-(void)loop{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];
    if(playerTool.player.numberOfLoops==-1){
        playerTool.player.numberOfLoops = 0;
    }
    if (playerTool.player.numberOfLoops ==0) {
        playerTool.player.numberOfLoops = 1;
    }
    if (playerTool.player.numberOfLoops==1) {
        playerTool.player.numberOfLoops =-1;
    }
}


-(void)way:(NSNotification *)notification{
    NSString *name = [notification.object valueForKey:@"row"];
    NSInteger i = [name integerValue];
    if (self.index >=i && self.index != 0) {
        self.index--;
    }
    [self addsong];
}

- (void)play:(NSNotification *)notifaction {
    NSString *name = [notifaction.object valueForKey:@"row"];
    NSInteger i = [name integerValue];
    self.index = i;
    [self method];
}

-(void)method{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];

    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    self.list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    self.array = [self.list allKeys];
//    NSLog(@"%@",plistPath);
    if(self.array.count==0){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [fileManager changeCurrentDirectoryPath:[plistPath stringByExpandingTildeInPath]];
        NSData *nullData = [[NSData alloc]init];
        [fileManager createFileAtPath:plistPath contents:nullData attributes:nil];
        NSDictionary *dict = [[NSDictionary alloc]init];
        [dict writeToFile:plistPath atomically:YES];
        }
        return;
    }
    self.songName.text = self.array[self.index];
    NSData *musicData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.mp3",docDirPath,self.array[self.index]]];
    NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",docDirPath,self.array[self.index]]];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    playerTool.player = [[AVAudioPlayer alloc]initWithData:musicData error:nil];
    self.play.selected = YES;
    [playerTool.player prepareToPlay];
    [playerTool.player play];
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updatePlayprogress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(IBAction)playButtonAction:(UIButton *)sender{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];
    if (!sender.selected) {
        [playerTool.player play];
        self.timer.fireDate = [NSDate distantPast];
    }
    else{
        [playerTool.player pause];
        self.timer.fireDate = [NSDate distantFuture];
    }
    sender.selected =!sender.selected;
}


-(IBAction)ButtonAction:(UIButton *)sender{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];
    [playerTool.player stop];
    if (sender.tag) {
        if (self.index != self.array.count-1)
        self.index++;
        else
        self.index = 0;
    }
    else{
        if (self.index == 0)
            self.index = self.array.count-1;
        else
        self.index --;
    }
    [self method];
    self.play.selected = YES;
//    [playerTool.player play];
}


-(IBAction)sounds:(UIButton *)sender{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];
    if (sender.tag) {
        if (playerTool.player.volume<1.0)
            playerTool.player.volume += 0.1;
    }
    else{
        if (playerTool.player.volume>0.0)
            playerTool.player.volume -= 0.1;
    }
}


-(void)updatePlayprogress{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];

    float progress = playerTool.player.currentTime/playerTool.player.duration;
    [self.progressview setProgress:progress animated:true];
}


-(IBAction)tapProgressBg:(UITapGestureRecognizer *)sender{
    AudioPlayTool *playerTool = [AudioPlayTool sharedAudioPlayTool];

    CGPoint point = [sender locationInView:sender.view];
    playerTool.player.currentTime = (point.x/sender.view.frame.size.width)*playerTool.player.duration;
    [self updatePlayprogress];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //    self.index++;
    if (self.index != self.array.count-1)
        self.index++;
    else
        self.index = 0;
    [self method];
    //    if (_index != self.array.count-1)
    //        _index++;
    //    else
    //        _index = 0;
    //    [self method];
    //    self.play.selected = YES;
    //    [playerTool.player play];
    //    NSLog(@"音乐播放完成...");
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];
//}
//-(void) viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//    [self resignFirstResponder];
//}
//-(BOOL)canBecomeFirstResponder{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
