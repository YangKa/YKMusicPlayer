//
//  YKControlBar.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKControlBar.h"
#import "YKMusicModel.h"

@interface YKControlBar ()

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation YKControlBar

- (instancetype)initWithFrame:(CGRect)frame music:(YKMusicModel*)music
{
    self = [super initWithFrame:frame];
    if (self) {

        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 20, self.yk_width - 60, 4)];
    slider.tintColor = RGB_COLOR(45, 185, 105);
    [slider setThumbImage:[UIImage imageNamed:@"color_green"] forState:UIControlStateNormal];
    [self addSubview:slider];
    self.slider = slider;
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_green"] forState:UIControlStateNormal];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_gray"] forState:UIControlStateDisabled];
    previewBtn.center = CGPointMake(40, 65);
    [self addSubview:previewBtn];
    self.previewBtn = previewBtn;
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"play_green"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"play_gray"] forState:UIControlStateDisabled];
    nextBtn.center = CGPointMake(self.yk_width/2, 65);
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playNext_green"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playNext_gray"] forState:UIControlStateDisabled];
    playBtn.center = CGPointMake(self.yk_width - 64, 65);
    [self addSubview:playBtn];
    self.playBtn = playBtn;
}

@end
