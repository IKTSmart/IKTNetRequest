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

    //下载
    NSString *url = @"imageurl";
    [[IKTNetRequest manage] downloadFileFromUrl:url Success:^(id responseObject) {
        [self setMyImage:responseObject[IKTDownloadFileData]];
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    } Progress:^(NSNumber *progress) {
        NSLog(@"%f",[progress floatValue]);
    }];
    
    //上传
    NSString *uploadUrl = @"uploadImageUrl";
    UIImage *image = [UIImage imageNamed:@"MyImage"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image":data}];
    [[IKTNetRequest manage] uploadFileToServerUrl:uploadUrl Params:nil FileDatas:dict Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    }];
    
    //GET
    NSString *getUrl = @"getURL";
    [[IKTNetRequest manage] getDataFromInternetUrl:getUrl Parameters:nil Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    }];

    //POST
    /*
     设置请求头
     IKTNetRequest *manage = [IKTNetRequest manage];
     manage.config.headers = @{@"iktkey":@"value"};
     */
    NSString *postUrl = @"postUrl";
    [[IKTNetRequest manage] postDataFromInternetUrl:postUrl Parameters:@{@"userName":@"admin"} Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    }];

}

- (void)setMyImage:(NSData *)imageData{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image = [[UIImage alloc] initWithData:imageData];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
