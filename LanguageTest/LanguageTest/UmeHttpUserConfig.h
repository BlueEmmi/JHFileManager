//
//  UmeHttpUserConfig.h
//  UmeChat
//
//  Created by 江道洪 on 2022/5/19.
//  Copyright © 2022 UmeChat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kUmeHttpUserConfigKey;

@interface UmeHttpUserConfig : NSObject

/// 加密
@property (nonatomic, assign) BOOL decrypt;
/// 解密
@property (nonatomic, assign) BOOL encrypt;
/// 签名
@property (nonatomic, assign) BOOL sign;
/// 加token
@property (nonatomic, assign) BOOL token;
/// 弹窗
@property (nonatomic, assign) BOOL showToast;
/// 自定义请求信息
@property (nonatomic, strong) NSDictionary *extHeader;

@property (nonatomic, assign, getter=isThirdAPI, readonly) BOOL thirdAPI;
/// 不弹窗的错误码
@property (strong, nonatomic) NSArray<NSString *> *invalidCodes;

/// 普通请求构造配置, 不用也行, 解析出来就是默认
+ (instancetype)config;
/// 三方请求构造配置
+ (instancetype)thirdConfig;

+ (instancetype)parser:(id)json;

@end

NS_ASSUME_NONNULL_END
