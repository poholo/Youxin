//
//  CarTypeAllxibViewController.h
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "HttpDownload.h"


@interface CarTypeAllxibViewController : UIViewController<XYPieChartDataSource,XYPieChartDelegate,HttpdownloadDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) XYPieChart *pieCarAllChart;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (nonatomic,retain) UILabel *percentageLabel;



//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;

//view
@property (nonatomic,retain) UITableView *tbCarSort;
@property (nonatomic,retain) UILabel *lbTitle;
@property (nonatomic,retain) UILabel *lbCarQuerySum;
@property (nonatomic,retain) UIButton *btnSort;
@property (nonatomic,readonly) UIScrollView *src;


@property (nonatomic,retain) UIButton *btnAsert;


@property (nonatomic,retain) UILabel *lbChartTitle;
@property (nonatomic,retain) UILabel *lbChartDetail;

//data
@property (nonatomic,assign) int sum;
@property (nonatomic,retain) NSString *openDate;
@property (nonatomic,retain) NSString *currentDate;

@property (nonatomic,retain) NSMutableArray *carArr;
@property (nonatomic,assign) BOOL isSort;

@end

