//
//  YKMusicPlayeMananger.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicPlayeMananger.h"
#import <AVFoundation/AVFoundation.h>

@interface YKMusicPlayeMananger ()

@property (nonatomic,  strong) YKMusicModel *music;

@property (nonatomic,  assign) float currentPlayTime;

@property (nonatomic,  assign) BOOL playing;

@property (nonatomic,  assign) BOOL pause;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) id timeObserver;

@end

@implementation YKMusicPlayeMananger

+ (instancetype)manager{
    static id instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[YKMusicPlayeMananger alloc] init];
    });
    return instace;
}

- (void)startPlayWithMusic:(YKMusicModel*)music{
    
    self.music = music;
    
    //初始化
    NSURL *url = [NSURL fileURLWithPath:self.music.filePath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.volume = 1.0;
    
    //KVO
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //progress monitor
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
            //当前播放的时间
            float current = CMTimeGetSeconds(time);
        	weakSelf.currentPlayTime = current;
    }];
    
    
    [self.player play];
}

- (void)pausePlay{
    self.playing = NO;
    self.pause = YES;
    [self.player pause];
}

- (void)resumePlay{
    self.playing = YES;
    self.pause = NO;
    [self.player play];
}

- (void)cancelPlay{
    self.playing = NO;
    self.pause = NO;
    [self.player pause];
    
    //remove KVO
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    
    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.player = nil;
    self.currentPlayTime = 0;
    
}

#pragma mark
#pragma mark AVAudioPlayerDelegate
- (void)playFinished:(NSNotification*)notification{
    
}

#pragma mark
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = (AVPlayerStatus)change[NSKeyValueChangeNewKey];
        switch (status) {
            case AVPlayerStatusFailed:
                
                break;
            case AVPlayerStatusReadyToPlay:
                
                break;
            case AVPlayerStatusUnknown:
                
                break;
        }
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * ranges = change[NSKeyValueChangeNewKey];
        NSLog(@"ranges=%@", ranges);
    }
 
}



@end
