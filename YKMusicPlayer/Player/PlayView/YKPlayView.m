//
//  YKPlayView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayView.h"
#import "YKLRCLabel.h"

@interface YKPlayView (){
    NSString *_LRCText;
}

@property (nonatomic, strong) UIImageView *roundPanel;

@property (nonatomic, strong) YKLRCLabel *LRCLabel;

@property (nonatomic, strong) UILabel *singerLabel;


@end

static CGFloat RadiusRatio = 0.618;
static NSString *RotationAnimationKey = @"rotation";
@implementation YKPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    UILabel *singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.yk_width, 30)];
    singerLabel.textColor = [UIColor whiteColor];
    singerLabel.textAlignment = NSTextAlignmentCenter;
    singerLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:singerLabel];
    self.singerLabel = singerLabel;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat radius = self.yk_width * RadiusRatio;
    imageView.bounds = CGRectMake(0, 0, radius, radius);
    imageView.center = CGPointMake(self.yk_width/2, self.yk_height/2);
    imageView.layer.cornerRadius = radius/2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 5;
    [self addSubview:imageView];
    self.roundPanel = imageView;
    
    YKLRCLabel *label = [[YKLRCLabel alloc] initWithFrame:CGRectMake(0, self.yk_height - 60, self.yk_width, 30)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:label];
    self.LRCLabel = label;
}

- (void)startRotationAnimation{
    if ([self.roundPanel.layer.animationKeys containsObject:RotationAnimationKey]) {
        return;
    }
    
    CABasicAnimation *aniamtion = [self rotateAniamtion];
    [self.roundPanel.layer addAnimation:aniamtion forKey:RotationAnimationKey];
}

- (void)stopRotationAnimation{
    if ([self.roundPanel.layer.animationKeys containsObject:RotationAnimationKey]) {
        [self.roundPanel.layer removeAnimationForKey:RotationAnimationKey];
    }
}

- (CABasicAnimation*)rotateAniamtion{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 10;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

#pragma mark
#pragma mark refresh UI and show LRC progress
- (void)reloadUIWithIconImage:(UIImage*)image singer:(NSString*)singer{
    self.roundPanel.image = image;
    self.singerLabel.text = [NSString stringWithFormat:@"- %@ -", singer];
}

- (void)showLRCText:(NSString*)LRCText progress:(CGFloat)progres{
    _LRCText = LRCText;
    
    self.LRCLabel.text = LRCText;
    self.LRCLabel.progress = progres;
}

#pragma mark
#pragma mark getter or setter
- (void)setPlaying:(BOOL)playing{
    if (playing) {
        [self startRotationAnimation];
    }else{
        [self stopRotationAnimation];
    }
}

@end
