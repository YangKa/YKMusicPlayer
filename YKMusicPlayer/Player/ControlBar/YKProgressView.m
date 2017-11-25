//
//  YKProgressView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/25.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKProgressView.h"

@interface YKProgressView ()

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UILabel *progressTimeLabel;

@property (nonatomic, strong) UILabel *totalTimeLabel;

@end

@implementation YKProgressView
@synthesize progress = _progress;

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        _duration = 0;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:9];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"00:00";
    [self addSubview:leftLabel];
    self.progressTimeLabel = leftLabel;
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.yk_width - 50, 10, 40, 20)];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:9];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"00:00";
    [self addSubview:rightLabel];
    self.totalTimeLabel = rightLabel;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(leftLabel.yk_maxX + 5, 18, self.yk_width - 2*(leftLabel.yk_maxX + 5), 4)];
    slider.tintColor = RGB_COLOR(58, 193, 126);
    [slider setThumbImage:[UIImage imageNamed:@"color_clear"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"color_green"] forState:UIControlStateHighlighted];
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    self.slider = slider;
}

- (void)setDuration:(CGFloat)duration progress:(CGFloat)progress{
    
    self.duration = duration;
    self.slider.maximumValue = _duration;
    self.totalTimeLabel.text = [self timeFormatWithIntervalTime:(NSTimeInterval)duration];
    
    self.slider.value = progress;
}

- (void)sliderValueChange:(UISlider*)slider{
    
    _progress = slider.value;
    
    NSTimeInterval time = (NSTimeInterval)slider.value;
    self.progressTimeLabel.text = [self timeFormatWithIntervalTime:time];
}

//progress
- (void)setProgress:(CGFloat)progress{
    if (progress > self.duration) {
        self.progress = self.duration;
        return;
    }
    if (progress < 0) {
        self.progress = 0;
        return;
    }
    
    //更新进度条
    [self.slider setValue:progress animated:NO];
    self.progressTimeLabel.text = [self timeFormatWithIntervalTime:(NSTimeInterval)progress];
}

- (CGFloat)progress{
    return self.slider.value;
}

- (NSString*)timeFormatWithIntervalTime:(NSTimeInterval)time{
    
    int hour = time / 3600;
    time -= 3600*hour;
    
    int mintue = time / 60;
    int second = time - 60*mintue;
    
    NSString *timeStr;
    if (hour > 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, mintue, second];
    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d", mintue, second];
    }
    return timeStr;
}

@end
