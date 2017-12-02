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

@property (nonatomic, strong) YKPlayView *playView;

@property (nonatomic, strong) YKLRCDisplayView *LRCView;

@end

@implementation YKPlayScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
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
    
    //LRC paser
    YKLRCParser *lrcPaser = [[YKLRCParser alloc] init];
    self.LRCList = [lrcPaser paserLRCForFilePath:music.LRCFilePath];
    
    //刷新
    [self.playView reloadUIWithIconImage:[UIImage imageNamed:music.iconName] singer:music.singerName];
    [self.LRCView reloadUIWithMusicLRCList:self.LRCList];
    
    //刷新界面进度
    [self refreshUI];
}

- (void)refreshUI{
    
    CGFloat time = [YKMusicPlayeMananger manager].currentPlayTime;
    NSInteger index = [self lineIndexForTime:time];
    
    if (index < 0 || index >= self.LRCList.count) {
        NSLog(@"行数越界");
        return;
    }
    
    YKLRCModel *model = self.LRCList[index];
    CGFloat progress = (time - model.beginTime)/model.duration;
    
    [self.playView showLRCText:model.text progress:progress];
    [self.LRCView seekToLineIndex:index progress:progress];
}

#pragma mark
#pragma mark private method
- (NSInteger)lineIndexForTime:(CGFloat)time{
    __block NSUInteger currentIndex = -1;
    NSUInteger count = _LRCList.count;
    [_LRCList enumerateObjectsUsingBlock:^(YKLRCModel  *model, NSUInteger index, BOOL * _Nonnull stop) {
        
        if ( index == count - 1) {
            if (time >= model.beginTime) {
                currentIndex = index;
            }
        }else{
            CGFloat beginTime = model.beginTime;
            YKLRCModel  *nextModel = _LRCList[index + 1];
            CGFloat nextBeginTime = nextModel.beginTime;
            
            if (time >= beginTime && time  < nextBeginTime) {
                currentIndex = index;
            }
        }
        
        if (currentIndex != -1) *stop = YES;
        
    }];
    return currentIndex;
}

#pragma mark
#pragma mark getter or setter
- (void)setPlaying:(BOOL)playing{
    _playing = playing;
    self.playView.playing = playing;
}

@end
