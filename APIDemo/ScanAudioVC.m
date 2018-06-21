//
//  ScanAudioVC.m
//  APIDemo
//
//  Created by Macx on 2018/6/21.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScanAudioVC.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanAudioVC () <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    AVAudioPlayer *_player;
    
}

@end

@implementation ScanAudioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style:0];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    NSArray *audios = [[NSFileManager defaultManager] subpathsAtPath:[docPath() stringByAppendingString:@"/audios"]];
    _dataArray = [NSMutableArray arrayWithArray:audios];
}

// MARK: - UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_player stop];
 NSString *audioPath = [[ docPath() stringByAppendingString:@"/audios"] stringByAppendingString:[NSString stringWithFormat:@"/%@",_dataArray[indexPath.row]]];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:nil];
    _player.numberOfLoops = 0;
    [_player prepareToPlay];
    [_player play];
    
}

@end
