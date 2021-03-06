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

//zero to 1, current play progress
@property (nonatomic, readonly, assign) float playProgress;

//file buffer cache progress (second)
@property (nonatomic, readonly, assign) float cacheProgress;


//current play time (second)
@property (nonatomic, readonly, assign) float currentPlayTime;

//current play time (second)
@property (nonatomic, readonly, assign) float currentCacheTime;

//playing status
@property (nonatomic, readonly, assign, getter=isPlaying) BOOL playing;

//pause status
@property (nonatomic, readonly, assign, getter=isPause) BOOL pause;

+ (instancetype)manager;

//play cotrol
- (void)startPlayWithMusic:(YKMusicModel*)music;

- (void)pausePlay;

- (void)resumePlay;

- (void)cancelPlay;

//control play
- (void)seekToTime:(CMTime)time;

- (void)playNextMusic;

- (void)playPreviewMusic;

//current muisic list
- (NSArray*)currentMusicList;

//refresh LRC text
- (void)setCurrentLRCTIndex:(NSUInteger)index text:(NSString*)text;

@end
