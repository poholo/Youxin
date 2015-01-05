

//
//  DDAllViewController.m
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "DDAllViewController.h"
#import "UIUtils.h"

#import "AlertUtils.h"
#import "DateUtils.h"
#import "ViewUtils.h"

@interface DDAllViewController ()

@end

@implementation DDAllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBasicFrame];
    [self initBasicData];
    
    
}

#pragma mark - 页面展示

-(void)initBasicFrame{
    //0.时间标题
    _lbTime = [UIUtils createDataTitleLabelWithFrame:DATA_TITLE_FRAME text:@"2013-09-29 至 2013-10-07"];
    
    CGRect rect = _lbTime.frame;
    
    //
    _lbAlltt = [UIUtils createDataTitleLabelWithFrame:CGRectMake(10,
                                                                 rect.origin.y+rect.size.height,
                                                                 100,
                                                                 30)
                                                 text:@"微信预约总量"];
    rect = _lbAlltt.frame;
    _lbAllSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(rect.origin.x,
                                                                rect.origin.y + rect.size.height,
                                                                rect.size.width,
                                                                rect.size.height) text:@"0"];
    
    _lbAddNewtt = [UIUtils createDataTitleLabelWithFrame:CGRectMake(rect.origin.x+rect.size.width,
                                                                    rect.origin.y,
                                                                    rect.size.width,
                                                                    rect.size.height) text:@"预约确认量"];
    rect = _lbAddNewtt.frame;
    
    _lbAddnewSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(rect.origin.x,
                                                                   rect.origin.y + rect.size.height,
                                                                   rect.size.width,
                                                                   rect.size.height) text:@"0"];
    
    
    _lbCanceltt = [UIUtils createDataTitleLabelWithFrame:CGRectMake(rect.origin.x + rect.size.width,
                                                                    rect.origin.y,
                                                                    rect.size.width,
                                                                    rect.size.height) text:@"预约忽略量"];
    
    rect = _lbCanceltt.frame;
    _lbCancelSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(rect.origin.x,
                                                                   rect.origin.y + rect.size.height,
                                                                   rect.size.width,
                                                                   rect.size.height) text:@"0"];
    
    //三个色块
    
    UIImageView *imgvw1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 20)];
    UIImageView *imgvw2 = [[UIImageView alloc] initWithFrame:imgvw1.bounds];
    UIImageView *imgvw3 = [[UIImageView alloc] initWithFrame:imgvw1.bounds];
    
    imgvw1.image = [UIImage imageNamed:@"cell_select"];
    imgvw2.image = [UIImage imageNamed:@"color2"];
    imgvw3.image = [UIImage imageNamed:@"color3"];
    
    
    CGPoint center = _lbAllSum.center;
    imgvw1.center = CGPointMake(center.x, center.y +30);
    
    center = _lbAddnewSum.center;
    imgvw2.center = CGPointMake(center.x, center.y+30);
    
    center = _lbCancelSum.center;
    imgvw3.center = CGPointMake(center.x, center.y+30);
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:_lbTime,_lbAlltt,_lbAddNewtt,_lbCanceltt,_lbAllSum,_lbAddnewSum,_lbCancelSum,imgvw1,imgvw2,imgvw3, nil];
    
    for(id obj in arr){
        [self.view addSubview:obj];
    }
    
    //1.折线图背景图
    UIImageView *imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebg"]];
    imgvw.frame = CGRectMake(20,170,300,220 );
    
    [self.view addSubview:imgvw];
    
    _srcvw = [[UIScrollView alloc] initWithFrame:CGRectMake(23, 198, 275/17.0f*18.0f, 200-5)];
    _srcvw.bounces = NO;
    _srcvw.showsHorizontalScrollIndicator = NO;
    _srcvw.pagingEnabled = YES;
    _srcvw.delegate = self;
    
    
    _fgvSum = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds xOffset:150.0f/4];
    _fgvCancel = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds xOffset:150.0f/4];
    _fgvNewAdd = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds xOffset:150.0f/4];
    
    _fgvCancel.backgroundColor =
    _fgvSum.backgroundColor =
    _fgvNewAdd.backgroundColor = [UIColor clearColor];
    
    _fgvSum.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    _fgvNewAdd.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color2"]];
    _fgvCancel.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color3"]];
    
    [_srcvw addSubview:_fgvSum];
    [_srcvw addSubview:_fgvCancel];
    [_srcvw addSubview:_fgvNewAdd];
    
    _srcvw.contentSize = CGSizeMake(imgvw.bounds.size.width+320, imgvw.bounds.size.height);
    _fgvSum.frame = CGRectMake(0, 0, _srcvw.contentSize.width, _srcvw.contentSize.height);
    
    [self.view addSubview:_srcvw];
    
    //data
        _fgvCancel.dataPointsXoffset = 1;
        _fgvSum.dataPoints = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _fgvNewAdd.dataPoints = @[@"10",@"60",@"50",@"40",@"20",@"10",@"30"];
        _fgvCancel.dataPoints = @[@"10",@"70",@"60",@"10",@"50",@"70",@"50"];
    
    
    //x - y
    //2.折线图 x轴 y轴标注
    _xlbArr = [[NSMutableArray alloc] initWithCapacity:8];
    
    
    _ylbArr = [[NSMutableArray alloc] initWithCapacity:7];
    for(int i=0;i<7;i++){
        UILabel *tmlb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  imgvw.frame.size.height + imgvw.frame.origin.y - i*30-15,
                                                                  23,
                                                                  10)];
        tmlb.text = [NSString stringWithFormat:@"%d9",i];
        tmlb.textAlignment =UITextAlignmentCenter;
        tmlb.textColor = [UIColor grayColor];
        tmlb.font = [UIFont systemFontOfSize:10];
        tmlb.backgroundColor = [UIColor clearColor];
        
        [self.ylbArr addObject:tmlb];
        [self.view addSubview:tmlb];
        
    }
    
    for(int i=0;i<8;i++){
        
        UILabel *tmxlb = [[UILabel alloc] initWithFrame:CGRectMake(20 + i*37,
                                                                   _srcvw.frame.size.height + _srcvw.frame.origin.y,
                                                                   30, 10)];
        tmxlb.text = [NSString stringWithFormat:@"%d1",i];
        tmxlb.textAlignment = UITextAlignmentLeft;
        tmxlb.textColor = [UIColor grayColor];
        tmxlb.backgroundColor = [UIColor clearColor];
        tmxlb.font = [UIFont systemFontOfSize:10];
        
        
        [self.xlbArr addObject:tmxlb];
        [self.view addSubview:tmxlb];
    }
    
    [self.view addSubview:[ViewUtils createDataBoard]];
    
    
}

