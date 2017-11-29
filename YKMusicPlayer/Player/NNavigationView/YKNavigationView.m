//
//  YKNavigationView.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKNavigationView.h"

@interface YKNavigationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) dispatch_block_t dimissBlock;

@end

@implementation YKNavigationView

- (instancetype)initWithFrame:(CGRect)frame dismiss:(dispatch_block_t)dimissBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dimissBlock = [dimissBlock copy];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 40)];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [backButton setBackgroundImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dimissPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)dimissPage{
    if (_dimissBlock) {
        _dimissBlock();
    }
}

- (void)reloadUIWithTitle:(NSString*)title{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.yk_width/2, 40);
    
}

@end
