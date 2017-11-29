//
//  YKPlayScrollView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayScrollView.h"
#import "YKPlayView.h"
#import "YKLRCDisplayView.h"
#import "YKLRCParser.h"
#import "YKLRCModel.h"
#import "YKMusicPlayeMananger.h"

@interface YKPlayScrollView()

@property (nonatomic, copy) NSArray *LRCList;

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) YKPlayView *playView;

@property (nonatomic, strong) YKLRCDisplayView *LRCView;

@property (nonatomic, strong) CADisplayLink *dispalyLink;

@end

@implementation YKPlayScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dispalyLink = [CADisplayLink displayLinkWithTarget:self  selector:@selector(refreshUI)];
        self.dispalyLink.paused = YES;
        [self.dispalyLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        [self layoutUI];
    }
    return self;
}

- (void)dealloc{
    [self.dispalyLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.dispalyLink = nil;
}

- (void)layoutUI{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    YKPlayView *playView = [[YKPlayView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:playView];
    self.playView = playView;
    
    YKLRCDisplayView *LRCView = [[YKLRCDisplayView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [self addSubview:LRCView];
    self.LRCView = LRCView;
    
    self.contentSize = CGSizeMake(2*width, 0);
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

#pragma mark
#pragma mark refresh
- (void)reloadUIWithMusic:(YKMusicModel*)music{
    self.music = music;
    
    //LRC paser
    YKLRCParser *lrcPaser = [[YKLRCParser alloc] init];
    self.LRCList = [lrcPaser paserLRCForFilePath:self.music.LRCFilePath];
    
    //刷新
    [self.playView reloadUIWithIconImage:[UIImage imageNamed:self.music.iconName] singer:self.music.singerName];
    [self.LRCView reloadUIWithMusicLRCList:self.LRCList];
}

- (void)refreshUI{
    
    NSTimeInterval time = [YKMusicPlayeMananger manager].currentPlayTime;
    NSInteger index = [self lineIndexForTime:time];
    
    
    if (index < 0 || index >= self.LRCList.count) {
        return;
    }
    
    YKLRCModel *model = self.LRCList[index];
    CGFloat progress = (time - model.beginTime)/model.duration;
    
    [self.playView showLRCText:model.text progress:progress];
    [self.LRCView seekToLineIndex:index progress:progress];
}

#pragma mark
#pragma mark private method
- (NSInteger)lineIndexForTime:(NSTimeInterval)time{
    __block NSUInteger currentIndex = -1;
    [_LRCList enumerateObjectsUsingBlock:^(YKLRCModel  *model, NSUInteger index, BOOL * _Nonnull stop) {
        
        if (time >= model.beginTime && time - model.beginTime < model.duration) {
            currentIndex = index;
            *stop = YES;
        }
    }];
    
    return currentIndex;
}

#pragma mark
#pragma mark getter or setter
- (void)setPlaying:(BOOL)playing{
    
    self.playView.playing = playing;
    
    if (playing) {
        
        self.dispalyLink.paused = NO;
    }else{
        
        self.dispalyLink.paused = YES;
    }
}

@end
