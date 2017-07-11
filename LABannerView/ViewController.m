//
//  ViewController.m
//  LABannerView
//
//  Created by libertyAir on 2017/7/11.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import "ViewController.h"
#import "LABannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}



- (void)setupView{
    //rootView
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollview];
    
    //第一种方式
    LABannerView *bannerView1 = [[LABannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16) imageURLs:[self urls]];
    [scrollview addSubview:bannerView1];
    
    //第二种方式
    LABannerView *bannerView2 = [[LABannerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView1.frame)+40, self.view.frame.size.width, self.view.frame.size.width*9/16) imageURLs:[self urls] gotoURLs:[self gotoURLs] placeholder:@"ppp.jpg" imageDidClickBlock:^(NSInteger selectedIndex, NSString *imgURL) {
        NSLog(@"%ld,%@",selectedIndex,imgURL);
    }];
    [scrollview addSubview:bannerView2];

    

    
    //第三种方式
    BannerImageModel *model1 = [[BannerImageModel alloc]init];
    model1.imageGotoUrl = @"http://www.baidu.com";
    model1.imageURL = @"http://img.zcool.cn/community/05e5e1554af04100000115a8236351.jpg";
    
    BannerImageModel *model2 = [[BannerImageModel alloc]init];
    model2.imageGotoUrl = @"http://www.baidu.com";
    model2.imageURL = @"http://www.ccarting.com/img/opus/photograph/h000/h41/img201008181910520.jpg";
    
    BannerImageModel *model3 = [[BannerImageModel alloc]init];
    model3.imageGotoUrl = @"http://www.baidu.com";
    model3.imageURL = @"http://img.sj33.cn/uploads/allimg/201302/1-130201105055.jpg";
    
    BannerImageModel *model4 = [[BannerImageModel alloc]init];
    model4.imageGotoUrl = @"http://www.baidu.com";
    model4.imageURL = @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646706_1456498430419_800x600.jpg";
    
    BannerImageModel *model5 = [[BannerImageModel alloc]init];
    model5.imageGotoUrl = @"http://www.baidu.com";
    model5.imageURL = @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646722_1456498424671_800x600.jpg";
    
    NSArray *array = @[model1,model2];
    __block LABannerView *bannerView3 = [[LABannerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView2.frame)+40, self.view.frame.size.width, self.view.frame.size.width*9/16) withModels:array placeholder:@"ppp.jpg" imageDidClickBlock:^(NSInteger selectedIndex, NSString *imgURL) {
        NSLog(@"%@",imgURL);
    }];
    [scrollview addSubview:bannerView3];
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(bannerView3.frame)+64);
    
    
    
    
    
    
    
    //模拟网络请求后换轮播图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array2 = @[model1,model2,model3,model4,model5];
        bannerView3.bannerImageArray = array2;
    });
}



- (NSArray *)urls{
    return @[@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646722_1456498424671_800x600.jpg",@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646649_1456498410838_800x600.jpg",@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646706_1456498430419_800x600.jpg",@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646723_1456498427059_800x600.jpg"];
}

- (NSArray *)urls2{
    return @[@"http://img.sj33.cn/uploads/allimg/201302/1-130201105055.jpg",@"http://www.ccarting.com/img/opus/photograph/h000/h41/img201008181910520.jpg",@"http://img.zcool.cn/community/05e5e1554af04100000115a8236351.jpg"];
}
- (NSArray *)imageDes{
    return @[@"第一张",@"第二张",@"第三张",@"第四张"];
}
- (NSArray *)gotoURLs{
    return @[@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com"];
}

@end
