//
//  VideoCoverView.h
//  QingKuai
//
//  Created by mac on 2022/6/14.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCoverView : UIView<ZFPlayerMediaControl>
@property(nonatomic,copy) void(^tapBlock)(NSInteger index);
- (void)updateCoverView:(NSString *)cover placeholderImage:(UIImage *_Nullable)placeholderImage;

@end

NS_ASSUME_NONNULL_END
