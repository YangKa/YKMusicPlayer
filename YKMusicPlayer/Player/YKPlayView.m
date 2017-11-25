//
//  YKPlayView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayView.h"
#import "YKMusicModel.h"

@interface YKPlayView ()

@property (nonatomic, strong) UIImageView *roundPanel;

@property (nonatomic, strong) YKMusicModel *music;

@end

static CGFloat RadiusRatio = 0.618;
static NSString *RotationAnimationKey = @"rotation";
@implementation YKPlayView

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
    
    UIImage *image = [UIImage imageNamed:self.music.iconName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat radius = self.yk_width * RadiusRatio;
    imageView.bounds = CGRectMake(0, 0, radius, radius);
    imageView.center = CGPointMake(self.yk_width/2, self.yk_height/2);
    imageView.layer.cornerRadius = radius/2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 3;
    [self addSubview:imageView];
    self.roundPanel = imageView;
    
    [self startRotationAnimation];
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
    animation.duration = 3.6*1.5;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

@end