#pragma mark - 数据初始化

-(void)initBasicData{
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"yuyue",
                      @"tag1",
                      @""];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    _xArr = [[NSMutableArray alloc] initWithCapacity:0];
    _yArr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine1Arr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine2Arr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine3Arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - httpdownloaddelegate
-(void)downloadComplete:(HttpDownload *)hd{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    
    
    if(dict==NULL){
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
    }
    else{
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];
        self.useDate = [dict objectForKey:@"useTime"];
        self.allSum = [[dict objectForKey:@"yyConfirmTotal"] intValue];
        self.cancelSum = [[dict objectForKey:@"yyTotal"] intValue];
        self.addSum = [[dict objectForKey:@"yyingoreTotal"] intValue];
        
        self.allArr = [dict objectForKey:@"dayData1"];
        self.addArr = [dict objectForKey:@"dayData2"];
        self.cancelArr = [dict objectForKey:@"dayData3"];
        
        
        _fromYear = [DateUtils getYear:self.useDate];
        _fromMonth = [DateUtils getMonth:self.useDate];
        _fromDay = [DateUtils getDay:self.useDate];
        
        
        _nowYear = [DateUtils getYear:[NSDate date]];
        _nowMonth = [DateUtils getMonth:[NSDate date]];
        _nowDay = [DateUtils getDay:[NSDate date]];
        
        
        // x  y 清空
        [_xArr removeAllObjects];
        [_yArr removeAllObjects];
        [_currentShowLine1Arr removeAllObjects];
        [_currentShowLine2Arr removeAllObjects];
        [_currentShowLine3Arr removeAllObjects];
        
        _maxYAll = [self manStartTimeAndEndTimeWithTYpe:0];
        _maxYAdd = [self manStartTimeAndEndTimeWithTYpe:1];
        _maxYCancel = [self manStartTimeAndEndTimeWithTYpe:2];

         _maxY =(_maxYAll>_maxYAdd?_maxYAll:_maxYAdd)>_maxYCancel?(_maxYAll>_maxYAdd?_maxYAll:_maxYAdd):_maxYCancel;
        
        //Y轴定量
        if(_maxY<=6){
            for(int i = 0;i<7;i++){
                [_yArr addObject:[NSNumber numberWithInt:i]];
            }
        }
        else{
            for(int i=0;i<7;i++){
                [_yArr addObject:[NSNumber numberWithInt:_maxY*i/6]];
            }
        }
        
        
        
        
        NSLog(@"X--%@",_xArr);
        NSLog(@"y--%@",_yArr);
        
        NSLog(@"line1%@",_currentShowLine1Arr);
        NSLog(@"line1%@",_currentShowLine2Arr);
        NSLog(@"line1%@",_currentShowLine3Arr);
        
        
        //框架数据刷新
        [self refreshFrameData];
    }
}

