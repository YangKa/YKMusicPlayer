//
//  YKLRCDisplayView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCDisplayView.h"
#import "YKLRCModel.h"
#import "YKLRCCell.h"
#import "YKLRCParser.h"

@interface YKLRCDisplayView ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_lrclist;
    UITableView *tableView;
    
    CADisplayLink *playLink;
    NSDate *beginTime;
    
    NSInteger _curRow;
    float _totalTime;
}

@end

static CGFloat CellHeight = 50;
@implementation YKLRCDisplayView

- (instancetype)initWithFrame:(CGRect)frame lrcFilePath:(NSString*)lrcFilePath
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _curRow = 0;
        _totalTime = 0;
        
        YKLRCParser *lrcPaser = [[YKLRCParser alloc] init];
        _lrclist = [lrcPaser paserLRCForFilePath:lrcFilePath];
        
        [self layoutUI];
        [self scrollToNextWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [self beginPlay];
    }
    return self;
}

- (UIImage*)gaussianBlurForImage:(UIImage*)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(4) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    
    return [UIImage imageWithCGImage:outImage];
}

- (void)layoutUI{
    CGFloat paddding = (self.frame.size.height - CellHeight)/2;
    
    //海报背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleToFill;
    UIImage *image = [self gaussianBlurForImage:[UIImage imageNamed:@"bg"]];
    NSLog(@"%@", NSStringFromCGSize(image.size));
    NSLog(@"%@", NSStringFromCGSize(imageView.frame.size));
    imageView.image = image;
    [self addSubview:imageView];
    
    //渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height);
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.05].CGColor,
                             (id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                             (id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,
                             (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor,
                             (id)[UIColor colorWithWhite:0 alpha:0.6].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0, @0.1, @0.2, @0.35, @0.45, @0.5];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    [self addSubview:backView];
    backView.layer.mask = gradientLayer;
    
    //歌词列表
    tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(paddding , 0, paddding, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YKLRCCell class] forCellReuseIdentifier:@"YKLRCCell"];
    [backView addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //中间层
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, paddding, tableView.frame.size.width, 1)];
    upLine.backgroundColor = [UIColor greenColor];
    [self addSubview:upLine];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, paddding + CellHeight, tableView.frame.size.width, 1)];
    downLine.backgroundColor = [UIColor greenColor];
    [self addSubview:downLine];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lrclist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YKLRCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKLRCCell"];
    
    YKLRCModel *model = _lrclist[indexPath.row];
    [cell setLRCText:model.text];
    
    if (indexPath.row > _curRow ){
        [cell setProgress:0.0];
    }
    if (indexPath.row < _curRow) {
        [cell setProgress:1.0];
    }
    
    return cell;
}

- (void)beginPlay{
    beginTime = [NSDate date];
    playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshLRCList)];
    [playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)refreshLRCList{
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:beginTime];
    
    YKLRCModel *model = _lrclist[_curRow];
    CGFloat progress = interval/model.totalTime;
    
    if (progress >=1) {
        
        if (_curRow == _lrclist.count -1 ) {
            [playLink invalidate];
        }else{
            
            beginTime = [NSDate date];
            
            _curRow++;
            [self scrollToNextWithIndexPath:[NSIndexPath indexPathForRow:_curRow inSection:0]];
        }
        
    }else{
        YKLRCCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_curRow inSection:0]];
        [cell setProgress:progress];
    }
}

- (void)scrollToNextWithIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row != 0) {
        YKLRCCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
        oldCell.layer.transform = CATransform3DIdentity;
        [oldCell setProgress:1.0];
        oldCell.isBiggerText = NO;
    }
    
    YKLRCCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.isBiggerText = YES;
    [newCell setProgress:0.0];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
@end
