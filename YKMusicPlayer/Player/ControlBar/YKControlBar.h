//
//  YKControlBar.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKControlBar;
@class YKMusicModel;

@protocol YKControlBarDelegate <NSObject>

- (void)didNextMusicWithControlBar:(YKControlBar*)controlBar;

- (void)didPreviewMusicWithControlBar:(YKControlBar*)controlBar;

- (void)didPlayMusicWithControlBar:(YKControlBar*)controlBar;

- (void)didPauseMusicWithControlBar:(YKControlBar*)controlBar;

@end

@interface YKControlBar : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)target;

- (void)reloadUIWithMusic:(YKMusicModel*)music;

- (void)setPlayProgress:(CGFloat)progress;

- (void)setCacheProgress:(CGFloat)progress;



@end
