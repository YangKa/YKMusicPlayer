//
//  YKMusicPlayeMananger.h
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "YKMusicModel.h"

@interface YKMusicPlayeMananger : NSObject

@property (nonatomic, readonly, strong) YKMusicModel *music;

@property (nonatomic, readonly, assign) float currentPlayTime;

@property (nonatomic, readonly, assign, getter=isPlaying) BOOL playing;

@property (nonatomic, readonly, assign, getter=isPause) BOOL pause;

+ (instancetype)manager;

- (void)startPlayWithMusic:(YKMusicModel*)music;

- (void)pausePlay;

- (void)resumePlay;

- (void)cancelPlay;

- (void)seekToTime:(CMTime)time;

@end
