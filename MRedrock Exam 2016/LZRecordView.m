//
//  ViewController3.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/15.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "LZRecordView.h"
#include "LZPlaylistCell.h"
@interface LZRecordView ()<UITableViewDataSource,UITableViewDelegate>
@property NSMutableDictionary *list;
@property NSMutableArray *array;
@property UITableView *tableView;
@end

@implementation LZRecordView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 375, 500) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70.0f;
    [self.view addSubview:self.tableView];
    [self showList];
    [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(showList)name: @"下载完成"object: nil];

}
-(void)showList{
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    self.list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    self.array = [NSMutableArray arrayWithArray:[self.list allKeys]];
    [self.tableView reloadData];
    [self.view resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZPlaylistCell *cell = (LZPlaylistCell *)[[[NSBundle mainBundle]loadNibNamed:@"LZPlaylistCell" owner:self options:nil]lastObject];
    cell.songname.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSDictionary *dict =[NSDictionary dictionaryWithObject:string forKey:@"row"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"播放" object:dict];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSDictionary *dict =[NSDictionary dictionaryWithObject:string forKey:@"row"];
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@.mp3",docDirPath,self.array[indexPath.row]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.jpg",docDirPath,self.array[indexPath.row]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:musicPath error:nil];
    [fileManager removeItemAtPath:imagePath error:nil];
    [self.list removeObjectForKey:self.array[indexPath.row]];
    [self.array removeObjectAtIndex:(NSUInteger)indexPath.row];
    [self.list writeToFile:plistPath atomically:YES];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"删除列表" object:dict];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
