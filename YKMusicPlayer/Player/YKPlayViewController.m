//
//  YKPlayViewController.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKPlayViewController.h"
#import "YKPlayScrollView.h"

@interface YKPlayViewController ()

@property (nonatomic, strong) YKMusicModel *music;

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)layoutUI{
    YKPlayScrollView *playScrollView = [[YKPlayScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100) lrcFilePath:self.music.LRCFilePath];
    [self.view addSubview:playScrollView];
}

@end
