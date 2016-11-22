# IKTNetRequest
Object-C网络请求框架

> 简单快速的Object-C网络请求框架。
> 支持GET、POST、SOAP、文件上传、文件下载。
> 支持HTTPS验证。
> 支持配置请求头。

 

### 示例
``` objectivec
    //下载文件
    NSString *url = @"imageurl";
    [[IKTNetRequest manage] downloadFileFromUrl:url Success:^(id responseObject) {
        [self setMyImage:responseObject[IKTDownloadFileData]];
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    } Progress:^(NSNumber *progress) {
        NSLog(@"%f",[progress floatValue]);
    }];
    
    //上传文件
    NSString *uploadUrl = @"uploadImageUrl";
    UIImage *image = [UIImage imageNamed:@"myImage"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image":data}];
    [[IKTNetRequest manage] uploadFileToServerUrl:uploadUrl Params:nil FileDatas:dict Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    }];
    
    //使用HTTPS验证(打开HTTPS验证在工程内添加.cer证书文件 自动搜索文件)
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
     配置请求头
     IKTNetRequest *manage = [IKTNetRequest manage];
     manage.config.headers = @{@"iktkey":@"value"};
     */
    NSString *postUrl = @"http://127.0.0.1:8881/userLogin";
    [[IKTNetRequest manage] postDataFromInternetUrl:postUrl Parameters:@{@"userName":@"admin",@"passWord":@"admin"} Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"faild");
    }];
    //Soap
    [[IKTNetRequest manage] soapDataFromInternetUrl:@"url" SoapParameters:[NSMutableArray array] SoapMethod:@"uc8484" SoapSpace:@"down" Success:^(id responseObject) {
        NSLog(@"%@", responseObject);
    } Failed:^(NSError *error) {
        NSLog(@"soap faild");
    }];
```


## 反馈与建议
- 邮箱：<sneakey@yeah.net>
