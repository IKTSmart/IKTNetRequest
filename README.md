# IKTNetRequest
Object-C网络请求框架

> 简单快速的Object-C网络请求框架。
> 支持GET、POST、上传、下载。

 

### 示例
``` objectivec
    //下载
	NSString *url = @"imageurl";
	[[IKTNetRequest manage] downloadFileFromUrl:url Success:^(id responseObject) {
	//请求成功
    } Failed:^(NSError *error) {
    //请求失败
    } Progress:^(NSNumber *progress) {
    //请求进度
    NSLog(@"%f",[progress floatValue]);
    }];
    
    //上传
    NSString *uploadUrl = @"uploadImageUrl";
    UIImage *image = [UIImage imageNamed:@"myImage"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image":data}];
    [[IKTNetRequest manage] uploadFileToServerUrl:uploadUrl Params:nil FileDatas:dict Success:^(id responseObject) {
	//上传成功
    } Failed:^(NSError *error) {
	//上传失败
    }];
    
    //GET
    NSString *getUrl = @"getURL";
    [[IKTNetRequest manage] getDataFromInternetUrl:getUrl Parameters:nil Success:^(id responseObject) {
	//请求成功
    } Failed:^(NSError *error) {
	//请求失败
    }];

    //POST
    /*
     设置请求头
     IKTNetRequest *manage = [IKTNetRequest manage];
     manage.config.headers = @{@"iktkey":@"value"};
     */
    NSString *postUrl = @"postUrl";
    [[IKTNetRequest manage] postDataFromInternetUrl:postUrl Parameters:@{@"userName":@"admin"} Success:^(id responseObject) {
	//请求成功
    } Failed:^(NSError *error) {
	//请求失败
    }];
```


## 反馈与建议
- 微信：[IKTDev]()
- 邮箱：<5786117@qq.com>

---------
如遇到BUG或功能不够用，希望你能与我联系。
