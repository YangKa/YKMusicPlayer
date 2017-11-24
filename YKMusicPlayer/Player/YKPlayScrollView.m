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
#import "YKMusicModel.h"

@interface YKPlayScrollView()

@property (nonatomic, strong) YKMusicModel *music;

@end

@implementation YKPlayScrollView

- (instancetype)initWithFrame:(CGRect)frame music:(YKMusicModel*)music
{
    self = [super initWithFrame:frame];
    if (self) {
        _music = music;
 
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    YKPlayView *playView = [[YKPlayView alloc] initWithFrame:CGRectMake(0, 0, width, height) music:self.music];
    [self addSubview:playView];
    
    YKLRCDisplayView *LRCView = [[YKLRCDisplayView alloc] initWithFrame:CGRectMake(width, 0, width, height) lrcFilePath:self.music.LRCFilePath];
    [self addSubview:LRCView];
    
    self.contentSize = CGSizeMake(2*width, 0);
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

@end
