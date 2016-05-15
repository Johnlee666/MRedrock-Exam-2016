////
////  TableViewController.m
////  MRedrock Exam 2016
////
////  Created by 李展 on 16/5/14.
////  Copyright © 2016年 李展. All rights reserved.
////
//
//#import "ViewController.h"
//#import "playerUI.h"
//#import "TableViewController.h"
//#import "HotSongCell.h"
//#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
//#define  url @"http://route.showapi.com/213-4?showapi_sign=a3b9cb3921c74e0ba31d2d7b2fbbed77&showapi_appid=6091&topid=5"
//@interface TableViewController ()
//@property NSMutableDictionary *contents;
//@property NSMutableDictionary *dict;
//@property NSMutableArray *array;
//@property (strong, nonatomic) AVAudioPlayer *voicePlayer;
//@end
//
//@implementation TableViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self getData];
//    self.tableView.rowHeight = 100.f;
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//-(void) getData{
//    dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    NSURL *URL = [NSURL URLWithString:url];
//    dispatch_async(q1, ^{
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error == nil) {
//                self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                self.array = [[[self.dict objectForKey: @"showapi_res_body"] objectForKey:@"pagebean"]objectForKey:@"songlist"];
////                NSLog(@"%@",self.array);
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }];
//        [task resume];
//    });
//}
//-(void)downloadmusic{
//    NSURL *URL = [NSURL URLWithString:[self.contents objectForKey:@"downUrl"]];
//    NSLog(@"%@",URL);
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:100];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
//    [task resume];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.array.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    HotSongCell *cell = (HotSongCell *)[[[NSBundle mainBundle]loadNibNamed:@"HotSongCell" owner:self options:nil]lastObject];
//    cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
//    self.contents = self.array[indexPath.row];
//    cell.songName.text = [self.contents objectForKey:@"songname"];
//    cell.singerName.text = [self.contents objectForKey:@"singername"];
//    NSString *string = [self.contents objectForKey:@"albumpic_small"];
//    NSURL *URL = [NSURL URLWithString:string];
//    NSData *data = [NSData dataWithContentsOfURL:URL];
//    cell.imageView.image = [UIImage imageWithData:data];
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    playerUI *vc =[[playerUI alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [self downloadmusic];
//}
//
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
