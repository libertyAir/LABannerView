//
//  LABannerView.m
//  LABannerView
//
//  Created by libertyAir on 2017/3/8.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import "LABannerView.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation BannerImageModel

- (instancetype)init{
    if (self = [super init]) {
        // init
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end




@interface LABannerView ()<UIScrollViewDelegate>
{
    NSMutableArray <UIImageView *>*_imageViews;
}
@property (nonatomic,strong)UIPageControl *pageControl;//系统pageControl
@property (nonatomic,strong)UIScrollView *scrollView;  //轮播scrollView
@property (nonatomic,strong)NSMutableArray *realArray; //整个图片数组(如果大于1张图片)
@property (nonatomic,strong)NSTimer *timer;            //计时器


@end

@implementation LABannerView

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray *)imageURLs{
    if (self = [super initWithFrame:frame]) {
        _imageURLArray = [NSMutableArray arrayWithArray:imageURLs];
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray *)imageURLs gotoURLs:(NSArray *)gotoURLs placeholder:(NSString *)placeholder imageDidClickBlock:(LAImageClickBlock)imageClickBlock{
    if (self = [super initWithFrame:frame]) {
        
        _imageURLArray = [NSMutableArray arrayWithArray:imageURLs];
        _imageGotoURLs = [NSMutableArray arrayWithArray:gotoURLs];
        _placeholder = placeholder;
        _imageClickBlock = imageClickBlock;
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <BannerImageModel *>*)bannerImageArray placeholder:(NSString *)placeholder imageDidClickBlock:(LAImageClickBlock)imageClickBlock{
    if (self = [super initWithFrame:frame]) {
        
        _bannerImageArray = bannerImageArray;
        _placeholder = placeholder;
        _imageClickBlock = imageClickBlock;
        
        _imageURLArray = [NSMutableArray array];
        _imageGotoURLs = [NSMutableArray array];
        for (BannerImageModel *model in bannerImageArray) {
            [_imageURLArray addObject:model.imageURL];
            [_imageGotoURLs addObject:model.imageGotoUrl];
        }
        
        [self setup];
    }
    return self;
}


- (void)initialization{
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _autoScroll = YES;
    _autoScrollTime = 3;
}

- (void)setup{
    [self initialization];
    [self createScrollView];
    [self createPageControl];
    [self createTimer];
}

#pragma mark - Create View
- (void)createScrollView{

    [self addSubview:self.scrollView];
    
    if (_imageURLArray.count >= 1) {
        self.realArray = [NSMutableArray arrayWithArray:_imageURLArray];
        if (_imageURLArray.count > 1) {//如果大于1张
            [self configRealArray]; //设置3倍数组
        }
        
        [self createEveryImageView];
        
    }else{
        NSLog(@"please set imageNamesArray");
    }
}

- (void)createEveryImageView{
    _imageViews = [NSMutableArray array];
    
    for (int i = 0; i < _realArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_realArray[i]] placeholderImage:[UIImage imageNamed:_placeholder]];
        imageView.frame = CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height);
        [_scrollView addSubview:imageView];
        [_imageViews addObject:imageView];
        
        //添加点击图片的手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
       
    }
}

- (void)createPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(_scrollView.width-_imageURLArray.count*18, _scrollView.height-30, _imageURLArray.count*18, 30)]; //18是自己写的 根据pageControl个数写宽度    30高度也是自己写的
    pageControl.x += _pageControlRightOffset;
    pageControl.y += _pageControlBottomOffset;
    pageControl.numberOfPages = _imageURLArray.count;
    pageControl.currentPage = 0;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}


- (void)createText:(NSString *)text inImageView:(UIImageView *)imageView{
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.height-30, imageView.width, 30)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.4;
    [imageView addSubview:maskView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.height-30, imageView.width, 30)];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.text = text;
    textLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:textLabel];
}

- (void)createTimer{
    if (_autoScroll && self.realArray.count > 1) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:_autoScrollTime target:self selector:@selector(timerRun:) userInfo:self repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//          [timer fire]; //立即开始执行,跳过初次Interval

        self.timer = timer;
    }
}

