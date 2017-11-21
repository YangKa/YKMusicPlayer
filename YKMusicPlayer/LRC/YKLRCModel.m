//
//  YKLRCModel.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCModel.h"

@interface YKLRCModel ()

//歌词
@property (nonatomic, copy) NSString *text;

//总时长
@property (nonatomic, assign) NSTimeInterval totalTime;

//分段时长
@property (nonatomic, copy) NSArray *segementTimes;

@end

@implementation YKLRCModel

+ (instancetype)LRCWithContent:(NSString*)content totalTime:(NSTimeInterval)time segementTimes:(NSArray*)times{
    YKLRCModel *model = [[YKLRCModel alloc] init];
    
    model.text = content;
    model.totalTime = time;
    model.segementTimes = times;
    
    return model;
}

@end

