//
//  ZXCycleScrollView.m
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/23.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import "ZXCycleScrollView.h"
#import "NSData+ZXCommon.h"
#import "NSString+ZXCommon.h"

@interface ZXCycleScrollView()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *mainScrollView;
@property (nonatomic,weak)UIPageControl *mainPageControl;

@property (nonatomic,weak)UIImageView *currentImageView;
@property (nonatomic,weak)UIImageView *nextImageView;
@property (nonatomic,weak)UIImageView *lastImageView;

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,weak)NSTimer *timer;

@property (nonatomic,assign)NSInteger indexOfCurrentImage;

@property (nonatomic,assign)CGFloat WIDHT;
@property (nonatomic,assign)CGFloat HEIGHT;

@property (nonatomic,strong)ZXCycleModel *reusablemodel;

@end

@implementation ZXCycleScrollView

- (ZXCycleModel *)reusablemodel
{
    if(!_reusablemodel)
    {
        _reusablemodel = [[ZXCycleModel alloc] init];
    }
    return _reusablemodel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.WIDHT = self.frame.size.width;
        self.HEIGHT = self.frame.size.height;
        self.indexOfCurrentImage = 0;
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    if(!_mainScrollView){
        UIScrollView *mainScrollView = ({
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollView.contentSize = CGSizeMake(self.WIDHT * 3, self.HEIGHT);
            scrollView.delegate = self;
            scrollView.bounces = false;
            scrollView.pagingEnabled = true;
            scrollView.showsVerticalScrollIndicator = false;
            scrollView.showsHorizontalScrollIndicator = false;
            scrollView.backgroundColor = [UIColor whiteColor];
            [self addSubview:scrollView];
            scrollView;
        });
        _mainScrollView = mainScrollView;
    }
    
    if(!_currentImageView)
    {
        _currentImageView = [self addImageViewWithFrame:CGRectMake(self.WIDHT, 0, self.WIDHT, self.HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewClick)];
        [_currentImageView addGestureRecognizer:tap];
    }
    
    if(!_lastImageView)
    {
        _lastImageView = [self addImageViewWithFrame:CGRectMake(0, 0, self.WIDHT, self.HEIGHT)];
    }
    
    if(!_nextImageView)
    {
        _nextImageView = [self addImageViewWithFrame:CGRectMake(self.WIDHT*2, 0, self.WIDHT, self.HEIGHT)];
    }
    
    if(!_titleLabel)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.HEIGHT-20, self.WIDHT, 20)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    
    if(!_mainPageControl)
    {
        UIPageControl *mainPageControl = [[UIPageControl alloc] init];
        [self initPageFrame];
        mainPageControl.backgroundColor = [UIColor clearColor];
        mainPageControl.hidesForSinglePage = YES;
        [self addSubview:mainPageControl];
        _mainPageControl = mainPageControl;
    }
 
    [self initTimer];
}

// 初始化定时器
- (void)initTimer
{
    if([self numberOfIndex] > 1)
    {
        if(!_timer)
        {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            _timer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        self.mainScrollView.scrollEnabled = YES;
    }else{
        self.mainScrollView.scrollEnabled = NO;
    }
}

- (void)endTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/* 定时器 */
- (void)timerAction
{
    [self.mainScrollView setContentOffset:CGPointMake(self.WIDHT * 2, 0) animated:YES];
}

/* 初始化pageControl */
- (void)initPageFrame
{
    CGSize pageSize = [self.mainPageControl sizeForNumberOfPages:[self numberOfIndex]];
    CGFloat pageW = pageSize.width;
    CGFloat pageH = 20;
    CGFloat pageX = self.WIDHT - pageW - 5;
    CGFloat pageY = self.HEIGHT - pageH;
    self.mainPageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    self.mainPageControl.numberOfPages = [self numberOfIndex];
    [self.mainScrollView setContentOffset:CGPointMake(self.WIDHT, 0) animated:NO];
}

/* 加载图片 */
- (void)loadImageUrl:(NSString *)imageUrl andImageView:(UIImageView *)imageView
{
    NSData *data = [NSData getDataCacheWithIdentifier:imageUrl];
    if(data)
    {
        imageView.image = [UIImage imageWithData:data];
    }else{
        
        NSURL *url = [NSURL URLWithString:[imageUrl stringEncoding]];
       
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error)
            {
                UIImage *image = [UIImage imageWithData:data];
                [data saveDataCacheWithIdentifier:imageUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            }
        }];
        [task resume];
    }
}

