//
//  YKLRCDisplayView.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCDisplayView.h"
#import "YKLRCCell.h"
#import "YKLRCModel.h"

@interface YKLRCDisplayView ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_lrclist;
    UITableView *tableView;
    
    NSUInteger _lastProcessLine;
}

@end

static CGFloat CellHeight = 50;
@implementation YKLRCDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
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
                             (id)[UIColor colorWithWhite:0 alpha:1.0].CGColor,
                             (id)[UIColor colorWithWhite:0 alpha:0.05].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0, @0.2, @0.3, @0.95, @1.0];
    
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
    
    if (indexPath.row > _lastProcessLine ){
        if (cell.progress != 0) {
            cell.progress = 0.0;
        }
    }
    if (indexPath.row < _lastProcessLine) {
        if (cell.progress != 1.0) {
            cell.progress = 1.0;
        }
    }
    return cell;
}

#pragma mark
#pragma mark UISCrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:_lastProcessLine inSection:0];
    BOOL animation = [[tableView indexPathsForVisibleRows] containsObject:newIndexPath];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animation];
}

#pragma mark
#pragma mark control LRC line scroll and render
- (void)seekToLineIndex:(NSUInteger)index progress:(CGFloat)progress{
    if ([self isScrolling]) {
        NSLog(@"scrolling");
    }
    if (_lastProcessLine != index && ![self isScrolling]) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    _lastProcessLine = index;
    
    if ([self isScrolling]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray *cells = [tableView visibleCells];
        for (YKLRCCell *cell in cells) {
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            
            if (indexPath.row < _lastProcessLine) {
                if (cell.progress != 1) {
                    cell.progress = 1.0;
                }
            }else if (indexPath.row == _lastProcessLine) {
                
                if ( (progress >= 1) && (indexPath.row  < _lrclist.count - 2) ) {
                    
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
                    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }else{
                    cell.progress = progress;
                }
            }else if (indexPath.row > _lastProcessLine){
                if (cell.progress != 0) {
                    cell.progress = 0.0;
                }
            }
        }
    });
}

#pragma mark
#pragma mark reload data
- (void)reloadUIWithMusicLRCList:(NSArray*)list{
    
    _lastProcessLine = 0;
    
    _lrclist = [list copy];
    [tableView reloadData];
    [tableView scrollsToTop];
    
}

#pragma mark
#pragma mark setter
- (BOOL)isScrolling{
 
    return tableView.isDragging || tableView.tracking;
}
@end
