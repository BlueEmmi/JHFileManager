//
//  VideoModel.h
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign) NSInteger agree_num;
@property (nonatomic, assign) NSInteger share_num;
@property (nonatomic, assign) NSInteger post_num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat thumbnail_width;
@property (nonatomic, assign) CGFloat thumbnail_height;
@property (nonatomic, assign) CGFloat video_duration;
@property (nonatomic, assign) CGFloat video_width;
@property (nonatomic, assign) CGFloat video_height;
@property (nonatomic, copy) NSString *thumbnail_url;
@property (nonatomic, copy) NSString *video_url;
@end

NS_ASSUME_NONNULL_END