-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}
#pragma mark - 时间起始处理
-(int)manStartTimeAndEndTimeWithTYpe:(int)type{
    NSMutableArray *tmArr= nil ;
    NSArray *fromArr = nil;
    int maxY =0;
    
    [_xArr removeAllObjects];
    
    //第几条线
    switch (type) {
        case 0:
        {
            tmArr = self.currentShowLine1Arr;
            fromArr = self.allArr;
        }
            break;
        case 1:{
            tmArr = self.currentShowLine2Arr;
            fromArr = self.addArr;
        }
            break;
        case 2:{
            tmArr = self.currentShowLine3Arr;
            fromArr = self.cancelArr;
        }
            break;
        default:
            break;
    }
    
    //得到当月
    //dayData处理
    NSLog(@"%@",self.useDate);
    
    //showType判断
    maxY = 0;
    if(_fromYear==_nowYear){
        //一个月内，按天展示
        if(_fromMonth == _nowMonth){
            _showType = SHOW_TYPE_DAY;
            
            int j = _fromDay;
            for(int i=_fromDay;i<=_nowDay;i++){
                //x轴数据
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromMonth,i]];
                
                if(fromArr==NULL){
                    [tmArr addObject:[NSNumber numberWithInt:0]];
                }
                else{
                    //y
                    //得到当前y数据
                    NSDictionary *tmdic;
                    NSDate *tmDate;
                    //得到x轴数据
                    int tmMonth;
                    int tmDay;
                    
                    if(j>=_nowDay){
                        tmMonth =0;
                        tmDay = 0;
                        
                    }
                    else{
                        
                        tmdic = [fromArr objectAtIndex:j];
                        tmDate = [tmdic objectForKey:@"dayTime"];
                        //得到x轴数据
                        tmMonth = [DateUtils getMonth:tmDate];
                        tmDay = [DateUtils getDay:tmDate];
                        
                        
                    }
                    
                    if(tmMonth == _fromMonth && tmDay == i){
                        int y = [[tmdic objectForKey:@"dayTotal"] intValue];
                        [tmArr addObject:[NSNumber numberWithInt:y]];
                        maxY = maxY >y ? maxY:y;
                        
                        j++;
                        
                    }
                    else{
                        int y = 0;
                        [tmArr addObject:[NSNumber numberWithInt:y]];
                    }
                    
                }
                
            }
            
            
            
        }
        //3个月内，按周展示
        else if(_nowMonth-_fromMonth<3){
            _showType = SHOW_TYPE_WEEK;
            //计算总天数
            int splitByMonth = _nowMonth - _fromMonth;
            switch (splitByMonth) {
                case 1:
                {
                    
                    
                    //总共有多少周
                    //得到fromDay周起始日
                    
                    NSDate *openDate = [DateUtils covnertStrToDate:[self.useDate description]];
                    NSDate *firstWeekStartDay = [DateUtils dateStartOfWeek:openDate];
                    //得到nowDay周的结束日
                    NSDate *endWeekStartDay = [DateUtils dateStartOfWeek:[NSDate date]];
                    
                    //得到开始周天   得到截止周六
                    int startWeekSunday = [DateUtils getDay:firstWeekStartDay];
                    int endWeekSater = [DateUtils getDay:endWeekStartDay]+6;
                    
                    int sumOfWeek = (([DateUtils getDaysOfMonth:_fromMonth year:_fromYear] - startWeekSunday+1) + endWeekSater)/7;
                    
                    
                    if(fromArr==NULL){
                        //得到一周胡起始日期
                        for(int i=0;i<sumOfWeek;i++){
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [tmArr addObject:[NSNumber numberWithInt:0]];
                        }
                    }
                    else{
                        
                        int x = startWeekSunday;
                        int xMonth = [DateUtils getMonth:firstWeekStartDay];
                        int xFromYear = [DateUtils getYear:firstWeekStartDay];
                        int xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:_fromYear];
                        int ySumOfWeek;
                        for(int i=0;i<sumOfWeek;i++){
                            ySumOfWeek = [self getySunOfWeekFromMonth:xMonth fromDay:x fromYear:xFromYear arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                            //下周起始日期
                            int sumOfWeekPlus = x + 7;
                            if(sumOfWeekPlus<=xCurrentDays){
                                x+=7;
                            }
                            else if(sumOfWeekPlus>xCurrentDays){
                                //月进位
                                if(xMonth==12){
                                    xMonth = 1;
                                    //年进位
                                    xFromYear ++;
                                }
                                else{
                                    xMonth ++;
                                    
                                }
                                x = 7- xCurrentDays - x;
                                xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:xFromYear];
                                
                            }
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [tmArr addObject:[NSNumber numberWithInt:ySumOfWeek]];
                            maxY = maxY>ySumOfWeek?maxY:ySumOfWeek;
                            
                            
                        }
                        
                    }
                    
                    
                }
                    break;
                case 2:{
                    //总共有多少周
                    //得到fromDay周起始日
                    
                    NSDate *openDate = [DateUtils covnertStrToDate:[self.useDate description]];
                    NSDate *firstWeekStartDay = [DateUtils dateStartOfWeek:openDate];
                    //得到nowDay周的结束日
                    NSDate *endWeekStartDay = [DateUtils dateStartOfWeek:[NSDate date]];
                    
                    //得到开始周天   得到截止周六
                    int startWeekSunday = [DateUtils getDay:firstWeekStartDay];
                    int endWeekSater = [DateUtils getDay:endWeekStartDay]+6;
                    
                    int sumOfWeek = (([DateUtils getDaysOfMonth:_fromMonth year:_fromYear] - startWeekSunday+1)
                                     + [DateUtils getDaysOfMonth:_fromMonth+1 year:_fromYear]
                                     + endWeekSater)/7;
                    
                    
                    
                    if(fromArr==NULL){
                        //得到一周胡起始日期
                        for(int i=0;i<sumOfWeek;i++){
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [tmArr addObject:[NSNumber numberWithInt:0]];
                        }
                    }
                    else{
                        
                        int x = startWeekSunday;
                        int xMonth = [DateUtils getMonth:firstWeekStartDay];
                        int xFromYear = [DateUtils getYear:firstWeekStartDay];
                        int xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:_fromYear];
                        int ySumOfWeek;
                        for(int i=0;i<sumOfWeek;i++){
                            ySumOfWeek = [self getySunOfWeekFromMonth:xMonth fromDay:x fromYear:xFromYear arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                            //下周起始日期
                            int sumOfWeekPlus = x + 7;
                            if(sumOfWeekPlus<=xCurrentDays){
                                x+=7;
                            }
                            else if(sumOfWeekPlus>xCurrentDays){
                                //月进位
                                if(xMonth==12){
                                    xMonth = 1;
                                    //年进位
                                    xFromYear ++;
                                }
                                else{
                                    xMonth ++;
                                    
                                }
                                x = 7- xCurrentDays - x;
                                xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:xFromYear];
                                
                            }
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [tmArr addObject:[NSNumber numberWithInt:ySumOfWeek]];
                            maxY = maxY>ySumOfWeek?maxY:ySumOfWeek;
                            
                            
                        }
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            
        }
        //3个月外，按月显示
        else if(_nowMonth-_fromMonth>=3){
            _showType = SHOW_TYPE_MONTH;
            //_fromMonth _nowMonth
            for(int i=_fromMonth;i<=_nowMonth;i++){
                int tmsum = [self getSumOfMonth:i arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                maxY = maxY >= tmsum?maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d月",i]];
                [tmArr addObject:[NSNumber numberWithInt:tmsum]];
                
            }
            
        }
    }
    else if(_fromYear-_nowYear==1){
        //3个月内，按周显示
        //month 差值
        int split = 12-_fromMonth + _nowMonth;
        if(split<=3){
            _showType = SHOW_TYPE_WEEK;
            
        }
        //3个月外，按月显示
        else if(split>3){
            _showType = SHOW_TYPE_MONTH;
            for(int i=_fromMonth;i<=12;i++){
                int tmsum = [self getSumOfMonth:i arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                maxY = maxY >= tmsum?maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromYear%100,i]];
                [tmArr addObject:[NSNumber numberWithInt:tmsum]];
            }
            for(int i=1;i<=_nowMonth;i++){
                int tmsum = [self getSumOfMonth:i arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                maxY = maxY >= tmsum?maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_nowYear%100,i]];
                [tmArr addObject:[NSNumber numberWithInt:tmsum]];
            }
        }
    }
    else if(_fromYear-_nowYear>1){
        //3个月外，按月显示
        _showType = SHOW_TYPE_MONTH;
        //头
        for(int i=_fromMonth;i<=12;i++){
            int tmsum = [self getSumOfMonth:i arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
            _maxY = _maxY >= tmsum?_maxY:tmsum;
            //x data
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromYear%100,i]];
            [tmArr addObject:[NSNumber numberWithInt:tmsum]];
        }
        //中
        for(int i = _fromYear+1;i<=_nowYear-1;i++){
            for(int j=1;j<=12;j++){
                int tmsum = [self getSumOfMonth:j arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
                maxY = maxY >= tmsum?maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",i%100,j]];
                [tmArr addObject:[NSNumber numberWithInt:tmsum]];
            }
        }
        //尾
        for(int i=1;i<=_nowMonth;i++){
            int tmsum = [self getSumOfMonth:i arr:fromArr sumkey:@"dayTotal" datekey:@"dayTime"];
            maxY = maxY >= tmsum?maxY:tmsum;
            //x data
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_nowYear%100,i]];
            [tmArr addObject:[NSNumber numberWithInt:tmsum]];
        }
    }
    
    
    return maxY;
}

