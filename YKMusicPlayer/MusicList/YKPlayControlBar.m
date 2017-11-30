//
//  YKPlayControlBar.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/29.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayControlBar.h"
#import "YKMusicModel.h"
#import "YKMusicPlayeMananger.h"

@interface YKPlayControlBar ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) CAShapeLayer *circleProgressLayer;

@property (nonatomic, copy) dispatch_block_t touchBlock;

@end


static CGFloat ControlOregionWidth = 150;
@implementation YKPlayControlBar

- (instancetype)initWithFrame:(CGRect)frame touchIconBlock:(dispatch_block_t)touchBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _touchBlock = [touchBlock copy];
        [self layoutUI];

    }
    return self;
}

- (void)layoutUI{
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.yk_width - 20 - ControlOregionWidth, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.yk_width - 60 - ControlOregionWidth, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *respondButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.yk_width - ControlOregionWidth - 10, self.yk_height)];
    [respondButton addTarget:self action:@selector(touchIconButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:respondButton];
    
    //control button
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(self.yk_width - 150, 0, 150, self.yk_height)];
    [self addSubview:controlView];
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_green"] forState:UIControlStateNormal];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_gray"] forState:UIControlStateDisabled];
    previewBtn.center = CGPointMake(25, controlView.yk_height/2);
    [previewBtn addTarget:self action:@selector(exchangeToPreviewMusic:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:previewBtn];
    self.previewBtn = previewBtn;
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"playNext_green"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"playNext_gray"] forState:UIControlStateDisabled];
    nextBtn.center = CGPointMake(controlView.yk_width - 25, controlView.yk_height/2);
    [nextBtn addTarget:self action:@selector(exchangeToNextMusic:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play_green"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"pause_green"] forState:UIControlStateSelected];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play_gray"] forState:UIControlStateDisabled];
    playBtn.center = CGPointMake(controlView.yk_width/2, controlView.yk_height/2);
    [playBtn addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:playBtn];
    self.playBtn = playBtn;
    
    //progress
    CAShapeLayer *circleProgressLayer = [CAShapeLayer layer];
    circleProgressLayer.frame = CGRectMake(3, 3, self.playBtn.yk_width - 6, self.playBtn.yk_height - 6);
    circleProgressLayer.lineWidth = 3;
    [circleProgressLayer setFillColor:[UIColor clearColor].CGColor];
    [circleProgressLayer setStrokeColor:CustomColor_1.CGColor];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleProgressLayer.bounds];
    path.lineCapStyle = kCGLineCapRound;
    circleProgressLayer.path = path.CGPath;
    
    circleProgressLayer.strokeStart = 0;
    circleProgressLayer.strokeEnd = 0;
    [self.playBtn.layer addSublayer:circleProgressLayer];
    self.circleProgressLayer = circleProgressLayer;
    
    circleProgressLayer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 0, 1);
}

- (void)reloadUI{
    YKMusicModel *music = [YKMusicPlayeMananger manager].music;
    self.iconImageView.image = [UIImage imageNamed:music.iconName];
    self.nameLabel.text = music.singerName;
    self.titleLabel.text = music.title;
    
    self.playBtn.selected = [YKMusicPlayeMananger manager].isPlaying;
}

#pragma mark
#pragma mark event method
- (void)exchangeToNextMusic:(UIButton*)button{
    //next music
    [[YKMusicPlayeMananger manager] playNextMusic];
    [self reloadUI];
}

- (void)exchangeToPreviewMusic:(UIButton*)button{
    //preview music
    [[YKMusicPlayeMananger manager] playPreviewMusic];
    [self reloadUI];
}

- (void)touchPlayButton:(UIButton*)button{
    button.selected  = !button.isSelected;
    if (button.isSelected) {
        //play
        [[YKMusicPlayeMananger manager] resumePlay];
    }else{
        //pause
        [[YKMusicPlayeMananger manager] pausePlay];
    }
}

- (void)touchIconButton:(UIButton*)button{
    if (_touchBlock) {
        _touchBlock();
    }
}

#pragma mark
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"playProgress"]) {
        CGFloat playProgress = [change[NSKeyValueChangeNewKey] floatValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            //show play progress
            self.circleProgressLayer.strokeEnd = playProgress;
        });
    }
}

@end
