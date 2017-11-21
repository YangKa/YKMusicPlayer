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

@end

@implementation YKPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)layoutUI{
    YKPlayScrollView *playScrollView = [[YKPlayScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self.view addSubview:playScrollView];
}

@end
