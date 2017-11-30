//
//  YKPlayScrollView.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKMusicModel;

@interface YKPlayScrollView : UIScrollView

@property (nonatomic, assign) BOOL playing;

- (void)reloadUIWithMusic:(YKMusicModel*)music;

- (void)refreshUI;

@end
