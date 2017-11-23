//
//  YKMusicParser.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicParser.h"
#import "YKMusicModel.h"

@implementation YKMusicParser

+ (NSArray*)musicListWithFileName:(NSString*)fileName{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *list = [NSArray arrayWithContentsOfFile:plistPath];
    
    if (!list || list.count == 0) {
        return @[];
    }
    
    NSMutableArray *musicList = @[].mutableCopy;
    for (int i =0 ; i < list.count; i++) {
        NSDictionary *dic = [list objectAtIndex:i];
        YKMusicModel *model = [YKMusicModel musicModelWithInfo:dic];
        [musicList addObject:model];
    }
    
    return musicList.copy;
}

@end
