//
//  UmeHttpClient.h
//  UmeChat
//
//  Created by 江道洪 on 2022/4/11.
//

#import <Foundation/Foundation.h>
//#import "NSError+Ume.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN
/*
typedef NS_ENUM(NSUInteger, UmeHttpMethod) {
    UmeHttpMethodGet,
    UmeHttpMethodPost,
    UmeHttpMethodPut,
    UmeHttpMethodDelete,
    UmeHttpMethodHead,
    UmeHttpMethodPatch,
};

UIKIT_EXTERN NSString *const kUmeServerDomain;

@class UmeAPI;
*/
@interface UmeHttpClient : NSObject
/*
+ (instancetype)sharedInstance;

- (RACSignal *)request:(NSString *)path method:(UmeHttpMethod)method param:(NSDictionary *)param;

- (RACSignal *)request:(UmeAPI *)api;
*/
@end

NS_ASSUME_NONNULL_END
