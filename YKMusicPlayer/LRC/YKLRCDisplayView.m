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

#import "YKMusicPlayeMananger.h"

@interface YKLRCDisplayView ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_lrclist;
    UITableView *tableView;
    
    CADisplayLink *playLink;
    
    NSUInteger _lastProcessLine;
    NSUInteger _curProcessLine;
}

@property (nonatomic, assign) BOOL isScrolling;

@end

static CGFloat CellHeight = 50;
@implementation YKLRCDisplayView

- (instancetype)initWithFrame:(CGRect)frame lrcFilePath:(NSString*)lrcFilePath
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lastProcessLine = 0;
        _curProcessLine = 0;
        
        YKLRCParser *lrcPaser = [[YKLRCParser alloc] init];
        _lrclist = [lrcPaser paserLRCForFilePath:lrcFilePath];
        
        [self layoutUI];

        playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDispaly)];
        [playLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)layoutUI{
    CGFloat paddding = (self.frame.size.height - CellHeight)/2;

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
    
    if (indexPath.row > _curProcessLine ){
        if (cell.progress != 0) {
            cell.progress = 0.0;
        }
    }
    if (indexPath.row < _curProcessLine) {
        if (cell.progress != 1.0) {
            cell.progress = 1.0;
        }
    }
    
    return cell;
}

#pragma mark
#pragma mark control LRC line scroll and render
- (void)refreshDispaly{
    NSTimeInterval frameTime = [YKMusicPlayeMananger manager].currentPlayTime;
    [self seekToTime:frameTime];
}

- (void)seekToTime:(NSTimeInterval)frameTime{
    
    _curProcessLine = [self lineIndexForTime:frameTime];
    if (self.isScrolling) {
        return;
    }
    
    if (_lastProcessLine != _curProcessLine) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:_curProcessLine inSection:0];
        [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    _lastProcessLine = _curProcessLine;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray *cells = [tableView visibleCells];
        for (YKLRCCell *cell in cells) {
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            
            if (indexPath.row < _curProcessLine) {
                if (cell.progress != 1) {
                    cell.progress = 1.0;
                }
            }else if (indexPath.row == _curProcessLine) {
                
                YKLRCModel *model = [_lrclist objectAtIndex:indexPath.row];
                CGFloat progress = (frameTime - model.beginTime + 1)/model.duration;
                progress = MAX(progress, 0);
                
                if ( (progress >= 1) && (indexPath.row  < _lrclist.count - 2) ) {
                    
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
                    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }else{
                    cell.progress = progress;
                }
                
            }else if (indexPath.row > _curProcessLine){
                if (cell.progress != 0) {
                    cell.progress = 0.0;
                }
            }
        }
    });
}

- (NSUInteger)lineIndexForTime:(NSTimeInterval)time{
    __block NSUInteger currentIndex = _curProcessLine;
    [_lrclist enumerateObjectsUsingBlock:^(YKLRCModel  *model, NSUInteger index, BOOL * _Nonnull stop) {

        if (time >= model.beginTime && time - model.beginTime < model.duration) {
            
            currentIndex = index;
            *stop = YES;
        }
    }];
    
    return currentIndex;
}

#pragma mark
#pragma mark reload data
- (void)reloadUIWithMusic:(YKMusicModel*)music{
    
}

#pragma mark
#pragma mark setter
- (BOOL)isScrolling{
    return tableView.isDragging || tableView.tracking;
}
@end
