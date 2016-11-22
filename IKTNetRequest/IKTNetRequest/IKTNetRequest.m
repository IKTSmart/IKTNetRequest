//
//  IKTNetRequest.m
//  IKTNetRequest
//
//  Created by IKT on 16/2/25.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import "IKTNetRequest.h"
#import "IKTRequestHelper.h"
#import "IKTRequestConfiguration.h"

NSString *const IKTDownloadFilePath = @"com.iktDownloadFilePathKey";
NSString *const IKTDownloadFileData = @"com.iktDownloadFileDataKey";

@interface IKTNetRequest ()<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>
{
    long long _totalLength;
}
@property (nonatomic, strong) __block NSMutableData *receiveData;
@property (nonatomic, copy) requestDataFinish requestFinish;
@property (nonatomic, copy) requestDataError requestError;
@property (nonatomic, copy) requestDataProgress requestProgress;
@end

@implementation IKTNetRequest

+ (IKTNetRequest *)manage{
    return [[self alloc] init];
}

#pragma mark launch request
/**
 * 发起GET
 *launch GET Request to server using Dictionary
 */
- (void)getDataFromInternetUrl:(NSString *)urlString Parameters:(NSDictionary*)params Success:(requestDataFinish)finish Failed:(requestDataError)error{
    NSMutableURLRequest *request = [self.config CreatRequestWithUrl:urlString Method:GET Parameters:params Data:nil SoapParameters:nil SoapMethod:nil SoapSpace:nil];
    NSURLSessionDataTask *task = [[self sessionUsingDefaultSessionConfiguration] dataTaskWithRequest:request];
    [self startTask:task Success:finish Failed:error];
}

/**
 * 发起POST
 * launch Request to server using Dictionary
 */
- (void)postDataFromInternetUrl:(NSString *)urlString Parameters:(NSDictionary*)params Success:(requestDataFinish)finish Failed:(requestDataError)error{
    NSMutableURLRequest *request = [self.config CreatRequestWithUrl:urlString Method:POST Parameters:params Data:nil SoapParameters:nil SoapMethod:nil SoapSpace:nil];
    NSURLSessionDataTask *task = [[self sessionUsingDefaultSessionConfiguration] dataTaskWithRequest:request];
    [self startTask:task Success:finish Failed:error];
}

/*
 * downlown file 文件下载
 * launch task download from url using Dictonary
 */
- (void)downloadFileFromUrl:(NSString *)urlString Success:(requestDataFinish)finish Failed:(requestDataError)error{
    NSURLSession *session = [self sessionUsingDefaultSessionConfiguration];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlString]];
    [self startTask:downloadTask Success:finish Failed:error];
}

- (void)downloadFileFromUrl:(NSString *)urlString Success:(requestDataFinish)finish Failed:(requestDataError)error Progress:(requestDataProgress)progress{
    self.requestProgress = progress;
    [self downloadFileFromUrl:urlString Success:finish Failed:error];
}

/*
 * upload file 文件上传
 * launch task upload to server using Dictonary and fileDatas
 */
- (void)uploadFileToServerUrl:(NSString *)urlString Params:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas Success:(requestDataFinish)finish Failed:(requestDataError)error{
    NSData *postData = [self.config creatRequestDataWithParams:params FileDatas:fileDatas];
    NSMutableURLRequest *request = [self.config CreatRequestWithUrl:urlString Method:UPLOAD Parameters:params Data:postData SoapParameters:nil SoapMethod:nil SoapSpace:nil];
    NSURLSessionUploadTask *uploadTask = [[self sessionUsingDefaultSessionConfiguration] uploadTaskWithRequest:request fromData:postData];
    [self startTask:uploadTask Success:finish Failed:error];
}

- (void)uploadFileToServerUrl:(NSString *)urlString Params:(NSDictionary *)params FileDatas:(NSDictionary *)fileDatas Success:(requestDataFinish)finish Failed:(requestDataError)error Progress:(requestDataProgress)progress{
    self.requestProgress = progress;
    [self uploadFileToServerUrl:urlString Params:params FileDatas:fileDatas Success:finish Failed:error];
}

