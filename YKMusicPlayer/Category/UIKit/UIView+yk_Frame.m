//
//  UIView+yk_Frame.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/11/24.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "UIView+yk_Frame.h"

@implementation UIView (yk_Frame)

- (CGFloat)yk_X{
    return self.frame.origin.x;
}

- (CGFloat)yk_minX{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)yk_midX{
    return CGRectGetMidY(self.frame);;
}

- (CGFloat)yk_maxX{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)yk_Y{
    return self.frame.origin.y;
}

- (CGFloat)yk_minY{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)yk_midY{
    return CGRectGetMidY(self.frame);
}

- (CGFloat)yk_maxY{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)yk_height{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)yk_width{
    return CGRectGetWidth(self.frame);
}

- (CGSize)yk_size{
    return self.frame.size;
}

@end
