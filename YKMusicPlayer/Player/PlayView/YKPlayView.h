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

@property (nonatomic, assign) BOOL playing;

- (void)reloadUIWithIconImage:(UIImage*)image singer:(NSString*)singer;

- (void)showLRCText:(NSString*)LRCText progress:(CGFloat)progress;

@end
