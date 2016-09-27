//
//  IKTRequestConfiguration.h
//  IKTNetRequest
//
//  Created by IKT on 16/3/16.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKTRequestConfiguration : NSObject

typedef NS_OPTIONS(NSUInteger, IKTRequestMethod) {
    GET = 1 << 0,
    POST = 1 << 1,
    UPLOAD = 1 << 2,
};

/*
 * The default request header
 */
@property (nonatomic, strong) NSDictionary *headers;

/*
 * Data request timeout
 */
@property (nonatomic, assign) float timeOut;

/*
 * Data boundary segmentation tags
 */
@property (nonatomic, copy) NSString *boundary;

/*
 * Data reception format
 */
@property (nonatomic, copy) NSString *receptionFromat;

/*
 * Request to receive data encoding format
 */
@property (nonatomic, assign) NSStringEncoding receiveDataEncoding;

/*
 * request safe https Verification protect data
 */
@property (nonatomic, assign) BOOL httpsVerification;

/*
 * request local certificate path
 */
@property (nonatomic, copy) NSString *certificatePath;

/*
 * resquest Error
 */
@property (nonatomic, strong) NSError *error;

/*
 * To obtain a configuration object
 */
- (void)defaultConfiguration;

- (NSMutableURLRequest *)CreatRequestWithUrl:(NSString *)urlString Method:(IKTRequestMethod)method Parameters:(NSDictionary *)parameters Data:(NSData *)data;

- (NSMutableURLRequest *)CreatSoapRequestWithUrl:(NSString *)url Params:(NSArray *)paramers Method:(NSString *)method Space:(NSString *)space;

- (NSData *)creatRequestDataWithParams:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas;

@end









