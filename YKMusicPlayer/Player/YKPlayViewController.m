//
//  YKPlayViewController.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayViewController.h"
#import "YKPlayScrollView.h"
#import "YKControlBar.h"
#import "YKNavigationView.h"
#import "YKMusicPlayeMananger.h"

@interface YKPlayViewController ()<YKControlBarDelegate>{
    BOOL _isNotFirstShow;
}

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) YKNavigationView *navView;

@property (nonatomic, strong) YKControlBar *controlBar;

@property (nonatomic, strong) YKPlayScrollView *playScrollView;

@end

@implementation YKPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_isNotFirstShow) {
        _isNotFirstShow = YES;
        [self layoutUI];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self reloadUIData];
    [[YKMusicPlayeMananger manager] addObserver:self.controlBar forKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[YKMusicPlayeMananger manager] removeObserver:self.controlBar forKeyPath:@"currentPlayTime"];
}

- (void)layoutUI{
    
    //背景海报
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    self.bgImageView = imageView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = imageView.bounds;
    effectView.alpha = 0.9;
    [imageView addSubview:effectView];
    
    //内容
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    
    //导航栏
    YKNavigationView *navView = [[YKNavigationView alloc] initWithFrame:CGRectMake(0, 0, backView.yk_width, 64) dismiss:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [backView addSubview:navView];
    self.navView = navView;
    
    //控制栏
    YKControlBar *controlBar = [[YKControlBar alloc] initWithFrame:CGRectMake(0, backView.yk_height - 100, self.view.yk_width, 100) delegate:self];
    [backView addSubview:controlBar];
    self.controlBar = controlBar;
    
    YKPlayScrollView *playScrollView = [[YKPlayScrollView alloc] initWithFrame:CGRectMake(0, navView.yk_maxY, backView.yk_width,backView.yk_height - controlBar.yk_height - navView.yk_height)];
    [backView addSubview:playScrollView];
    self.playScrollView = playScrollView;
}

#pragma mark
#pragma mark YKControlBarDelegate
- (void)didNextMusicWithControlBar:(YKControlBar*)controlBar{
    [[YKMusicPlayeMananger manager] playNextMusic];
    [self reloadUIData];
}

- (void)didPreviewMusicWithControlBar:(YKControlBar*)controlBar{
    [[YKMusicPlayeMananger manager] playPreviewMusic];
    [self reloadUIData];
}

- (void)didPlayMusicWithControlBar:(YKControlBar*)controlBar{
    [[YKMusicPlayeMananger manager] resumePlay];
    self.playScrollView.playing = YES;
}

- (void)didPauseMusicWithControlBar:(YKControlBar*)controlBar{
    self.playScrollView.playing = NO;
    [[YKMusicPlayeMananger manager] pausePlay];
}

#pragma mark
#pragma mark reload data
- (void)reloadUIData{
    YKMusicModel *music = [YKMusicPlayeMananger manager].music;
    
    self.bgImageView.image = [UIImage imageNamed:self.music.bigIconName];
    
    //navigation
    [self.navView reloadUIWithTitle:music.title];
    
    //refresh play page  and LRC page
    [self.playScrollView  reloadUIWithMusic:music];
    self.playScrollView.playing = YES;
    
    //refresh control bar
    [self.controlBar reloadUIWithMusic:music];
}

@end
