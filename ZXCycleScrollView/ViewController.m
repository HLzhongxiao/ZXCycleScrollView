//
//  ViewController.m
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/6/14.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import "ViewController.h"
#import "ZXCycleScrollView.h"

@interface ViewController ()<ZXCycleScrollViewDelegate,ZXCycleScrollViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ViewController

- (NSMutableArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr = [NSMutableArray arrayWithObjects:@"https://raw.githubusercontent.com/HLzhongxiao/ZXCycleScrollView/master/Resources/apic14052.jpg", @"https://raw.githubusercontent.com/HLzhongxiao/ZXCycleScrollView/master/Resources/apic3188.jpg", @"https://raw.githubusercontent.com/HLzhongxiao/ZXCycleScrollView/master/Resources/e_bw.jpg", nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZXCycleScrollView *scrollView = [[ZXCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    scrollView.zxcycleDelegate = self;
    scrollView.zxcycleDataSource = self;
    [self.view addSubview:scrollView];

}

#pragma mark - ZXCycleScrollViewDataSource
- (NSInteger)numberOfIndexInZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView
{
    return self.dataArr.count;
}

- (ZXCycleModel *)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView provideCycleModel:(ZXCycleModel *)cycleModel zxcycleModelForIndex:(NSInteger)index
{
    cycleModel.imageUrl = self.dataArr[index];
    cycleModel.titleStr = [NSString stringWithFormat:@"%d爱自由！！！",arc4random_uniform(100)];
    cycleModel.idStr = @"";
    cycleModel.linkUrl = @"123";
    
    return cycleModel;
}

#pragma mark - ZXCycleScrollViewDelegate
- (void)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index andSelectModel:(ZXCycleModel *)cycleModel
{
    NSLog(@"index:%zd----imageUrl:%@",index,cycleModel.imageUrl);
}


@end
