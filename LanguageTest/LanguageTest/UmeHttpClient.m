//
//  UmeHttpClient.m
//  UmeChat
//
//  Created by 江道洪 on 2022/4/11.
//

#import "UmeHttpClient.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonCryptor.h>
#import <YYKit/YYKit.h>
#import "UmeHttpUserConfig.h"

NSString *const kUmeServerDomain = @"com.ume.http.error";

@interface UmeHttpResponse : NSObject
/// 业务状态码, 200才正常
@property (nonatomic, assign) NSInteger ume_Code;

/// error
@property (nonatomic, assign) BOOL ume_HasError;
@property (nonatomic, assign) NSInteger ume_ErrorCode;
@property (nonatomic, copy) NSString *ume_ErrorMsg;

/// response timestamp
@property (nonatomic, copy) NSString *ume_Timestamp;

/// success, 有可能是 Model, 也可能是 NSArray<Model>, 还可能是ListRes
@property (nonatomic, strong) id ume_Result;
@property (nonatomic, strong) NSDictionary *ume_Ext;

@end

@implementation UmeHttpResponse

@end

@interface UmeHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation UmeHttpClient
/*
+ (instancetype)sharedInstance {
    static UmeHttpClient *client = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        client = [[UmeHttpClient alloc] init];
    });
    return client;
}

- (instancetype)init {
    if (self = [super init]) {
        
        [[NSURLCache sharedURLCache] setMemoryCapacity: 100 * 1024 * 1024];
        
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:cfg];
        
        AFHTTPRequestSerializer<AFURLRequestSerialization> *requsetSerizlizer = [AFHTTPRequestSerializer serializer];
        
        requsetSerizlizer.timeoutInterval = 10;
        requsetSerizlizer.stringEncoding = NSUTF8StringEncoding;
        
        [requsetSerizlizer setQueryStringSerializationWithBlock:^NSString * _Nullable(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError *__autoreleasing  _Nullable * _Nullable error) {
            UmeHttpUserConfig *config = [UmeHttpUserConfig parser:parameters];
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
            [param removeObjectForKey:kUmeHttpUserConfigKey];
            /// 三方API或者不需要加密, 走正常逻辑
            if (config.isThirdAPI || config.encrypt == NO) {
                return AFQueryStringFromParameters(param);
            } else {
                /// get delete head
                if ([[UmeHttpClient sharedInstance].manager.requestSerializer.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
                    /// 内部排序
                    return AFQueryStringFromParameters(param);
                } else {
                    /// post 请求需要自定义 body, 转为 nsdata, 所以直接传一个字符串就行, 内部会 NSUTF8StringEncoding
                    return [self test:[param modelToJSONString]];
                }
            }
        }];
        
        _manager.requestSerializer = requsetSerizlizer;
        
//        AFJSONResponseSerializer *json = [[AFJSONResponseSerializer alloc] init];
//        json.removesKeysWithNullValues = YES;
        
        AFHTTPResponseSerializer *responseSerizlizer = [AFHTTPResponseSerializer serializer];
        responseSerizlizer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/plain"]];
        _manager.responseSerializer = responseSerizlizer;
        
    }
    return self;
}

/// 一种方法, 自定义 requestSerializer, 重写`requestWithMethod`
/// AFHTTPRequestSerializer

/// 一种方法, 直接修改 requset

- (RACSignal *)request:(UmeAPI *)api {
    return [self request:api.API method:api.method param:api.param];
}


- (RACSignal *)request:(NSString *)path method:(UmeHttpMethod)method param:(NSDictionary *)param {
    /// 参数处理(加密, 拼接)
    /// 请求头处理
    /// 重试
    /// UI
    /// 模型转换
    /// 返回值
    /// 异常处理
    /// 统一逻辑
    ///
    NSString *methodString = @"";
    
    switch (method) {
        case UmeHttpMethodGet: {
            methodString = @"GET";
            break;
        }
        case UmeHttpMethodPut: {
            methodString = @"PUT";
            break;
        }
        case UmeHttpMethodDelete: {
            methodString = @"DELETE";
            break;
        }
        case UmeHttpMethodPost: {
            methodString = @"POST";
            break;
        }
        case UmeHttpMethodPatch: {
            methodString = @"PATCH";
            break;
        }
        case UmeHttpMethodHead: {
            methodString = @"HEAD";
            break;
        }
        default:
            break;
    }
    
    
    return
    //[
        [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        UmeHttpUserConfig *config = [UmeHttpUserConfig parser:param];
            
        /// 实际参数
        NSMutableDictionary *finalParam = [NSMutableDictionary dictionaryWithDictionary:param];
            
        [finalParam removeObjectForKey:kUmeHttpUserConfigKey];
        
        BOOL isFromThird = config.isThirdAPI;
        /// 公共请求头
        NSMutableDictionary *httpHeader = [NSMutableDictionary dictionaryWithDictionary:config.extHeader];
            
        if (isFromThird) {
            httpHeader[@"Content-Type"] = @"application/json;charset=UTF-8";
        } else {
            [httpHeader   :[UmeHttpClient defaultHttpHeader]];
            /// 防止覆盖自定义参数, 重新加入一次
            [httpHeader addEntriesFromDictionary:config.extHeader];
            if (config.encrypt) {
                httpHeader[@"need-encrypt"] = @"1";
            }
            if (config.decrypt) {
                httpHeader[@"need-decrypt"] = @"1";
            }
            if (config.sign) {
                httpHeader[@"need-sign"] = @"1";
            }
        }
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [[UmeHttpClient sharedInstance].manager.requestSerializer requestWithMethod:methodString URLString:path parameters:finalParam error:&serializationError];
            
        if (isFromThird) {
            
        } else {
            
            NSString *token = @"";
            if (config.token && [token isNotBlank]) {
                httpHeader[@"token"] = token;
            }
            
            if (config.sign) {
                NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970] * 1000];
                httpHeader[@"timestamp"] = timestamp;
                /// 需要使用传给服务器的参数
                httpHeader[@"sign"] = [self signString:method timestamp:timestamp request:request param:finalParam];
            }
            
            for (NSString *headerField in httpHeader.keyEnumerator) {
                [request setValue:httpHeader[headerField] forHTTPHeaderField:headerField];
            }
            
            if (serializationError) {
                dispatch_async([UmeHttpClient sharedInstance].manager.completionQueue ? [UmeHttpClient sharedInstance].manager.completionQueue : dispatch_get_main_queue(), ^{
                    [subscriber sendError:serializationError];
                });
                return nil;
            }
        }
        PrintDebug(@"URL: %@\n 方法:%@\n 参数:%@\n", request.URL, request.HTTPMethod, param);
        PrintDebug(@"准备请求 header : %@-------实际参数:%@", request.allHTTPHeaderFields, finalParam);
        
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [[UmeHttpClient sharedInstance].manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            NSInteger time = [[NSDate new] timeIntervalSince1970] * 1000 - [[request.allHTTPHeaderFields valueForKey:@"timestamp"] longLongValue];
            PrintDebug(@"时间 : %ld毫秒", time);
            /// http error
            if (error) {
                [subscriber sendError:error];
                NSString *string = [NSString stringWithFormat:@"api : %@ \n errorMsg:  %@", path ,[error description]];
                if (config.showToast) {
                    [UmeToast show:error.localizedDescription];
                }
                PrintError(string);
            } else {
                /// 三方, 或者接口不需要解密
                if (isFromThird || config.decrypt == NO) {
                    NSString *string = [NSString stringWithFormat:@"api : %@ \n success:  %@", path , [responseObject utf8String]];
                    PrintDebug(string);
                    [subscriber sendNext:responseObject];
                } else {
                    NSString *resString = [self aes256DecryptWithkey:[responseObject utf8String]];
                    NSString *string = [NSString stringWithFormat:@"api : %@ \n success:  %@", path , resString];
                    PrintDebug(string);
                    UmeHttpResponse *res = [UmeHttpResponse modelWithJSON:resString];
                    /// server error
                    if (res.ume_HasError) {
                        //TODO: 这里会导致重复请求
                        NSError *error = [NSError errorWithDomain:kUmeServerDomain code:res.ume_ErrorCode userInfo:@{NSLocalizedDescriptionKey : res.ume_ErrorMsg}];
                        [subscriber sendError:error];
                        if (config.showToast) {
                            /// 是否弹窗
                            if (![config.invalidCodes containsObject:@(res.ume_ErrorCode).stringValue]) {
                                [UmeToast show:error.localizedDescription];
                            }
                        }
                        /// 登出
                        if (res.ume_Code == 401 || res.ume_ErrorCode == 1000127 || res.ume_ErrorCode == 1000008) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kUmeUserShouldLogoutNotification object:nil];
                        }
                        
                    } else {
                        /// 控制返回全部, 还是只返回 Result
                        if (res.ume_Ext) {
                            /// 进行更新
                            /// 如果其他借口返回Ext, 如何防止覆盖???, 可以在参数里面进行控制
                            //                        [res.ume_Result valueForKeyPath:@"ume_UserId"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kUmeExtUpdateNotification object:res.ume_Ext];
                        }
                        
                        if (res.ume_Result) {
                            [subscriber sendNext:res.ume_Result];
                        } else {
                            [subscriber sendNext:@{}];
                        }
                    }
                }
                
                [subscriber sendCompleted];
            }
        }];
        
        [dataTask resume];
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }]
            //retry:1]
    ;
}

+ (NSDictionary *)defaultHttpHeader {
    return @{
        @"Accept-Encoding" : @"identity",
        @"Content-Type" : @"application/json;charset=UTF-8",
        @"Content-Language" : "zh_TW",
        @"content-sign": @"ume_",
        @"content-status": @"1",
    };
}

- (NSString *)signString:(UmeHttpMethod)method timestamp:(NSString *)timestamp request:(NSURLRequest *)request param:(NSDictionary *)param {
    NSMutableString *final = [NSMutableString string];
    if (method == UmeHttpMethodGet || method == UmeHttpMethodDelete || method == UmeHttpMethodHead) {
        NSString *query = request.URL.query;
        if ([query isNotBlank]) {
            [final appendString:query];
            [final appendString:@"&"];
        }
    } else {
        ///同样的方法
        NSString *jsonString = [param modelToJSONString];
        if ([jsonString isNotBlank]) {
            [final appendString:jsonString];
            [final appendString:@"&"];
        }
    }
    
    [final appendString:@"contentSign=ume_&timestamp="];
    [final appendString:timestamp];
    [final appendString:@"123456"];
    
    NSString *res = [[final sha256String] lowercaseString];
    PrintDebug(@"加密之前--------------%@", final);
    PrintDebug(@"加密结果--------------%@", res);
    
    return res;
}

#pragma mark - aa

- (NSString *)test:(NSString *)plainText {
    NSString *key = @"psd4c45gw8er7a5t";
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmAES128, //3DES
                                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                                       vkey,    //key
                                       kCCKeySizeAES128,
                                       nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSData *myData = [NSData dataWithBytes:(const char *)bufferPtr length:(NSUInteger)movedBytes];
        NSString *encode = [myData base64EncodedStringWithOptions:0];
        free(bufferPtr);
        return encode;
    }
    free(bufferPtr);
    return nil;
    
}

- (NSString *)aes256DecryptWithkey:(NSString *)plainText {
    
    NSString *keyString = @"psd4c45gw8er7a5t";
    NSData *key = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (key.length != 16 && key.length != 24 && key.length != 32) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:plainText options:0];;
    
    NSData *result = nil;
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                                          key.bytes,
                                          key.length,
                                          nil,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return [result utf8String];
    } else {
        free(buffer);
        return nil;
    }
}*/

@end
