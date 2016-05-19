//
//  ViewController.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HotSongCell.h"
#define  url @"http://route.showapi.com/213-4?showapi_sign=a3b9cb3921c74e0ba31d2d7b2fbbed77&showapi_appid=6091&topid=5"

@interface ViewController ()<AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) AVAudioPlayer *voicePlayer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic)NSTimer *timer;

@property NSMutableArray *array;
@property NSMutableDictionary *contents;
@property NSMutableDictionary *dict;

@end

@implementation ViewController
static int flag=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 375, 500) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100.0f;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}
;
-(void) getData{
    if (self.array==nil) {
        dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSURL *URL = [NSURL URLWithString:url];
        dispatch_async(q1, ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    self.array = [[[self.dict objectForKey: @"showapi_res_body"] objectForKey:@"pagebean"]objectForKey:@"songlist"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
            [task resume];
        });

    }
}


-(void)downloadmusic{
    if (flag) {
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
        NSMutableDictionary *list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        
        if (![list objectForKey:[self.contents objectForKey:@"songname"]]) {
            flag=0;
            NSURL *URL = [NSURL URLWithString:[self.contents objectForKey:@"downUrl"]];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:100];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
            [task resume];
        }

    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    flag = 1;
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@.mp3",docDirPath,[self.contents objectForKey:@"songname"]];
      NSString *imagePath = [NSString stringWithFormat:@"%@/%@.jpg",docDirPath,[self.contents objectForKey:@"songname"]];
    
    NSData *musicData = [NSData dataWithContentsOfURL:location];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.contents objectForKey:@"albumpic_big"]]];
    [musicData writeToFile:musicPath atomically:YES];
    [imageData writeToFile:imagePath atomically:YES];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    [list setObject:@"1" forKey:[self.contents objectForKey:@"songname"]];
    [list writeToFile:plistPath atomically:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"下载完成" object:self];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [self.progressView setProgress:totalBytesWritten/(double)totalBytesExpectedToWrite];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSongCell *cell = (HotSongCell *)[[[NSBundle mainBundle]loadNibNamed:@"HotSongCell" owner:self options:nil]lastObject];
    self.contents = self.array[indexPath.row];
    cell.songName.text = [self.contents objectForKey:@"songname"];
    cell.singerName.text = [self.contents objectForKey:@"singername"];
    
    NSString *string = [self.contents objectForKey:@"albumpic_small"];
    NSURL *URL = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    cell.imageView.image = [UIImage imageWithData:data];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.contents = self.array[indexPath.row];
    [self downloadmusic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
