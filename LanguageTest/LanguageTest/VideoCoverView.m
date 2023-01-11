//
//  VideoCoverView.m
//  QingKuai
//
//  Created by mac on 2022/6/14.
//

#import "VideoCoverView.h"
#import <ZFPlayer/ZFPlayerController.h>

@implementation VideoCoverView

@synthesize player = _player;

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    !self.tapBlock ?: self.tapBlock(self.player.currentPlayIndex);
}
- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
- (void)updateCoverView:(NSString *)cover placeholderImage:(UIImage *)placeholderImage  {
//    [self.player.currentPlayerManager.view.coverImageView setImageUrl:cover placeholderImage:placeholderImage];
    
    
}


/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
     if (state == ZFPlayerLoadStatePlayable || state == ZFPlayerLoadStatePlaythroughOK) {
        self.player.currentPlayerManager.view.hidden = false;
    } else {
        self.player.currentPlayerManager.view.hidden = true;
    }

}



@end
