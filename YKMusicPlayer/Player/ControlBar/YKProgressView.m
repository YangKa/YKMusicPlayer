//
//  YKProgressView1.m
//  TestDemo
//
//  Created by qiager on 2017/12/2.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKProgressView.h"
#import "YKMusicPlayeMananger.h"

@interface CALayer (YKFrame)

- (void)setWidth:(CGFloat)width;

@end

@implementation CALayer (YKFrame)

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
@end

@interface YKProgressView (){
    UIColor *_textColor;
    UIFont *_textFont;
    CGFloat _fontSize;
    
    CGFloat _minX;
    CGFloat _maxX;
    CGPoint _lastPoint;
}

@property (nonatomic, assign, getter=isDragging) BOOL dragging;

@property (nonatomic, assign) CGFloat playTime;

@property (nonatomic, strong) CATextLayer *progressTimeLayer;
@property (nonatomic, strong) CATextLayer *totalTimeLayer;

@property (nonatomic, strong) CALayer *cacheProgressLayer;
@property (nonatomic, strong) CALayer *playProgressLayer;

@property (nonatomic, strong) CALayer *thumbImage;

@end



static CGFloat TimeWidth  = 45.0f;
static CGFloat IntervalMargin = 10.0f;
static CGFloat LineHeight = 4;
#define ProgressWidth   (self.frame.size.width - 2*TimeWidth - 2*IntervalMargin)

#define Color1  [UIColor colorWithWhite:1 alpha:1.0]
#define Color2  [UIColor colorWithWhite:0.7 alpha:1.0]
#define Color3  [UIColor greenColor]

@implementation YKProgressView

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor*)textColor fontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        _playTime = 0;
        
        _totalTime = 0;
        _playProgress = 0.0;
        _cacheProgress = 0.0;
        
        _minX = TimeWidth + IntervalMargin;
        _maxX = _minX + ProgressWidth;
        
        _textColor = textColor;
        _fontSize = fontSize;
        _textFont = [UIFont systemFontOfSize:fontSize];
        
        [self layoutUI];
    }
    return self;
}

#pragma mark
#pragma mark layoutUI
- (void)layoutUI{
    
    self.progressTimeLayer = [self textLayerWithAlign:@"right" origionX:0];
    [self.layer addSublayer:self.progressTimeLayer];
    
    self.totalTimeLayer = [self textLayerWithAlign:@"left" origionX:self.frame.size.width - TimeWidth];
    [self.layer addSublayer:self.totalTimeLayer];
    
    CATextLayer *rightLayer = [CATextLayer layer];
    rightLayer.string = @"00:00";
    rightLayer.alignmentMode = @"left";
    rightLayer.fontSize = _fontSize;
    rightLayer.foregroundColor = _textColor.CGColor;
    [self.layer addSublayer:rightLayer];
    
    CALayer *progressLayer1 = [self layerWithLineColor:Color1 progress:1.0];
    [self.layer addSublayer:progressLayer1];
    
    CALayer *progressLayer2 = [self layerWithLineColor:Color2 progress:0.0];
    [self.layer addSublayer:progressLayer2];
    self.cacheProgressLayer = progressLayer2;
    
    CALayer *progressLayer3 = [self layerWithLineColor:Color3 progress:0.0];
    [self.layer addSublayer:progressLayer3];
    self.playProgressLayer = progressLayer3;
    
    CALayer *thumbImage = [CALayer layer];
    thumbImage.bounds = CGRectMake(0, 0, 24, 24);
    thumbImage.backgroundColor = [UIColor clearColor].CGColor;
    thumbImage.cornerRadius = thumbImage.frame.size.height/2;
    thumbImage.masksToBounds = YES;
    thumbImage.position = CGPointMake(TimeWidth + IntervalMargin, self.frame.size.height/2);
    [self.layer addSublayer:thumbImage];
    self.thumbImage = thumbImage;
}