#pragma mark - getySumOfMonth
-(int)getSumOfMonth:(int)month arr:(NSArray*)arr sumkey:(NSString*)sumkey datekey:(NSString*)datekey{
    int sum=0;
    for(NSDictionary *tmdic in arr){
        NSDate *tmDate = [tmdic objectForKey:datekey];
        int tmsum = [[tmdic objectForKey:sumkey] intValue];
        int tmmonth = [DateUtils getMonth:tmDate];
        if(tmmonth == month){
            sum += tmsum;
        }
        
    }
    return sum;
}

#pragma mark - getySumOfWeek
-(int)getySunOfWeekFromMonth:(int)fromMonth fromDay:(int)fromday fromYear:(int)fromyear arr:(NSArray*)arr sumkey:(NSString*)sumkey datekey:(NSString*)datekey{
    int sum = 0;
    int sumDaysOfMonth = [DateUtils getDaysOfMonth:fromMonth year:fromyear];
    int currentSum = fromday + 6;
    if(currentSum<=sumDaysOfMonth){
        for(NSDictionary *tmdict in arr){
            NSDate *tmDate = [tmdict objectForKey:datekey];
            int tmsum = [[tmdict objectForKey:sumkey] intValue];
            
            int tmmonth = [DateUtils getMonth:tmDate];
            int tmday = [DateUtils getDay:tmDate];
            
            if(tmmonth == fromMonth &&(tmday>=fromday&&tmday<=fromday+6)){
                sum+=tmsum;
            }
        }
    }
    else if(currentSum>sumDaysOfMonth){
        if(fromMonth==12){
            for(NSDictionary *tmdict in arr){
                NSDate *tmDate = [tmdict objectForKey:datekey];
                int tmsum = [[tmdict objectForKey:sumkey] intValue];
                
                int tmmonth = [DateUtils getMonth:tmDate];
                int tmday = [DateUtils getDay:tmDate];
                
                if(tmmonth == fromMonth &&(tmday>=fromday&&tmday<=sumDaysOfMonth)){
                    sum+=tmsum;
                }
            }
            
            
            //下个月
            //            int nextYear = fromyear +1;
            int nextMonth = 1;
            int nextDay = 6 - (sumDaysOfMonth - fromday);
            for(NSDictionary *tmdict in arr){
                NSDate *tmDate = [tmdict objectForKey:datekey];
                int tmsum = [[tmdict objectForKey:sumkey] intValue];
                
                int tmmonth = [DateUtils getMonth:tmDate];
                int tmday = [DateUtils getDay:tmDate];
                
                if(tmmonth == nextMonth &&(tmday>=1&&tmday<=nextDay)){
                    sum+=tmsum;
                }
            }
        }
        else{
            //这个月
            for(NSDictionary *tmdict in arr){
                NSDate *tmDate = [tmdict objectForKey:datekey];
                int tmsum = [[tmdict objectForKey:sumkey] intValue];
                
                int tmmonth = [DateUtils getMonth:tmDate];
                int tmday = [DateUtils getDay:tmDate];
                
                if(tmmonth == fromMonth &&(tmday>=fromday&&tmday<=sumDaysOfMonth)){
                    sum+=tmsum;
                }
            }
            
            
            //下个月
            int nextMonth = fromMonth+1;
            int nextDay = 6 - (sumDaysOfMonth - fromday);
            for(NSDictionary *tmdict in arr){
                NSDate *tmDate = [tmdict objectForKey:datekey];
                int tmsum = [[tmdict objectForKey:sumkey] intValue];
                
                int tmmonth = [DateUtils getMonth:tmDate];
                int tmday = [DateUtils getDay:tmDate];
                
                if(tmmonth == nextMonth &&(tmday>=1&&tmday<=nextDay)){
                    sum+=tmsum;
                }
            }
        }
    }
    
    return sum;
    
}

