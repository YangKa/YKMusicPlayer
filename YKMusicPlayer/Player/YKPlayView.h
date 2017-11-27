//
//  YKPlayView.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  YKMusicModel;

@interface YKPlayView : UIView

- (instancetype)initWithFrame:(CGRect)frame music:(YKMusicModel*)music;

- (void)reloadUIWithMusic:(YKMusicModel*)music;

- (void)stopRotationAnimation;

@end
