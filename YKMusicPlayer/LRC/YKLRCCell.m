//
//  YKLRCCell.m
//  YKMusicPlayer
//
//  Created by 杨卡 on 2017/11/21.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKLRCCell.h"
#import "YKLRCLabel.h"

@interface YKLRCCell (){
    YKLRCLabel *label;
}

@property (nonatomic, assign) BOOL isBiggerText;

@end

@implementation YKLRCCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    label = [[YKLRCLabel alloc] init];
    label.progress = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:label];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setLRCText:(NSString *)text{
    label.text = text;
    [label sizeToFit];
}

- (void)setProgress:(CGFloat)prgress{
    _progress = prgress;
    
    //进度
    label.progress = prgress;
    
    //字体
    BOOL isprocess = (prgress > 0 && prgress < 1.0) ? YES:NO;
    self.isBiggerText = isprocess;
}

- (void)setIsBiggerText:(BOOL)isBiggerText{
    _isBiggerText = isBiggerText;
    
    label.font = _isBiggerText ?  [UIFont systemFontOfSize:20] :[UIFont systemFontOfSize:15];
    [label sizeToFit];
    label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end

