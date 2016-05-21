//
//  IKTRequestHelper.m
//  IKTNetRequest
//
//  Created by IKT on 16/3/7.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import "IKTRequestHelper.h"

@implementation IKTRequestHelper

/*
 * 字典解析
 * Dictionary ayalysis
 */
+ (NSString*)returnStringFromDictionary:(NSDictionary*)dic{
    NSArray *keyArray = [dic allKeys];
    NSArray *valueArray = [dic allValues];
    NSString *temp = nil;
    NSString *total = @"";
    for (int i = 0; i < [keyArray count]; i++) {
        NSString *smyble = i ? @"&" : @"";
        id value = valueArray[i];
        NSString *toValue = nil;
        if ([[value class] isSubclassOfClass:[NSNumber class]]) {
            toValue = [NSString stringWithFormat:@"%zd",[value integerValue]];
        }else{
            toValue = value;
        }
        temp = [NSString stringWithFormat:@"%@%@=%@",smyble,keyArray[i],toValue];
        total = [total stringByAppendingString:temp];
    }
    return total;
}

/*
 * 数据处理
 */
+ (id)dealwithReveiceData:(NSMutableData *)data{
    NSError *error = nil;
    NSDictionary *toDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        return toDictionary;
    }else{
        NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!xmlString) {
            return data;
        }else{
            return xmlString;
        }
    }
}

@end
