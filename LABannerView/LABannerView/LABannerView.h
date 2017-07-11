//
//  LABannerView.h
//  LABannerView
//
//  Created by libertyAir on 2017/3/8.
//  Copyright © 2017年 libertyAir. All rights reserved.
/*
 *********************************************************************************
 * 感谢使用LABannerView无限轮播图
 * 如果您在使用的过程中遇到Bug,请联系我,我将会及时修复Bug。
 * QQ:  357624010
 * GitHub: https://github.com/libertyAir/LABannerView.git
 *
 *
 *********************************************************************************
 */


#import <UIKit/UIKit.h>

@interface BannerImageModel : NSObject

/** 图片地址*/
@property (nonatomic,strong)NSString *imageURL;
/** 图片跳转*/
@property (nonatomic,strong)NSString *imageGotoUrl;

@end



@interface LABannerView : UIView

typedef void(^LAImageClickBlock)(NSInteger selectedIndex,NSString *imgURL);

//写了两种设置方式,一种是直接传array,一种是一个图封装一个model,传一个元素是model的array
/**图片的url链接数组*/
@property (nonatomic,strong)NSMutableArray<NSString *> *imageURLArray;
/**图片点击跳转的URL*/
@property (nonatomic,strong)NSMutableArray<NSString *> *imageGotoURLs;
/**BannerImageModel*/
@property (nonatomic,strong)NSArray<BannerImageModel *> *bannerImageArray;

/**本地占位图*/
@property (nonatomic,strong)NSString *placeholder;
/**点击图片的block*/
@property (nonatomic,copy)LAImageClickBlock imageClickBlock; 

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;
/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 是否自动翻页*/
@property (nonatomic,assign)BOOL autoScroll;
/** 自动翻页时间(秒)*/
@property (nonatomic,assign)NSInteger autoScrollTime;
//这几个设置 有点问题  setter 方法改变。。


/// 基本轮播图
- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray <NSString *>*)imageURLs;

/// 完整轮播图 传数组的方式  可以选择性传nil
- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray <NSString *>*)imageURLs gotoURLs:(NSArray *)gotoURLs placeholder:(NSString *)placeholder imageDidClickBlock:(LAImageClickBlock)imageClickBlock;

/// 完整轮播图 传model的方式 可以选择性传nil
- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <BannerImageModel *>*)bannerImageArray placeholder:(NSString *)placeholder imageDidClickBlock:(LAImageClickBlock)imageClickBlock;

@end
