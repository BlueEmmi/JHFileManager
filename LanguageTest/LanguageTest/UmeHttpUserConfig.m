//
//  UmeHttpUserConfig.m
//  UmeChat
//
//  Created by 江道洪 on 2022/5/19.
//  Copyright © 2022 UmeChat. All rights reserved.
//

#import "UmeHttpUserConfig.h"
#import <YYKit/YYKit.h>

NSString *const kUmeHttpUserConfigKey = @"__config";

@interface UmeHttpUserConfig ()

@property (nonatomic, assign, getter=isThirdAPI, readwrite) BOOL thirdAPI;

@end

@implementation UmeHttpUserConfig

- (instancetype)init {
    if (self = [super init]) {
        _thirdAPI = NO;
        _decrypt = YES;
        _encrypt = YES;
        _sign = YES;
        _token = YES;
        _showToast = YES;
        _invalidCodes = @[@"2001006", @"1000116"];
    }
    return self;
}

/// 默认的配置, 无参数, 加密, 解密, sign, token 弹窗都有
+ (instancetype)config {
    return [UmeHttpUserConfig new];
}

+ (instancetype)thirdConfig {
    UmeHttpUserConfig *a = [UmeHttpUserConfig new];
    a.decrypt = NO;
    a.encrypt = NO;
    a.sign = NO;
    a.thirdAPI = YES;
    return a;
}

+ (instancetype)parser:(id)json {
    
    UmeHttpUserConfig *c = [UmeHttpUserConfig modelWithJSON:[json objectForKey:kUmeHttpUserConfigKey]];
    
    if (!c) {
        return [UmeHttpUserConfig config];
    }
    return c;
}

@end
