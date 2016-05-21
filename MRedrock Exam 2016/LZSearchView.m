//
//  ViewController2.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/15.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "LZSearchView.h"
#import "LZHotsongCell.h"
@interface LZSearchView ()<UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *bt;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property UITableViewCell *cell;

@property NSMutableDictionary *contents;
@property NSMutableArray *array;

@end
@implementation LZSearchView

static int flag=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0;
    [self.bt addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
    self.textfield.delegate = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 375, 500) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100.0f;
    [self.view addSubview:self.tableView];
}


-(void) getData{
        dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q1, ^{
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://route.showapi.com/213-1?showapi_sign=a3b9cb3921c74e0ba31d2d7b2fbbed77&showapi_appid=6091&keyword=%@",self.textfield.text]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
                    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    self.array = [[[dict objectForKey: @"showapi_res_body"] objectForKey:@"pagebean"]objectForKey:@"contentlist"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
            [task resume];
        });
}


-(void)downloadmusic{
    [self.textfield resignFirstResponder];
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


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [self.progressView setProgress:totalBytesWritten/(double)totalBytesExpectedToWrite];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@.mp3",docDirPath,[self.contents objectForKey:@"songname"]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.jpg",docDirPath,[self.contents objectForKey:@"songname"]];
    NSData *musicData = [NSData dataWithContentsOfURL:location];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.contents objectForKey:@"albumpic_big"]]];
    [musicData writeToFile:musicPath atomically:YES];
    [imageData writeToFile:imagePath atomically:YES];
    NSMutableDictionary *list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if ([self.contents objectForKey:@"songname"]==nil) {
        [list setObject:@"1" forKey:@"(null)"];
    }
    else{
    [list setObject:@"1" forKey:[self.contents objectForKey:@"songname"]];
    }
    [list writeToFile:plistPath atomically:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"下载完成" object:nil];
    self.progressView.progress = 0;
    flag = 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZHotsongCell *cell = (LZHotsongCell *)[[[NSBundle mainBundle]loadNibNamed:@"LZHotsongCell" owner:self options:nil]lastObject];
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
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.contents = self.array[indexPath.row];
    [self downloadmusic];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getData];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
