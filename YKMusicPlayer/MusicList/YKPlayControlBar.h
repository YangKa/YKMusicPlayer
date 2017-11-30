//
//  YKPlayControlBar.h
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/29.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKPlayControlBar : UIView

- (instancetype)initWithFrame:(CGRect)frame touchIconBlock:(dispatch_block_t)touchBlock;

- (void)reloadUI;

@end
