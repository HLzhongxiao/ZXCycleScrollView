ZXCycleScrollView
=================

[![iOS](https://img.shields.io/badge/iOS-ZXCycleScrollView-brightgreen.svg)](https://github.com/HLzhongxiao)
[![Language](https://img.shields.io/badge/Language-Objective--C-brightgreen.svg)](https://github.com/HLzhongxiao)

Very convenient carousel picture display mode

> **Now ZXCycleScrollView was updated version to 1.X , If you have any question or suggestion , welcome to 
tell me !**

## introduction

ZXCycleScrollView is a more convenient control, and its use is similar to the UITableView loading data mode, picture resources loaded easier to compare, do not need to do too many operations.

## Demo
![DeoGif](Resources/DeoGif.gif)

## Usage

#### Initialization ZXCycleScrollView

```Objective-C

ZXCycleScrollView *scrollView = [[ZXCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
scrollView.zxcycleDelegate = self;
scrollView.zxcycleDataSource = self;
[self.view addSubview:scrollView];

```

#### ZXCycleScrollViewDataSource

```Objective-C

// Gets the number of image resources
- (NSInteger)numberOfIndexInZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView;

// Get picture resources
- (ZXCycleModel *)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView provideCycleModel:(ZXCycleModel *)cycleModel zxcycleModelForIndex:(NSInteger)index;

```

#### ZXCycleScrollViewDelegate

```Objective-C

// Click the event triggered by the picture
- (void)ZXCycleScrollView:(ZXCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index andSelectModel:(ZXCycleModel *)cycleModel;

```