#pragma mark - refreshFrameData
-(void)refreshFrameData{
    //data test
//    _maxY=6;
//    [_currentShowLine1Arr removeAllObjects];
//    [_currentShowLine2Arr removeAllObjects];
//    [_currentShowLine3Arr removeAllObjects];
//    
//    for(int i=0;i<5;i++){
//        [_currentShowLine1Arr addObject:[NSNumber numberWithInt:0]];
//        [_currentShowLine2Arr addObject:[NSNumber numberWithInt:0]];
//        [_currentShowLine3Arr addObject:[NSNumber numberWithInt:0]];
//    }
//    _maxYAll = 0;
//    _maxYAdd = 0;
//    _maxYCancel = 0;
    _srcvw.contentOffset = CGPointZero;
    _lbTime.text = [NSString stringWithFormat:@"%@ 至 %@",
                    [DateUtils convertDateToString:self.useDate?self.useDate:[NSDate date]],
                    [DateUtils convertDateToString:[NSDate date]]];
    
    _lbAllSum.text = [NSString stringWithFormat:@"%d",self.allSum];
    _lbAddnewSum.text = [NSString stringWithFormat:@"%d",self.addSum];
    _lbCancelSum.text = [NSString stringWithFormat:@"%d",self.cancelSum];
    
    //src
    float width = [self getSRCWidth];
    _srcvw.contentSize = CGSizeMake(width, _srcvw.bounds.size.height);

    
    
    NSLog(@"%f---%f--%d",_srcvw.contentSize.width,_srcvw.contentSize.height,[_xArr count]);
    //line
    self.fgvSum.dataPoints = self.currentShowLine1Arr;
    
    float xsplit = 33;
    float line1Height = [self getFDVHeightByMaxY:_maxYAll];
    float line2Height = [self getFDVHeightByMaxY:_maxYAdd];
    float line3Height = [self getFDVHeightByMaxY:_maxYCancel];
    self.fgvSum.frame = CGRectMake(0, _srcvw.bounds.size.height - line1Height, xsplit*[_currentShowLine1Arr count], line1Height);
    
    self.fgvNewAdd.dataPoints = self.currentShowLine2Arr;
    
    self.fgvNewAdd.frame = CGRectMake(0, _srcvw.bounds.size.height-line2Height, xsplit*[_currentShowLine2Arr count], line2Height);
    self.fgvCancel.dataPoints = self.currentShowLine3Arr;
    self.fgvCancel.frame = CGRectMake(0, _srcvw.bounds.size.height-line3Height, xsplit*[_currentShowLine3Arr count], line3Height);
    
    //x
    [self reloadx];
    
    //y
    [self reloady];
    
}