- (void)configRealArray{
    //采用 3倍array 的形式轮播
    [_realArray insertObjects:_imageURLArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _imageURLArray.count)]];
    [_realArray addObjectsFromArray:self.imageURLArray];
    
    //需要设置contentsize和contentOffset  此时不是从0开始了
    _scrollView.contentOffset = CGPointMake(_scrollView.width*_imageURLArray.count, 0);
    _scrollView.contentSize = CGSizeMake(_realArray.count*self.width, self.height);
}



#pragma mark - private
- (void)updateViews{
    _realArray = [NSMutableArray array];
    
    //remove old
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    _scrollView = nil;
    
    [_timer invalidate];
    _timer = nil;
    
    
    //add new
    [self createScrollView];
    [self createPageControl];
    [self createTimer];
}

- (void)updateDesViews{
    
}

#pragma mark - NSTimer
- (void)timerRun:(NSTimer *)timer
{
    //计算下一张
    NSInteger nextPage = self.pageControl.currentPage + 1;
    //模拟手势滑下一张
    CGFloat itemsWide = 3.0f;
    CGFloat scrollWidth = _scrollView.contentSize.width / itemsWide;
    [self.scrollView setContentOffset:CGPointMake(scrollWidth + nextPage*scrollWidth/_imageURLArray.count, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //用户滑动页面时 定时器暂停
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //用户滑动页面结束后 定时器继续
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_autoScrollTime]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat itemsWide = 3.0f;
    CGFloat scrollWidth = _scrollView.contentSize.width / itemsWide;
    
    if (scrollView.contentOffset.x >= scrollWidth * 2.0f) {
        CGPoint contentOffset = CGPointMake(_scrollView.contentOffset.x - scrollWidth, 0.0f);
        _scrollView.contentOffset = contentOffset;
    }

    if (scrollView.contentOffset.x < scrollWidth) {
        CGPoint contentOffset = CGPointMake(_scrollView.contentOffset.x + scrollWidth, 0.0f);
        _scrollView.contentOffset = contentOffset;
    }
    
    //-scrollWidth是为了减去开头那一段,相当于offset.x从0开始   %count是滑动到第三段的时候变成0
    int page = (int)(((scrollView.contentOffset.x - scrollWidth)/scrollView.width)+0.5) % _imageURLArray.count;
    self.pageControl.currentPage = page;
    
}

#pragma mark - tapImage
- (void)tapImage{
    NSInteger index = self.pageControl.currentPage;
    
    if (self.imageClickBlock) {
        @try {
            self.imageClickBlock(index,_imageGotoURLs[index]);
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    }
}

#pragma mark - Setter
- (void)setImageURLArray:(NSMutableArray<NSString *> *)imageURLArray{
    
    _imageURLArray = [NSMutableArray arrayWithArray:imageURLArray];
    
    [self updateViews];
}


- (void)setImageGotoURLs:(NSMutableArray<NSString *> *)imageGotoURLs{
    _imageGotoURLs = [NSMutableArray arrayWithArray:imageGotoURLs];
}

- (void)setBannerImageArray:(NSArray<BannerImageModel *> *)bannerImageArray{
    _bannerImageArray = bannerImageArray;
    
    _imageURLArray = [NSMutableArray array];
    _imageGotoURLs = [NSMutableArray array];
    for (BannerImageModel *model in bannerImageArray) {
        [_imageURLArray addObject:model.imageURL];
        [_imageGotoURLs addObject:model.imageGotoUrl];
    }
    
    [self updateViews];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    if(autoScroll){
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_autoScrollTime]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)setAutoScrollTime:(NSInteger)autoScrollTime{
    _autoScrollTime = autoScrollTime;
    
    //NSTimer无法动态修改时间间隔，如果我们想要增加或减少NSTimer的时间间隔。只能invalidate之前的NSTimer，再重新生成一个NSTimer设定新的时间间隔。
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:_autoScrollTime target:self selector:@selector(timerRun:) userInfo:self repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //重设了时间,但是并未设置自动滚动,还是要将timer暂停
    if(!_autoScroll) [_timer setFireDate:[NSDate distantFuture]];
}

- (void)setPageControlRightOffset:(CGFloat)pageControlRightOffset{
    _pageControlRightOffset = pageControlRightOffset;
    
    _pageControl.x += pageControlRightOffset;
}

- (void)setPageControlBottomOffset:(CGFloat)pageControlBottomOffset{
    _pageControlBottomOffset = pageControlBottomOffset;
    
    _pageControl.y += pageControlBottomOffset;
}



#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end


