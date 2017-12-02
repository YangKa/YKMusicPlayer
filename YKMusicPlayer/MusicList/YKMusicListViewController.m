//
//  YKMusicListViewController.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicListViewController.h"
#import "YKMusicModel.h"
#import "YKPlayViewController.h"
#import "YKMusicPlayeMananger.h"
#import "YKPlayControlBar.h"

@interface YKMusicListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *tableView;
}

@property (nonatomic, copy) NSArray *musicList;

@property (nonatomic, strong) YKPlayControlBar *playControlBar;

@end

static NSString *CellIdentifer = @"CellIdentifer";
static CGFloat PlayControlBarHeight = 70;
@implementation YKMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.musicList = [[YKMusicPlayeMananger manager] currentMusicList];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    if ([YKMusicPlayeMananger manager].music) {
        [self showPlayControlBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshControlBar) name:PlayNextMusicNotificationKey object:nil];
    }else{
        [self removePlayControlBar];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.playControlBar){
        [[YKMusicPlayeMananger manager] removeObserver:self.playControlBar forKeyPath:@"playProgress"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark
#pragma mark  layoutUI
- (void)layoutUI{
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.yk_width, self.view.yk_height - 64)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.estimatedRowHeight = 80;
    [self.view addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
    }
    
    YKMusicModel *model = self.musicList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.iconName];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.singerName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKMusicModel *music = self.musicList[indexPath.row];
    [[YKMusicPlayeMananger manager] startPlayWithMusic:music];
    
    if (self.playControlBar) {
        [self.playControlBar reloadUI];
    }else{
        [self showPlayView];
    }
}

#pragma mark
#pragma mark private method
- (void)showPlayView{
    YKPlayViewController *playVC = [[YKPlayViewController alloc] init];
    [self presentViewController:playVC animated:YES completion:nil];
}

- (void)refreshControlBar{
    if (self.playControlBar) {
        [self.playControlBar reloadUI];
    }
}

- (void)showPlayControlBar{
    if (!self.playControlBar) {
        
        __weak typeof(self) weakSelf = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, PlayControlBarHeight, 0);
        self.playControlBar = [[YKPlayControlBar alloc] initWithFrame:CGRectMake(0, self.view.yk_height - PlayControlBarHeight, self.view.yk_width, PlayControlBarHeight) touchIconBlock:^{
            [weakSelf showPlayView];
        }];
        [self.view addSubview:self.playControlBar];
    }
    
    [self.playControlBar reloadUI];
    [[YKMusicPlayeMananger manager] addObserver:self.playControlBar forKeyPath:@"playProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removePlayControlBar{
    if (self.playControlBar) {
        
        [[YKMusicPlayeMananger manager] removeObserver:self.playControlBar forKeyPath:@"playProgress"];
        
        [self.playControlBar removeFromSuperview];
        self.playControlBar = nil;
        tableView.contentInset = UIEdgeInsetsZero;
    }
}
@end
