//
//  CarTypeAllViewController.h
//  youxin
//
//  Created by fei on 13-9-13.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface CarTypeAllViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) XYPieChart *pieChartRight;
@property (strong, nonatomic) XYPieChart *pieChartLeft;
@property (strong, nonatomic) UILabel *percentageLabel;
@property (strong, nonatomic) UILabel *selectedSliceLabel;
@property (strong, nonatomic) UITextField *numOfSlices;
@property (strong, nonatomic) UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;


@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,retain) UIButton *btnAsert;

@property (nonatomic,assign) BOOL isSort;


@end
