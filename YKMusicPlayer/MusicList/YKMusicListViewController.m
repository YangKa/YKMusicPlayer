//
//  YKMusicListViewController.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKMusicListViewController.h"
#import "YKMusicParser.h"
#import "YKMusicModel.h"
#import "YKPlayViewController.h"

@interface YKMusicListViewController ()

@property (nonatomic, copy) NSArray *musicList;

@end

static NSString *CellIdentifer = @"CellIdentifer";
@implementation YKMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.musicList = [YKMusicParser musicListWithFileName:@"Musics.plist"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 80;
}

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
    
    YKMusicModel *model = self.musicList[indexPath.row];
    YKPlayViewController *playVC = [[YKPlayViewController alloc] initWithMusic:model];
    [self presentViewController:playVC animated:YES completion:nil];
}

@end
