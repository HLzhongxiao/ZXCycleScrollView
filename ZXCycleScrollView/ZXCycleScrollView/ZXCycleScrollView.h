//
//  ZXCycleScrollView.h
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/23.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCycleModel : NSObject

/**
 图片标题
 */
@property (nonatomic,copy)NSString *titleStr;

/**
 图片url地址
 */
@property (nonatomic,copy)NSString *imageUrl;

/**
 点击链接地址
 */
@property (nonatomic,copy)NSString *linkUrl;

/**
 点击id
 */
@property (nonatomic,copy)NSString *idStr;

@end

@class ZXCycleScrollView;

@protocol ZXCycleScrollViewDelegate <NSObject>

@optional
- (void)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index andSelectModel:(ZXCycleModel *)cycleModel;

@end

@protocol ZXCycleScrollViewDataSource <NSObject>

@required

- (NSInteger)numberOfIndexInZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView;

- (ZXCycleModel *)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView provideCycleModel:(ZXCycleModel *)cycleModel zxcycleModelForIndex:(NSInteger)index;

@end

@interface ZXCycleScrollView : UIView

@property (nonatomic,weak)id<ZXCycleScrollViewDelegate> zxcycleDelegate;
@property (nonatomic,weak)id<ZXCycleScrollViewDataSource> zxcycleDataSource;

- (void)reloadCycleData;

@end


