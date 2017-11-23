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

@interface YKPlayScrollView(){
    NSString *_lrcFilePath;
}

@end


@implementation YKPlayScrollView

- (instancetype)initWithFrame:(CGRect)frame lrcFilePath:(NSString*)lrcFilePath
{
    self = [super initWithFrame:frame];
    if (self) {
        _lrcFilePath = lrcFilePath;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    YKPlayView *playView = [[YKPlayView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:playView];
    
    YKLRCDisplayView *LRCView = [[YKLRCDisplayView alloc] initWithFrame:CGRectMake(width, 0, width, height) lrcFilePath:_lrcFilePath];
    [self addSubview:LRCView];
    
    self.contentSize = CGSizeMake(2*width, 0);
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

@end
