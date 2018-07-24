//
//  ScanAudioVC.m
//  APIDemo
//
//  Created by Chan on 2018/6/21.
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

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //开扬声器
    UInt32 audioRouteOverride = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
#pragma clang diagnostic pop
    
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
    //每次点击播放的时候 先停止
    [_player stop];
    
    //音频路径
    NSString *audioPath = [kAudiosFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",_dataArray[indexPath.row]]];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:nil];
    _player.numberOfLoops = 0;
    _player.volume = 1.0;
    [_player prepareToPlay];
    [_player play];
}

// MARK: - memory management
-(void)dealloc {
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableView = nil;
    }
    if (_dataArray) {
        _dataArray = nil;
    }
    if (_player) {
        _player = nil;
    }
}
@end