// 上一张
- (NSInteger)getLastImageIndex:(NSInteger)index
{
    NSInteger temIndex = index - 1;
    return temIndex == -1 ? [self numberOfIndex] - 1 : temIndex;
}

// 下一张
- (NSInteger)getNextImageIndex:(NSInteger)index
{
    NSInteger temIndex = index + 1;
    return temIndex < [self numberOfIndex] ? temIndex : 0;
}

// 添加图片
- (UIImageView *)addImageViewWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:imageView];

    return imageView;
}

// 加载图片
- (void)setCycleData
{
    if([self numberOfIndex] <= 0)
    {
        return;
    }
  
    ZXCycleModel *currentModel = [self getCycleModelWithIndex:self.indexOfCurrentImage];
    NSString *currentImageUrl = [currentModel.imageUrl stringEncoding];
    
    ZXCycleModel *lastModel = [self getCycleModelWithIndex:[self getLastImageIndex:self.indexOfCurrentImage]];
    NSString *lastImageUrl = [lastModel.imageUrl stringEncoding];
    
    ZXCycleModel *nextModel = [self getCycleModelWithIndex:[self getNextImageIndex:self.indexOfCurrentImage]];
    NSString *nextImageUrl = [nextModel.imageUrl stringEncoding];
    
    [self loadImageUrl:currentImageUrl andImageView:self.currentImageView];
    [self loadImageUrl:lastImageUrl andImageView:self.lastImageView];
    [self loadImageUrl:nextImageUrl andImageView:self.nextImageView];

}

- (void)reloadCycleData
{
    [self initPageFrame];
    self.indexOfCurrentImage = 0;
    [self setCycleData];
    [self initTimer];
}

- (NSInteger)numberOfIndex
{
    if([self.zxcycleDataSource respondsToSelector:@selector(numberOfIndexInZXCycleScrollView:)])
    {
        return [self.zxcycleDataSource numberOfIndexInZXCycleScrollView:self];
    }else{
        return 0;
    }
}

- (ZXCycleModel *)getCycleModelWithIndex:(NSInteger)index
{
    
    ZXCycleModel *model = nil;
    
    if([self.zxcycleDataSource respondsToSelector:@selector(ZXCycleScrollView:provideCycleModel:zxcycleModelForIndex:)])
    {
        model = [self.zxcycleDataSource ZXCycleScrollView:self provideCycleModel:self.reusablemodel zxcycleModelForIndex:index];
    }
    
    return model;
}

// 图片点击
- (void)tapImageViewClick
{
    if([self.zxcycleDelegate respondsToSelector:@selector(ZXCycleScrollView:didSelectIndex:andSelectModel:)])
    {
        ZXCycleModel *model = [self getCycleModelWithIndex:self.indexOfCurrentImage];
        [self.zxcycleDelegate ZXCycleScrollView:self didSelectIndex:self.indexOfCurrentImage andSelectModel:model];
    }
}

- (void)setIndexOfCurrentImage:(NSInteger)indexOfCurrentImage
{
    _indexOfCurrentImage = indexOfCurrentImage;
    self.mainPageControl.currentPage = indexOfCurrentImage;
    if([self numberOfIndex] > 0)
    {
        ZXCycleModel *model = [self getCycleModelWithIndex:self.indexOfCurrentImage];
        self.titleLabel.text = [NSString stringWithFormat:@" %@",model.titleStr];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    
    if(offset == 0)
    {
        self.indexOfCurrentImage = [self getLastImageIndex:self.indexOfCurrentImage];
    }else if(offset == self.WIDHT * 2){
        self.indexOfCurrentImage = [self getNextImageIndex:self.indexOfCurrentImage];
    }
    
    [self setCycleData];
    
    [scrollView setContentOffset:CGPointMake(self.WIDHT, 0) animated:NO];
    
    [self initTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview)
    {
        [self reloadCycleData];
    }else{
        [self endTimer];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainScrollView.contentInset = UIEdgeInsetsZero;
}

@end

@interface ZXCycleModel()

@end

@implementation ZXCycleModel


@end
