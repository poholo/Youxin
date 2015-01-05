//
//  WIAllViewController.h
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDGraphScrollView.h"
#import "FDGraphView.h"
#import "HttpDownload.h"

#define SHOW_TYPE_DAY 0
#define SHOW_TYPE_WEEK 1
#define SHOW_TYPE_MONTH 2

@interface WIAllViewController : UIViewController<HttpdownloadDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) UILabel *lbTime;
@property (nonatomic,retain) UILabel *lbYXTitle;
@property (nonatomic,retain) UILabel *lbYXSum;
@property (nonatomic,retain) UIScrollView *scrollview;


@property (nonatomic,retain) FDGraphView *fdgcYXDis;
@property (nonatomic,retain) NSMutableArray *xlbArr;
@property (nonatomic,retain) NSMutableArray *ylbArr;

//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;

//data
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) int yxSum;
@property (nonatomic,assign) int showType;
@property (nonatomic,retain) NSDate *usedate;

@property (nonatomic,retain) NSMutableArray *currentShowData;
@property (nonatomic,retain) NSMutableArray *xArr;
@property (nonatomic,retain) NSMutableArray *yArr;


@property (nonatomic,assign) int fromYear;
@property (nonatomic,assign) int fromMonth;
@property (nonatomic,assign) int fromDay;


@property (nonatomic,assign) int nowYear;
@property (nonatomic,assign) int nowMonth;
@property (nonatomic,assign) int nowDay;

@property (nonatomic,assign) int maxY;
@end
