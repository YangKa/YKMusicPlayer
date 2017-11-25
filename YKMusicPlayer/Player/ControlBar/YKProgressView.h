//
//  YKProgressView.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/25.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)setDuration:(NSTimeInterval)duration progress:(NSTimeInterval)progress;

@end
