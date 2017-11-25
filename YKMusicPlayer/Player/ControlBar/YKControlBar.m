//
//  YKControlBar.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKControlBar.h"
#import "YKProgressView.h"
#import "YKMusicModel.h"

@interface YKControlBar ()

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) YKProgressView *progressView;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation YKControlBar

- (instancetype)initWithFrame:(CGRect)frame music:(YKMusicModel*)music
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        _music = music;
        [self layoutUI];
        
        [self.progressView setDuration:_music.totalDuration progress:0];
    }
    return self;
}

- (void)layoutUI{
    
    YKProgressView *progressView = [[YKProgressView alloc] initWithFrame:CGRectMake(0, 0, self.yk_width, 40)];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_green"] forState:UIControlStateNormal];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_gray"] forState:UIControlStateDisabled];
    previewBtn.center = CGPointMake(50, 65);
    [self addSubview:previewBtn];
    self.previewBtn = previewBtn;
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"play_green"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"play_gray"] forState:UIControlStateDisabled];
    nextBtn.center = CGPointMake(self.yk_width/2, 65);
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playNext_green"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playNext_gray"] forState:UIControlStateDisabled];
    playBtn.center = CGPointMake(self.yk_width - 74, 65);
    [self addSubview:playBtn];
    self.playBtn = playBtn;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentPlayTime"]) {
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    }
}

@end
