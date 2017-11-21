//
//  LRCLabel.m
//  BQReport
//
//  Created by 杨卡 on 2017/11/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCLabel.h"

@interface YKLRCLabel ()

@end

@implementation YKLRCLabel

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.frame.size.width*_progress, self.frame.size.height);
    
    [[UIColor greenColor] setFill];
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    
    
    [self setNeedsDisplay];
    
}

@end
