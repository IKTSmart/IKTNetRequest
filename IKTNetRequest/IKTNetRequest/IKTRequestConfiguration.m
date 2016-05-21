//
//  IKTRequestConfiguration.m
//  IKTNetRequest
//
//  Created by IKT on 16/3/16.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import "IKTRequestConfiguration.h"
#import "IKTRequestHelper.h"

@implementation IKTRequestConfiguration

- (NSMutableURLRequest *)CreatRequestWithUrl:(NSString *)urlString Method:(IKTRequestMethod)method Parameters:(NSDictionary *)parameters Data:(NSData *)data{
    NSParameterAssert(urlString);
    switch (method) {
        case GET:
            return [self praviteCreatGetRequest:urlString Parameters:parameters];
        case POST:
            return [self praviteCreatPostRequest:urlString Parameters:parameters];
        case UPLOAD :
            return [self praviteCreatUploadRequest:urlString Parameters:parameters Data:data];
    }
    return nil;
}

- (NSMutableURLRequest *)praviteCreatGetRequest:(NSString *)urlString Parameters:(NSDictionary *)parameters{
    NSString *separateChar = [urlString containsString:@"?"] ? @"&" : @"?";
    NSString *parameterString = parameters != nil ? [IKTRequestHelper returnStringFromDictionary:parameters] : @"";
    NSString *totalString = parameterString.length>0 ? [NSString stringWithFormat:@"%@%@%@",urlString,separateChar,parameterString] :urlString;
    NSString *utfTotalStr = [totalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [self PublicAddHeadsWith:utfTotalStr];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)praviteCreatPostRequest:(NSString *)urlString Parameters:(NSDictionary *)parameters{
    NSMutableURLRequest *request = [self PublicAddHeadsWith:urlString];
    NSString *postString = parameters != nil ? [IKTRequestHelper returnStringFromDictionary:parameters] : @"";
    NSString *utfTotalStr = [postString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *postData = [utfTotalStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    return request;
    
}

- (NSMutableURLRequest *)praviteCreatUploadRequest:(NSString *)urlString Parameters:(NSDictionary *)parameters Data:(NSData *)data{
    NSMutableURLRequest *request = [self PublicAddHeadsWith:urlString];
    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",self.boundary];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = self.timeOut;
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    return request;
}

- (NSMutableURLRequest *)PublicAddHeadsWith:(NSString *)urlString{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut];
    if (self.headers) {
        for (NSString *key in self.headers) {
            [request addValue:self.headers[key] forHTTPHeaderField:key];
        }
    }
    if (self.receptionFromat) {
        [request addValue:self.receptionFromat forHTTPHeaderField:@"Content-Type"];
    }
    return request;
}

#pragma IKTNetRequest Default Configuration

- (void)defaultConfiguration{
    [self setTimeOut:30.0];
    [self setReceiveDataEncoding:NSUTF8StringEncoding];
    [self setBoundary:[NSString stringWithFormat:@"IBoundary+%08X%08X",arc4random(),arc4random()]];
}

#pragma Creat Data

static NSString * const IKTRequestFormatKeyCRLF = @"\r\n";

static NSString *IKTRequestSpeaterIdentifierBoundaryMP(NSString *boundary){
    return [NSString stringWithFormat:@"--%@",boundary];
}

static NSString *IKTRequestSpeaterIdentifierBoundaryEnd(NSString *boundary){
    return [NSString stringWithFormat:@"--%@--%@",boundary,IKTRequestFormatKeyCRLF];
}

- (NSData *)creatRequestDataWithParams:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas{
    
    //http body string
    NSMutableString *body = [[NSMutableString alloc]init];
    //Parameters all keys
    NSArray *keys = [params allKeys];
    
    //get all keys
    for(int i=0;i<[keys count];i++) {
        //get current key
        NSString *key=[keys objectAtIndex:i];
        //add sepeater line, enter
        [body appendFormat:@"%@\r\n",IKTRequestSpeaterIdentifierBoundaryMP(self.boundary)];
        //add field name，enter two line
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@",key,IKTRequestFormatKeyCRLF];
        //[body appendString:@"Content-Transfer-Encoding: 8bit\r\t"];
        //[body appendFormat:@"Content-Type: applicaiton/json; charset=utf-8\r\n\r\n"];
        //add field value
        [body appendFormat:@"%@",[params objectForKey:key]];
    }
    
    // creat requestData，using it save http body
    NSMutableData *requestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //loop update file
    keys = [fileDatas allKeys];
    for(int i = 0; i< [keys count] ; i++){
        NSData* data =  [fileDatas objectForKey:[keys objectAtIndex:i]];
        NSMutableString *filebody = [[NSMutableString alloc] init];
        
        //add sepeater line, enter and file data
        [filebody appendFormat:@"%@\r\n",IKTRequestSpeaterIdentifierBoundaryMP(self.boundary)];
        [filebody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@", [keys objectAtIndex:i],[keys objectAtIndex:i],IKTRequestFormatKeyCRLF];
        // file type
        [filebody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8%@",IKTRequestFormatKeyCRLF];
        //append filebody
        [requestData appendData:[filebody dataUsingEncoding:NSUTF8StringEncoding]];
        //add file dada
        [requestData appendData:data];
        [requestData appendData:[IKTRequestFormatKeyCRLF dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //add end identifier
    [requestData appendData:[IKTRequestSpeaterIdentifierBoundaryEnd(self.boundary) dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSData dataWithData:requestData];
}

@end