- (CATextLayer*)textLayerWithAlign:(NSString*)align origionX:(CGFloat)origionX{
    
    CGFloat height = [@"00" sizeWithAttributes:@{NSFontAttributeName:_textFont}].height;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = @"00:00";
    textLayer.alignmentMode = align;
    textLayer.fontSize = _fontSize;
    textLayer.foregroundColor = _textColor.CGColor;
    textLayer.frame = CGRectMake(origionX, (self.frame.size.height - height)/2, TimeWidth, height);
    return textLayer;
}

- (CALayer*)layerWithLineColor:(UIColor*)color progress:(CGFloat)progress{
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = color.CGColor;
    CGFloat Y = (self.frame.size.height - LineHeight)/2;
    layer.frame = CGRectMake(TimeWidth + IntervalMargin, Y, ProgressWidth*progress, LineHeight);
    
    return layer;
}

#pragma mark
#pragma mark private method
- (NSString*)timeFormatWithIntervalTime:(NSTimeInterval)time{
    
    int hour = time / 3600;
    time -= 3600*hour;
    
    int mintue = time / 60;
    int second = time - 60*mintue;
    
    NSString *timeStr;
    if (hour > 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, mintue, second];
    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d", mintue, second];
    }
    return timeStr;
}

#pragma mark
#pragma mark getter or setter
- (void)setCacheProgress:(CGFloat)cacheProgress{
    _cacheProgress = cacheProgress > self.playProgress ? cacheProgress:self.playProgress;
    CGFloat width = _cacheProgress*ProgressWidth;

    [self.cacheProgressLayer setWidth:width];
}

- (void)setPlayProgress:(CGFloat)playProgress{

    _playProgress = self.totalTime <= 0 ? 0:playProgress;
    
    self.playTime = self.totalTime*_playProgress;
    
    if (!self.isDragging){
        NSLog(@"[YKMusicPlayeMananger manager].playProgress=%f", [YKMusicPlayeMananger manager].playProgress);
        CGFloat width = _playProgress*ProgressWidth;
        [self.playProgressLayer setWidth:width];
        
        CGFloat centerX = _minX + width;
        self.thumbImage.position = CGPointMake(centerX, self.thumbImage.position.y);
    }
}

- (void)setTotalTime:(CGFloat)totalTime{
    _totalTime = totalTime;
    
    self.totalTimeLayer.string = [self timeFormatWithIntervalTime:(NSTimeInterval)_totalTime];
    self.playProgress = 0;
    self.cacheProgress = 0;
}

- (void)setPlayTime:(CGFloat)playTime{
    _playTime = playTime;
    self.progressTimeLayer.string = [self timeFormatWithIntervalTime:(NSTimeInterval)playTime];
}

#pragma mark
#pragma mark
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    self.dragging = [self.thumbImage containsPoint:point];
    if (self.isDragging) {
        _lastPoint = point;
        self.thumbImage.backgroundColor = [UIColor greenColor].CGColor;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    if (self.isDragging) {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGFloat centerX = self.thumbImage.position.x + (point.x - _lastPoint.x);
        centerX = MAX(MIN(centerX, _maxX), _minX);
        CGFloat width = centerX - _minX;
        
        NSLog(@"width=%f", width);
        [self.playProgressLayer setWidth:width];
        self.thumbImage.position = CGPointMake(centerX, self.thumbImage.position.y);
        
        _lastPoint = point;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat centerX = self.thumbImage.position.x + (point.x - _lastPoint.x);
    centerX = MAX(MIN(centerX, _maxX), _minX);
    CGFloat width = centerX - _minX;
    
    self.thumbImage.backgroundColor = [UIColor clearColor].CGColor;
    _lastPoint = CGPointZero;
    
    self.playProgress = width / ProgressWidth;
    
    NSLog(@"end width=%f  progress=%f", width, self.playProgress);
    
    int timeValue = (int)(self.playProgress*self.totalTime);
    [[YKMusicPlayeMananger manager] seekToTime:CMTimeMake(timeValue, 1)];
    
    self.dragging = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
    _lastPoint = CGPointZero;
    self.thumbImage.backgroundColor = [UIColor clearColor].CGColor;
    self.dragging = NO;
}



@end


