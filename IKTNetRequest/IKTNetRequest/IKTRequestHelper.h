//
//  IKTRequestHelper.h
//  IKTNetRequest
//
//  Created by IKT on 16/3/7.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKTRequestHelper : NSObject

/*
 * 字典解析
 * Dictionary ayalysis
 */
+ (NSString*)returnStringFromDictionary:(NSDictionary*)dic;

/*
 * 数据处理
 */
+ (id)dealwithReveiceData:(NSMutableData *)data;


///-----------------
/// @IKTRequest KEY
///-----------------

/// @ download filepath key 文件下载地址
FOUNDATION_EXPORT NSString *const IKTDownloadFilePath;

/// @ download fileData key 文件下载文件数据
FOUNDATION_EXPORT NSString *const IKTDownloadFileData;

@end