//
//  YKMusicPlayeMananger.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicPlayeMananger.h"
#import "YKMusicParser.h"

@interface YKMusicPlayeMananger ()

@property (nonatomic,  strong) YKMusicModel *music;

@property (nonatomic,  assign) float currentPlayTime;

@property (nonatomic,  assign) float playProgress;

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

//初始化重置
- (void)resetPlayManager{
    
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    self.playing = NO;
    self.pause = NO;
    
    //remove KVO
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    self.currentPlayTime = 0;
    self.playProgress = 0.0;
    
    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
#pragma mark play single music
- (void)startPlayWithMusic:(YKMusicModel*)music{
    
    //初始化重置
    [self resetPlayManager];
    
    //初始化
    self.music = music;
    NSURL *url = [NSURL fileURLWithPath:self.music.filePath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.volume = 1.0;
    
    //KVO
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //progress monitor
    self.currentPlayTime = 0;
    self.playProgress = 0.0;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_queue_create("com.serial.timeObserver", DISPATCH_QUEUE_SERIAL);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(30, 1000) queue:queue usingBlock:^(CMTime time) {
        
        if (weakSelf.pause){
            return;
        }
        
        weakSelf.playing = YES;
        
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
         //NSLog(@"当前播放的时间 %f", current);
        if (current >= weakSelf.currentPlayTime) {
            weakSelf.currentPlayTime = current;
            weakSelf.playProgress = current / weakSelf.music.totalDuration;
        }
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
    
    [self resetPlayManager];
}

- (void)playFinished{
    self.playing = NO;
    self.pause = NO;
    [self resetPlayManager];
}

- (void)seekToTime:(CMTime)time{
    [self.player seekToTime:time];
}

#pragma mark
#pragma mark control
- (void)playNextMusic{
    NSUInteger index = 0;
    if ([self.musicList containsObject:self.music]) {
        index = [self.musicList indexOfObject:self.music];
        index = (index < self.musicList.count - 1) ? (index + 1) : (self.musicList.count - 1) ;
    }
    
    if (index < self.musicList.count) {
        [self startPlayWithMusic:self.musicList[index]];
    }
}

- (void)playPreviewMusic{
    NSUInteger index = 0;
    if ([self.musicList containsObject:self.music]) {
        index = [self.musicList indexOfObject:self.music];
        index = (index > 0) ? index - 1:0;
    }
    
    if (index < self.musicList.count) {
        [self startPlayWithMusic:self.musicList[index]];
    }
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

#pragma mark
#pragma mark getter
- (NSArray *)musicList{
    if (!_musicList){
        _musicList = [YKMusicParser musicListWithFileName:@"Musics.plist"];
    }
    return _musicList;
}


@end
