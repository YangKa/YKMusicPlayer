//
//  YKNavigationView.h
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKNavigationView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title dismiss:(dispatch_block_t)dimissBlock;

@end
