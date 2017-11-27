//
//  YKLRCParser.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCParser.h"
#import "YKLRCModel.h"

@implementation YKLRCParser

- (NSArray *)paserLRCFileWithFileName:(NSString*)fileName{
    
    NSString *filePath = [self filePathForFileName:fileName];
    return [self paserLRCForFilePath:filePath];
}

- (NSArray*)paserLRCForFilePath:(NSString*)filePath{
    NSArray *list = [self lrcStringListForFilePath:filePath];
    
    return [self paserLRCForFileContentList:list];
}

- (NSArray*)paserLRCForFileContentList:(NSArray*)fileList{
    
    
    NSMutableArray *lrcList = [NSMutableArray array];
    for (int i = 0; i < fileList.count - 1; i++) {
        
        YKLRCModel *model = [self paserSingleLrcText:fileList[i] nextLine:fileList[i+1]];
        if (model) {
            [lrcList addObject:model];
        }
    }
    
    return lrcList.copy;
}


- (NSString*)filePathForFileName:(NSString*)fileName{
    NSString *path;
    if ([fileName containsString:@"."]) {
        NSArray *fileList = [fileName componentsSeparatedByString:@"."];
        path = [[NSBundle mainBundle] pathForResource:fileList.firstObject ofType:fileList.lastObject];
    }else{
        path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"lrc"];
    }
    return path;
}

- (NSArray*)lrcStringListForFilePath:(NSString*)filePath{
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [content componentsSeparatedByString:@"\n"];
}


- (YKLRCModel*)paserSingleLrcText:(NSString*)lrcText nextLine:(NSString*)nextLine{
    
    lrcText = [lrcText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    lrcText = [lrcText stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSMutableArray *list = [[lrcText componentsSeparatedByString:@"]"] mutableCopy];
    if (list.count < 2 || [list.lastObject length] == 0) {
        return nil;
    }
    
    //lrc
    NSString *text = list.lastObject;
    [list removeLastObject];
    
    //time
    NSTimeInterval duration = 0;
    NSTimeInterval beginTime = 0;
    
    NSMutableArray *timeList = [NSMutableArray array];
    for (int i =0; i < list.count; i++) {
        
        NSTimeInterval segementInterval = [self timeIntervalForTimeText:list[i]];
        beginTime += segementInterval;
        [timeList addObject:[NSNumber numberWithDouble:segementInterval]];
    }
    
    //next line time
    nextLine = [nextLine stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    nextLine = [nextLine stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if ( [nextLine containsString:@"]"] && [nextLine containsString:@"["] ) {
        NSArray *nextLineList =  [nextLine componentsSeparatedByString:@"]"];
        NSTimeInterval endTime = [self timeIntervalForTimeText:nextLineList.firstObject];
        
        duration = endTime - beginTime;
    }
    
    return [YKLRCModel LRCWithContent:text duration:duration beginTime:beginTime segementTimes:timeList];
}

//[00:50.37]
- (NSTimeInterval)timeIntervalForTimeText:(NSString*)timeText{
    
    timeText = [timeText stringByReplacingOccurrencesOfString:@"[" withString:@""];
    timeText = [timeText stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSTimeInterval segementInterval;
    if ([timeText containsString:@"."]) {
        NSString *minString = [timeText substringWithRange:NSMakeRange(0, 2)];
        NSString *secString = [timeText substringWithRange:NSMakeRange(3, 2)];
        NSString *mseString = [timeText substringWithRange:NSMakeRange(6, 2)];
        
        segementInterval = [minString integerValue]*60 + [secString integerValue] + [mseString integerValue]*0.001;
    }else{
        NSArray *array = [timeText componentsSeparatedByString:@":"];
        segementInterval = [array[0] integerValue]*60 + [array[1] integerValue];
    }
    
    return segementInterval;
}

@end
