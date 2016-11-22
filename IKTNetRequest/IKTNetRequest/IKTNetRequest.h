//
//  IKTNetRequest.h
//  IKTNetRequest
//
//  Created by IKT on 16/2/25.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKTRequestConfiguration.h"

typedef void (^requestDataFinish) (id responseObject);
typedef void (^requestDataError) (NSError *error);
typedef void (^requestDataProgress) (NSNumber *progress);

@interface IKTNetRequest : NSObject

@property (nonatomic, strong) IKTRequestConfiguration *config;

/*
 * Get Object 获取对象
 */
+ (IKTNetRequest *)manage;

/*
 * GET Request  GET请求
 * @params
 * @ urlString      请求地址
 * @ params         请求参数
 * @ Success        访问成功的回调
 * @ Failed         访问失败的回调
 */
- (void)getDataFromInternetUrl:(NSString *)urlString Parameters:(NSDictionary*)params Success:(requestDataFinish)finish Failed:(requestDataError)error;

/*
 * POST Request POST请求
 * @params
 * @ urlString      请求地址
 * @ params         请求参数
 * @ Success        访问成功的回调
 * @ Failed         访问失败的回调
 */
- (void)postDataFromInternetUrl:(NSString *)urlString Parameters:(NSDictionary*)dic Success:(requestDataFinish)finish Failed:(requestDataError)error;

/*
 * SOAP Request SOAP请求
 * @params
 * @ urlString      请求地址
 * @ soapParameters 请求参数
 * @ soapMethod     method参数
 * @ soapSpace      space参数
 * @ Success        访问成功的回调
 * @ Failed         访问失败的回调
 */
- (void)soapDataFromInternetUrl:(NSString *)urlString SoapParameters:(NSMutableArray*)soapParameters SoapMethod:(NSString *)soapMethod SoapSpace:(NSString *)soapSpace Success:(requestDataFinish)finish Failed:(requestDataError)error;

/*
 * Downlown File 文件下载
 * @params
 * @ urlString      下载链接
 * @ Success        下载成功的回调
 * @ Failed         下载失败的回调
 */
- (void)downloadFileFromUrl:(NSString *)urlString Success:(requestDataFinish)finish Failed:(requestDataError)error;

/*
 * Downlown File 文件下载 需要下载进度
 * @params
 * @ urlString      下载链接
 * @ Success        下载成功的回调
 * @ Failed         下载失败的回调
 * @ Progress       下载进度回调
 */
- (void)downloadFileFromUrl:(NSString *)urlString Success:(requestDataFinish)finish Failed:(requestDataError)error Progress:(requestDataProgress)progress;

/*
 * Upload file 文件上传
 * @params
 * @ urlString       文件上传地址
 * @ params          上传的参数
 * @ fileDatas       上传的文件
 * @ Success         上传成功的回调
 * @ Failed          上传失败的回调
 */
- (void)uploadFileToServerUrl:(NSString *)urlString Params:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas Success:(requestDataFinish)finish Failed:(requestDataError)error;
/*
 * Upload file 文件上传
 * @params
 * @ urlString      文件上传地址
 * @ params         上传的参数
 * @ fileDatas      上传的文件
 * @ Success        上传成功的回调
 * @ Failed         上传失败的回调
 * @ progress       上传的进度
 */
- (void)uploadFileToServerUrl:(NSString *)urlString Params:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas Success:(requestDataFinish)finish Failed:(requestDataError)error Progress:(requestDataProgress)progress;

@end

