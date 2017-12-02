//
//  YKMusicModel.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/23.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicModel.h"
#import <AVFoundation/AVFoundation.h>

@interface YKMusicModel ()

@property (nonatomic,  copy) NSString *title;

@property (nonatomic,  copy) NSString *filePath;

@property (nonatomic,  copy) NSString *LRCFilePath;

@property (nonatomic,  copy) NSString *singerName;

@property (nonatomic,  copy) NSString *iconName;

@property (nonatomic,  copy) NSString *bigIconName;

@property (nonatomic, assign) NSTimeInterval totalDuration;

@end

@implementation YKMusicModel

+ (instancetype)musicModelWithInfo:(NSDictionary *)info{
    
    YKMusicModel *model = [YKMusicModel new];
    
    model.title = info[@"name"];
    model.filePath = [[NSBundle mainBundle] pathForResource:info[@"filename"] ofType:nil];
    model.LRCFilePath = [[NSBundle mainBundle] pathForResource:info[@"lrcname"] ofType:nil];
    model.singerName = info[@"singer"];
    model.iconName = info[@"singerIcon"];
    model.bigIconName = info[@"icon"];
    
    //duration
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:model.filePath] options:nil];
    CGFloat duratuin = CMTimeGetSeconds(asset.duration);
    model.totalDuration = duratuin;
    
    return model;
}

@end