#pragma mark NSURLSession Task Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSNumber *pregress = [NSNumber numberWithFloat:(float)totalBytesSent/(float)totalBytesExpectedToSend];
    if ([NSThread isMainThread]) {
        [self returnDownloadPregress:pregress];
    }else{
        [self performSelectorOnMainThread:@selector(returnDownloadPregress:) withObject:pregress waitUntilDone:NO];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if ([NSThread isMainThread]) {
        [self returnRequestError:error];
    }else{
        [self performSelectorOnMainThread:@selector(returnRequestError:) withObject:error waitUntilDone:NO];
    }
}

#pragma mark NSURLSession Data Delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.receiveData appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{

    if ([NSThread isMainThread]) {
        [self returnRequestData:self.receiveData];
    }else{
        [self performSelectorOnMainThread:@selector(returnRequestData:) withObject:self.receiveData waitUntilDone:NO];
    }
}

#pragma mark NSURLSession Download Delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSNumber *pregress = [NSNumber numberWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
    if ([NSThread isMainThread]) {
        [self returnDownloadPregress:pregress];
    }else{
        [self performSelectorOnMainThread:@selector(returnDownloadPregress:) withObject:pregress waitUntilDone:NO];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    if ([NSThread isMainThread]) {
        [self returnDownloadInfo:location.absoluteString];
    }else{
        [self performSelectorOnMainThread:@selector(returnDownloadInfo:) withObject:location.absoluteString waitUntilDone:NO];
    }
}

#pragma mark https Auther
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    if (self.config.httpsVerification) {
        //auther server certificate
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        NSData *cerData = self.config.certificateData;
        if (!cerData) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
            return;
        }

        SecCertificateRef localCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
        if (!localCertificate) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
            return;
        }
        NSArray *trustedCertificates = @[CFBridgingRelease(localCertificate)];
        SecTrustResultType result;
        SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)trustedCertificates);
        OSStatus status = SecTrustEvaluate(serverTrust, &result);
        if (status == errSecSuccess &&
            (result == kSecTrustResultProceed ||
             result == kSecTrustResultUnspecified)) {
                NSURLCredential *cred = [NSURLCredential credentialForTrust:serverTrust];
                [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
            }else{
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
            }
    }else{
        completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    }
}

#pragma mark Return ResponseObject
- (void)returnDownloadPregress:(NSNumber *)pregress{
    if (self.requestProgress) {
        self.requestProgress(pregress);
    }
}

- (void)returnRequestData:(NSMutableData *)data{
    if (self.requestFinish) {
        self.requestFinish([IKTRequestHelper dealwithReveiceData:data]);
    }
}

- (void)returnDownloadInfo:(NSString *)filePath{
    if (self.requestFinish) {
        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
        NSMutableDictionary *returnInfo = [NSMutableDictionary dictionary];
        [returnInfo setValue:filePath forKey:IKTDownloadFilePath];
        [returnInfo setValue:fileData forKey:IKTDownloadFileData];
        self.requestFinish(returnInfo);
    }
}

- (void)returnRequestError:(NSError *)error{
    if (self.requestError) {
        self.requestError(error);
    }
}

#pragma mark Configuration

- (IKTRequestConfiguration *)config{
    if (!_config) {
        _config = [[IKTRequestConfiguration alloc] init];
        [_config defaultConfiguration];
    }
    return _config;
}

- (NSURLSession *)sessionUsingDefaultSessionConfiguration{
    _receiveData = [NSMutableData data];
    NSURLSessionConfiguration *configurtion = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [NSURLSession sessionWithConfiguration:configurtion delegate:self delegateQueue:nil];
}

- (void)startTask:(NSURLSessionTask *)task Success:(requestDataFinish)result Failed:(requestDataError)error{
    self.requestFinish = result;
    self.requestError = error;
    [task resume];
}


@end
