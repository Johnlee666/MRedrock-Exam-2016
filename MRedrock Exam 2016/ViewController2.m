//
//  ViewController2.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/15.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "ViewController2.h"
#import "HotSongCell.h"
@interface ViewController2 ()<UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *bt;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property UITableView *tableview;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property NSMutableDictionary *contents;
@property NSMutableDictionary *dict;
@property NSMutableArray *array;
@property NSMutableArray *list;
@property NSString *url;
@property UITableViewCell *cell;
@end
@implementation ViewController2
static int flag=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bt addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 375, 500) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100.0f;
    [self.view addSubview:self.tableView];
}

-(void) getData{
    self.url = [NSString stringWithFormat:@"http://route.showapi.com/213-1?showapi_sign=a3b9cb3921c74e0ba31d2d7b2fbbed77&showapi_appid=6091&keyword=%@",self.textfield.text];
        dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSURL *URL = [NSURL URLWithString:self.url];
        dispatch_async(q1, ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    self.array = [[[self.dict objectForKey: @"showapi_res_body"] objectForKey:@"pagebean"]objectForKey:@"contentlist"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
            [task resume];
        });
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3",docDirPath,[self.contents objectForKey:@"songname"]];
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@.jpg",docDirPath,[self.contents objectForKey:@"songname"]];
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.contents objectForKey:@"albumpic_big"]]];
    [data writeToFile:filePath atomically:YES];
    [data1 writeToFile:filePath1 atomically:YES];
    NSMutableDictionary *list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if ([self.contents objectForKey:@"songname"]==nil) {
        [list setObject:@"1" forKey:@"(null)"];
    }
    else{
    [list setObject:@"1" forKey:[self.contents objectForKey:@"songname"]];
    }
    [list writeToFile:plistPath atomically:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"下载完成" object:nil];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
//    NSLog(@"%f",totalBytesWritten/(double)totalBytesExpectedToWrite);
    [self.progressView setProgress:totalBytesWritten/(double)totalBytesExpectedToWrite];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSongCell *cell = (HotSongCell *)[[[NSBundle mainBundle]loadNibNamed:@"HotSongCell" owner:self options:nil]lastObject];
    self.contents = self.array[indexPath.row];
    if ([self.contents objectForKey:@"songname"]==nil) {
       cell.songName.text =[NSString stringWithFormat:@"%@",[self.contents objectForKey:@"albumname"]];
    }
    else if ([self.contents objectForKey:@"albumname"]==nil){
        cell.songName.text = [NSString stringWithFormat:@"%@",[self.contents objectForKey:@"songname"]];
    }
    else{
    cell.songName.text =[NSString stringWithFormat:@"%@-%@",[self.contents objectForKey:@"songname"],[self.contents objectForKey:@"albumname"]];
    }
    cell.singerName.text = [self.contents objectForKey:@"singername"];
    NSString *string = [self.contents objectForKey:@"albumpic_small"];
    NSURL *URL = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    cell.imageView.image = [UIImage imageWithData:data];
//    [cell.bt addTarget:self action:@selector(downloadmusic) forControlEvents:UIControlEventTouchUpInside];
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