#pragma mark - width
-(double)getSRCWidth{
    float width = [_xArr count]/8*291.0f + ([_xArr count]%8!=0?291.0f:0);
    return width;
}
#pragma mark - height
-(double)getFDVHeightByMaxY:(int)tmMaxY{
    float hight = self.srcvw.bounds.size.height;
    if(7>=_maxY){
        float tmHight = tmMaxY<=0?0.3:tmMaxY;
        hight = hight/6*tmHight;
        
    }
    else{
        if(_maxY==tmMaxY){
            hight = self.srcvw.bounds.size.height;
        }
        else{
            hight = self.srcvw.bounds.size.height/_maxY*tmMaxY;
        }
    }
    return hight;
}

#pragma mark - reloadX
-(void)reloadx{
    [self clearX];
    for(int i=0;i<8;i++){
        if(i>=[_xArr count]){
            return;
        }
        UILabel *tmlb = [self.xlbArr objectAtIndex:i];
        tmlb.text = [NSString stringWithFormat:@"%@",[self.xArr objectAtIndex:i]];
        
        
    }
}

-(void)clearX{
    for(UILabel *lb in _xlbArr){
        lb.text = @"";
    }
}
#pragma mark - reloady
-(void)reloady{
    
    
    
    for(int i=0;i<7;i++){
        UILabel *tmlb = [self.ylbArr objectAtIndex:i];
        tmlb.text = [NSString stringWithFormat:@"%@",[self.yArr objectAtIndex:i]];
    }
}


#pragma mark - scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"end!,%f",scrollView.contentOffset.x);
    
    //x轴换坐标
    NSLog(@"%f",scrollView.contentOffset.x);
    float x = scrollView.contentOffset.x;
    int split = (int)x/291.0f;
    //x轴清空
    [self clearX];
    //from 8
    for(int i=0;i<8;i++){
        int xindex = split*8+i;
        if(xindex+1>[_xArr count]){
            return;
        }
        UILabel *tmlb = [_xlbArr objectAtIndex:i];
        tmlb.text = [NSString stringWithFormat:@"%@",[_xArr objectAtIndex:xindex]];
    }
}

@end
