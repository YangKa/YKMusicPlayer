//
//  YKLRCCell.h
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLRCCell : UITableViewCell

- (void)setLRCText:(NSString*)text;

- (void)setProgress:(CGFloat)prgress;

@property (nonatomic, assign) BOOL isBiggerText;

@end
