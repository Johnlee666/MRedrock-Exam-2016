//
//  ViewController3.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/15.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "ViewController3.h"
#include "PlaylistCell.h"
@interface ViewController3 ()
@property NSMutableDictionary *list;
@property NSArray *array;
//@property NSMutableDictionary *contents;
@property UITableView *tableView;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 375, 500) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70.0f;
    [self.view addSubview:self.tableView];
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *plistPath = [docDirPath stringByAppendingString:@"/music.plist"];
    self.list = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    self.array = [self.list allKeys];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCell *cell = (PlaylistCell *)[[[NSBundle mainBundle]loadNibNamed:@"PlaylistCell" owner:self options:nil]lastObject];
    cell.songname.text = self.array[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:indexPath forKey:@"1"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"播放" object:nil userInfo:dict];
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
