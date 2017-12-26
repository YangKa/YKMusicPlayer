//
//  YKScreenPlayMananger.m
//  YKMusicPlayer
//
//  Created by qiager on 2017/12/5.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKScreenPlayMananger.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation YKScreenPlayMananger

+ (instancetype)manager{
    static id instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[YKScreenPlayMananger alloc] init];
    });
    return instace;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configRemoteCommandHandler];
    }
    return self;
}

- (BOOL)showPlayingInfoOnScreen:(NSDictionary *)info{
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * (CGSize size) {
        return  [self drawImage:info[@"artwork"] withLRCText:info[@"LRCText"]];
    }];

    NSDictionary *playingInfo = @{MPMediaItemPropertyTitle:info[@"title"],
                                  MPMediaItemPropertyArtist:info[@"artist"],
                                  MPMediaItemPropertyPlaybackDuration:info[@"duration"],
                                  MPNowPlayingInfoPropertyElapsedPlaybackTime:info[@"playTime"],
                                  MPNowPlayingInfoPropertyPlaybackRate:info[@"playRate"],
                                  MPMediaItemPropertyArtwork:artwork
                                  };
    NSLog(@"playingInfo=%@", playingInfo);
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:playingInfo];
    
    return YES;
}

#pragma mark
#pragma mark remote command
- (void)configRemoteCommandHandler{
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand addTarget:self action:@selector(playCommand:)];
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseCommand:)];
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackCommand:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackCommand:)];
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(togglePlayPauseCommand:)];
}

- (void)playCommand:(MPRemoteCommand*)command{
    NSLog(@"playCommand");
}

- (void)pauseCommand:(MPRemoteCommand*)command{
     NSLog(@"pauseCommand");
}

- (void)nextTrackCommand:(MPRemoteCommand*)command{
     NSLog(@"nextTrackCommand");
}

- (void)previousTrackCommand:(MPRemoteCommand*)command{
     NSLog(@"previousTrackCommand");
}

- (void)togglePlayPauseCommand:(MPRemoteCommand*)command{
     NSLog(@"togglePlayPauseCommand");
}

#pragma mark
#pragma mark 绘制歌词
- (UIImage*)drawImage:(UIImage*)image withLRCText:(NSString*)LRCText{

    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    
    UIFont *font = [UIFont systemFontOfSize:15];
    [LRCText drawInRect:CGRectMake(0, image.size.height - 40, image.size.width, 40)
         withAttributes:@{NSFontAttributeName:font}];
    
    UIImage *newImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
