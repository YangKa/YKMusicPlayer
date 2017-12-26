//
//  YKScreenPlayMananger.h
//  YKMusicPlayer
//
//  Created by qiager on 2017/12/5.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKScreenPlayMananger : NSObject

+ (instancetype)manager;

- (BOOL)showPlayingInfoOnScreen:(NSDictionary*)info;

@end
