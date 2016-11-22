//
//  ViewController.m
//  IKTNetRequest
//
//  Created by IKT on 16/2/25.
//  Copyright © 2016年 www.tuanmob.com. All rights reserved.
//

#import "ViewController.h"
#import "IKTNetHeader.h"
#import "IKTRequestConfiguration.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //下载
//    NSString *url = @"imageurl";
//    [[IKTNetRequest manage] downloadFileFromUrl:url Success:^(id responseObject) {
//        [self setMyImage:responseObject[IKTDownloadFileData]];
//    } Failed:^(NSError *error) {
//        NSLog(@"faild");
//    } Progress:^(NSNumber *progress) {
//        NSLog(@"%f",[progress floatValue]);
//    }];
//    
//    //上传
//    NSString *uploadUrl = @"uploadImageUrl";
//    UIImage *image = [UIImage imageNamed:@"myImage"];
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image":data}];
//    [[IKTNetRequest manage] uploadFileToServerUrl:uploadUrl Params:nil FileDatas:dict Success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } Failed:^(NSError *error) {
//        NSLog(@"faild");
//    }];
    
    IKTNetRequest *manager = [IKTNetRequest manage];
    manager.config.httpsVerification = YES;
    //GET
    NSString *getUrl = @"https://download.uc848.com";
    [manager getDataFromInternetUrl:getUrl Parameters:nil Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"err:%@",error);
    }];

    //POST
    /*
     设置请求头
     IKTNetRequest *manage = [IKTNetRequest manage];
     manage.config.headers = @{@"iktkey":@"value"};
     */
//    NSString *postUrl = @"http://127.0.0.1:8881/userLogin";
//    [[IKTNetRequest manage] postDataFromInternetUrl:postUrl Parameters:@{@"userName":@"admin",@"passWord":@"admin"} Success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } Failed:^(NSError *error) {
//        NSLog(@"faild");
//    }];
}

- (void)setMyImage:(NSData *)imageData{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image = [[UIImage alloc] initWithData:imageData];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
