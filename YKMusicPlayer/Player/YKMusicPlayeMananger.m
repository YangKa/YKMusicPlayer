//
//  YKMusicPlayeMananger.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicPlayeMananger.h"

@implementation YKMusicPlayeMananger

+ (instancetype)manager{
    static id instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[YKMusicPlayeMananger alloc] init];
    });
    return instace;
}

@end
