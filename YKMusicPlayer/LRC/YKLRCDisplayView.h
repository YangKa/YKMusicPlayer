//
//  YKLRCDisplayView.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKMusicModel.h"

@interface YKLRCDisplayView : UIView

- (void)reloadUIWithMusicLRCList:(NSArray*)list;

- (void)seekToLineIndex:(NSUInteger)index progress:(CGFloat)progress;

@end
