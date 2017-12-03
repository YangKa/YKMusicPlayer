//
//  YKMusicPlayeMananger.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicPlayeMananger.h"
#import "YKMusicParser.h"

@interface YKMusicPlayeMananger (){
    id _timeObserver;
    AVPlayer *_player;
}

@property (nonatomic,  strong) YKMusicModel *music;

@property (nonatomic, strong) NSArray *musicList;

@property (nonatomic,  assign) float currentPlayTime;

@property (nonatomic,  assign) float currentCacheTime;

@property (nonatomic,  assign) BOOL playing;

@property (nonatomic,  assign) BOOL pause;

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

#pragma mark
#pragma mark public method
- (NSArray*)currentMusicList{
    return [self.musicList copy];
}

#pragma mark
#pragma mark privat method
- (void)resetPlayManager{
    
    self.playing = NO;
    self.pause = NO;
    
    if (_player) {
        [_player pause];
        
        [self removeObserver];
        
        _player = nil;
    }
    
    self.currentPlayTime = 0;
    self.currentCacheTime = 0.0;
}

- (void)addObserver{
    //KVO
    //加载文件
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //缓存状态
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("com.serial.timeObserver", DISPATCH_QUEUE_SERIAL);
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(200, 1000) queue:queue usingBlock:^(CMTime time) {
        
        if (weakSelf.pause){
            return;
        }
        
        //播放状态
        weakSelf.playing = YES;
        
        //当前播放的时间r
        weakSelf.currentPlayTime = CMTimeGetSeconds(time);
    }];
}

- (void)removeObserver{
    //remove KVO
    [_player removeTimeObserver:_timeObserver];
    _timeObserver = nil;
    
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
#pragma mark play status control
- (void)startPlayWithMusic:(YKMusicModel*)music{
    
    //初始化重置
    [self resetPlayManager];
    
    //初始化
    self.music = music;
    NSURL *url = [NSURL fileURLWithPath:self.music.filePath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    if (_player) {
        [_player replaceCurrentItemWithPlayerItem:item];
    }else{
        _player = [AVPlayer playerWithPlayerItem:item];
        _player.volume = 1.0;
    }
    
    //add KVO and Notification
    [self addObserver];

    //progress monitor
    self.currentPlayTime = 0;
    self.currentCacheTime = 0.0;
    
    [_player play];
}

- (void)pausePlay{
    self.playing = NO;
    self.pause = YES;
    [_player pause];
}

- (void)resumePlay{
    self.playing = YES;
    self.pause = NO;
    [_player play];
}

- (void)cancelPlay{
    self.playing = NO;
    self.pause = NO;
    [_player pause];
    
    [self resetPlayManager];
}

- (void)playFinished{
    NSUInteger index = [self.musicList indexOfObject:self.music];
    if (self.playing && index < self.musicList.count - 1) {
        [self playNextMusic];
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayNextMusicNotificationKey object:nil];
    }else{
        self.playing = NO;
        self.pause = NO;
        [self resetPlayManager];
    }
}

- (void)seekToTime:(CMTime)time{
    if (self.playing) {
        self.pause = YES;
        [_player pause];
    }
    
    [_player seekToTime:time];
    
    //进度修改
    CGFloat second = CMTimeGetSeconds(time);
    self.currentPlayTime = second;
    
    if (self.playing) {
         self.pause = NO;
        [_player play];
    }
}

#pragma mark
#pragma mark play  control
- (void)playNextMusic{
    
    [self pausePlay];
    
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
    
    [self pausePlay];
    
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
                NSLog(@"文件初始化失败");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"文件初始化完成，准备播放");
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态，不能播放");
                break;
        }
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        AVPlayerItem *item = (AVPlayerItem*)object;
        NSValue *value = [item.loadedTimeRanges firstObject];
        CMTimeRange timeRange = [value CMTimeRangeValue];
        self.currentCacheTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
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

- (float)playProgress{
    return self.currentPlayTime / self.music.totalDuration;
}

- (float)cacheProgress{
    return self.currentCacheTime / self.music.totalDuration;
}

@end
