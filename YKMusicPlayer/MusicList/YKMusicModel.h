//
//  YKMusicModel.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/23.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKMusicModel : NSObject

@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly, copy) NSString *filePath;

@property (nonatomic, readonly, copy) NSString *LRCFilePath;

@property (nonatomic, readonly, copy) NSString *singerName;

@property (nonatomic, readonly, copy) NSString *iconName;

@property (nonatomic, readonly, copy) NSString *bigIconName;

@property (nonatomic, readonly, assign) CGFloat totalDuration;

+ (instancetype)musicModelWithInfo:(NSDictionary*)info;

@end
