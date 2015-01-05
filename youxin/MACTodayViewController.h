//
//  MACTodayViewController.h
//  youxin
//
//  Created by fei on 13-9-12.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManInfoCell.h"
#import "HttpDownload.h"

@interface MACTodayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,HttpdownloadDelegate>
@property (nonatomic,retain) UITableView *tbToday;
@property (nonatomic,retain) ManInfoCell *currentInfoCell;
@property (nonatomic,retain) NSIndexPath *currentIndexpath;


//- data

@property (nonatomic,retain) NSMutableArray *infoArr;
@property (nonatomic,retain) NSMutableDictionary *infoDic;

//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;

@property (nonatomic,assign) NSInteger nextPage;
@property (nonatomic,assign) NSInteger requestType;
@property (nonatomic,retain) UIImageView *imgvwNoInfo;
@end
