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

@interface YKPlayViewController ()<YKControlBarDelegate, UIScrollViewDelegate>{
    BOOL _isNotFirstShow;
}

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) YKNavigationView *navView;

@property (nonatomic, strong) YKControlBar *controlBar;

@property (nonatomic, strong) YKPlayScrollView *playScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

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
        [self reloadUIData];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addObserver];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeObserver];
}

- (void)addObserver{
    [[YKMusicPlayeMananger manager] addObserver:self forKeyPath:@"playProgress" options:NSKeyValueObservingOptionNew context:nil];
    [[YKMusicPlayeMananger manager] addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    [[YKMusicPlayeMananger manager] addObserver:self forKeyPath:@"music" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUIData) name:PlayNextMusicNotificationKey object:nil];
}

- (void)removeObserver{
    [[YKMusicPlayeMananger manager] removeObserver:self forKeyPath:@"playProgress"];
    [[YKMusicPlayeMananger manager] removeObserver:self forKeyPath:@"cacheProgress"];
    [[YKMusicPlayeMananger manager] removeObserver:self forKeyPath:@"music"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    playScrollView.delegate = self;
    [backView addSubview:playScrollView];
    self.playScrollView = playScrollView;
    
    [self.view addSubview:self.pageControl];
    self.pageControl.currentPage = 0 ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"music"]) {
        [self reloadUIData];
    }
    
    if ([keyPath isEqualToString:@"playProgress"]) {
        [self.playScrollView refreshUI];
        float playProgress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.controlBar setPlayProgress:playProgress];
    }
    
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        float cacheProgress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.controlBar setCacheProgress:cacheProgress];
    }
}

#pragma mark
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger pageIndex = (scrollView.contentOffset.x + scrollView.yk_width/2) / scrollView.yk_width;
    self.pageControl.currentPage = pageIndex;
}

#pragma mark
#pragma mark YKControlBarDelegate
- (void)didNextMusicWithControlBar:(YKControlBar*)controlBar{
    [[YKMusicPlayeMananger manager] playNextMusic];
}

- (void)didPreviewMusicWithControlBar:(YKControlBar*)controlBar{
    [[YKMusicPlayeMananger manager] playPreviewMusic];
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
    
    UIImage *image = [UIImage imageNamed:music.bigIconName];
    self.bgImageView.image = image;
    
    //navigation
    [self.navView reloadUIWithTitle:music.title];
    
    //refresh play page  and LRC page
    [self.playScrollView  reloadUIWithMusic:music];
    self.playScrollView.playing = YES;
    
    //refresh control bar
    [self.controlBar reloadUIWithMusic:music];
}

#pragma mark
#pragma mark
- (UIPageControl*)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.yk_width - 60)/2, self.playScrollView.yk_maxY - 30, 60, 30)];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}
@end
