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
#import "YKMusicPlayeMananger.h"

@interface YKControlBar (){
    BOOL _previewDelegate;
    BOOL _nextDelegate;
    BOOL _playDelegate;
    BOOL _pauseDelegate;
}

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) YKProgressView *progressView;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, copy) id<YKControlBarDelegate> delegate;

@end

@implementation YKControlBar

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = target;
        
        //verify delegate
        _previewDelegate = (_delegate && [_delegate respondsToSelector:@selector(didPreviewMusicWithControlBar:)]);
        _nextDelegate = (_delegate && [_delegate respondsToSelector:@selector(didNextMusicWithControlBar:)]);
        _playDelegate = (_delegate && [_delegate respondsToSelector:@selector(didPlayMusicWithControlBar:)]);
        _pauseDelegate = (_delegate && [_delegate respondsToSelector:@selector(didPauseMusicWithControlBar:)]);
        
        //layout UI
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    YKProgressView *progressView = [[YKProgressView alloc] initWithFrame:CGRectMake(0, 0, self.yk_width, 40) textColor:[UIColor whiteColor] fontSize:10];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_green"] forState:UIControlStateNormal];
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"playPreview_gray"] forState:UIControlStateDisabled];
    previewBtn.center = CGPointMake(50, 65);
    [previewBtn addTarget:self action:@selector(exchangeToPreviewMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:previewBtn];
    self.previewBtn = previewBtn;
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"playNext_green"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"playNext_gray"] forState:UIControlStateDisabled];
    nextBtn.center = CGPointMake(self.yk_width - 50, 65);
    [nextBtn addTarget:self action:@selector(exchangeToNextMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play_green"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"pause_green"] forState:UIControlStateSelected];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play_gray"] forState:UIControlStateDisabled];
    playBtn.center = CGPointMake(self.yk_width/2, 65);
    [playBtn addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    self.playBtn = playBtn;
}

#pragma mark
#pragma mark refesh
- (void)refreshUI{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _playBtn.selected = [YKMusicPlayeMananger manager].isPlaying;
        
        //show play progress
        self.progressView.playProgress = [YKMusicPlayeMananger manager].playProgress;
    });
}

#pragma mark
#pragma mark event method
- (void)exchangeToNextMusic:(UIButton*)button{
    if (_nextDelegate) {
        [self.delegate didNextMusicWithControlBar:self];
    }
}

- (void)exchangeToPreviewMusic:(UIButton*)button{
    if (_previewDelegate) {
        [self.delegate didPreviewMusicWithControlBar:self];
    }
}

- (void)touchPlayButton:(UIButton*)button{
    button.selected  = !button.isSelected;
    if (button.isSelected) {
        if (_playDelegate) {
            [self.delegate didPlayMusicWithControlBar:self];
        }
    }else{
        if (_pauseDelegate) {
            [self.delegate didPauseMusicWithControlBar:self];
        }
    }
}

#pragma mark
#pragma mark public method
- (void)reloadUIWithMusic:(YKMusicModel*)music{
    
    self.music = music;
    
    //disable control bar
    _playBtn.selected = [YKMusicPlayeMananger manager].playing;
    
    //init progress
    self.progressView.totalTime = music.totalDuration;
    self.progressView.playProgress = [YKMusicPlayeMananger manager].playProgress;
}
@end
