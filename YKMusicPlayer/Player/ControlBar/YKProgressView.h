//
//  YKProgressView1.h
//  TestDemo
//
//  Created by qiager on 2017/12/2.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKProgressView : UIView

@property (nonatomic, readonly, assign, getter=isDragging) BOOL dragging;

@property (nonatomic, readonly, assign) CGFloat playTime;

@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, assign) CGFloat cacheProgress;

@property (nonatomic, assign) CGFloat playProgress;

- (instancetype)initWithFrame:(CGRect)frame
                    textColor:(UIColor*)textColor
                     fontSize:(CGFloat)fontSize;

@end
