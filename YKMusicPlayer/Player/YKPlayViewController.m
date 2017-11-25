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
@interface YKPlayViewController ()

@property (nonatomic, strong) YKMusicModel *music;

@property (nonatomic, strong) YKControlBar *controlBar;

@end

@implementation YKPlayViewController

- (instancetype)initWithMusic:(YKMusicModel*)music{
    self = [super init];
    if (self){
        _music = music;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
    
    [[YKMusicPlayeMananger manager] startPlayWithMusic:_music];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[YKMusicPlayeMananger manager] addObserver:self.controlBar forKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[YKMusicPlayeMananger manager] removeObserver:self.controlBar forKeyPath:@"currentPlayTime"];
}

- (void)layoutUI{
    
    //背景海报
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:self.music.bigIconName];
    [self.view addSubview:imageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = imageView.bounds;
    effectView.alpha = 0.9;
    [imageView addSubview:effectView];
    
    //内容
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    
    CGRect frame = CGRectMake(0, 0, self.view.yk_width, self.view.yk_height - 100);
    YKPlayScrollView *playScrollView = [[YKPlayScrollView alloc] initWithFrame:frame music:self.music];
    [backView addSubview:playScrollView];
    
    
    //控制栏
    CGRect frame1 = CGRectMake(0, playScrollView.yk_maxY, self.view.yk_width, self.view.yk_height - playScrollView.yk_maxY);
    YKControlBar *controlBar = [[YKControlBar alloc] initWithFrame:frame1 music:self.music];
    [backView addSubview:controlBar];
    self.controlBar = controlBar;
    
    //导航栏
    YKNavigationView *navView = [[YKNavigationView alloc] initWithFrame:CGRectMake(0, 0, backView.yk_width, 64) title:self.music.title dismiss:^{
        
        [[YKMusicPlayeMananger manager] cancelPlay];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [backView addSubview:navView];
}

@end
