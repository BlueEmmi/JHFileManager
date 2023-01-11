//
//  VideoTableViewCell.h
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) VideoModel *model;

@end

NS_ASSUME_NONNULL_END
