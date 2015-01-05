//
//  BeforeYesterdayViewController.h
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCell.h"

#import "HttpDownload.h"


@interface BeforeYesterdayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,HttpdownloadDelegate>
@property (nonatomic,retain) UITableView *tbBeforeYesterday;

@property (nonatomic,retain) InfoCell *currentInfoCell;


//- data

@property (nonatomic,retain) NSMutableArray *infoArr;
@property (nonatomic,retain) NSMutableDictionary *infoDic;

//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;
@property (nonatomic,assign) NSInteger requestType;
@property (nonatomic,assign) NSInteger nextPage;

@property (nonatomic,retain) UIImageView *imgvwNoInfo;
@end
