//
//  YKLRCModel.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKLRCModel : NSObject

//歌词
@property (nonatomic, readonly, copy) NSString *text;

//开始时间
@property (nonatomic, readonly, assign) CGFloat beginTime;

//总时长
@property (nonatomic, readonly, assign) CGFloat duration;

//分段时长
@property (nonatomic, readonly, copy) NSArray *segementTimes;

+ (instancetype)LRCWithContent:(NSString*)content duration:(CGFloat)duration beginTime:(CGFloat)beginTime segementTimes:(NSArray*)times;


@end
