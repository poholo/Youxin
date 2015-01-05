//
//  WIAllViewController.m
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WIAllViewController.h"
#import "UIUtils.h"
#import "DateUtils.h"
#import "ViewUtils.h"

@interface WIAllViewController ()

@end

@implementation WIAllViewController

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
    
    //0.net  data
    
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _currentShowData = [[NSMutableArray alloc] initWithCapacity:0];
    _xArr = [[NSMutableArray alloc] initWithCapacity:0];
    _yArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    //1.view
    _lbTime = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 44, 320, 30) text:@""];
    [self.view addSubview:_lbTime];
    
    _lbYXTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, _lbTime.frame.size.height + _lbTime.frame.origin.y, 320, 30) text:@"信息查询总量"];
    [self.view addSubview:_lbYXTitle];
    
    
    _lbYXSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(0, _lbYXTitle.frame.size.height + _lbYXTitle.frame.origin.y, 320, 30) text:@"0"];
    [self.view addSubview:_lbYXSum];
    
    //折线图
    //1.折线图背景图
    UIImageView *imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebg"]];
    imgvw.frame = CGRectMake(25, _lbYXSum.frame.origin.y + _lbYXSum.frame.size.height, 290, self.view.bounds.size.height - 44 -44 -_lbYXSum.frame.origin.y - _lbYXSum.frame.size.height);
    
    [self.view addSubview:imgvw];
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20+7, _lbYXSum.frame.origin.y + _lbYXSum.frame.size.height+30, 291, self.view.bounds.size.height - 44 -44 -_lbYXSum.frame.origin.y - _lbYXSum.frame.size.height-30)];
    self.scrollview.delegate = self;
    self.scrollview.bounces = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    
    self.scrollview.pagingEnabled = YES;
    //    self.scrollview.backgroundColor = [UIColor orangeColor];
    //    self.scrollview.alpha = 0.3;
    
    _fdgcYXDis = [[FDGraphView alloc] initWithFrame:CGRectMake(0, 0, ([_xArr count]-1)*37+25, self.scrollview.bounds.size.height)];
    //    [_fdgcYXDis setBackgroundColor:[UIColor greenColor]];
    
    //高12（两格一标注）  宽 14（两格一标注）
    
    _fdgcYXDis.dataPoints = self.currentShowData;
    _fdgcYXDis.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    _fdgcYXDis.dataPoints = @[@0, @1, @2, @3, @4, @5, @6,@1, @2, @3, @4, @5, @6, @7,@1, @2, @3, @4, @5, @6, @7];
    
    self.scrollview.contentSize = CGSizeMake(_fdgcYXDis.bounds.size.width, self.scrollview.bounds.size.height);
    [self.scrollview addSubview:_fdgcYXDis];
    
    [self.view addSubview:self.scrollview];
    //2.折线图 x轴 y轴标注
    _xlbArr = [[NSMutableArray alloc] initWithCapacity:8];
    
    
    _ylbArr = [[NSMutableArray alloc] initWithCapacity:7];
    for(int i=0;i<7;i++){
        UILabel *tmlb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  imgvw.frame.size.height + imgvw.frame.origin.y - i*33-15,
                                                                  25,
                                                                  10)];
        //        tmlb.text = [NSString stringWithFormat:@"%d199",i];
        tmlb.textAlignment =UITextAlignmentRight;
        tmlb.textColor = [UIColor grayColor];
        tmlb.font = [UIFont systemFontOfSize:10];
        tmlb.backgroundColor = [UIColor clearColor];
        [self.ylbArr addObject:tmlb];
        [self.view addSubview:tmlb];
        
    }
    
    for(int i=0;i<8;i++){
        
        UILabel *tmxlb = [[UILabel alloc] initWithFrame:CGRectMake(25 + i*37,
                                                                   _scrollview.frame.size.height + _scrollview.frame.origin.y,
                                                                   30, 10)];
        //        tmxlb.text = [NSString stringWithFormat:@"%d111",i];
        tmxlb.textAlignment = UITextAlignmentLeft;
        tmxlb.textColor = [UIColor grayColor];
        tmxlb.backgroundColor = [UIColor clearColor];
        tmxlb.font = [UIFont systemFontOfSize:10];
        
        
        [self.xlbArr addObject:tmxlb];
        [self.view addSubview:tmxlb];
    }
    
    
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate =self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"hudong",
                      @"tag1",
                      @""];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    [self.view addSubview:[ViewUtils createDataBoard]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - httpdownloaddelegate
-(void)downloadComplete:(HttpDownload *)hd{
    
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",dict);
    if(NULL == dict){
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
        
    }
    else{
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];
        self.yxSum = [[dict objectForKey:@"queryTotal"] intValue];
        self.dataArr = [dict objectForKey:@"dayData"];
        self.usedate = [dict objectForKey:@"useTime"];
        

        
        //一个月内以天为单位显示，三个月内以周为单位显示，超过三个月以月为单位显示。每页显示7格。
        NSLog(@"%@",self.usedate);
        
        [self manStartTimeAndEndTime];
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
        
        NSLog(@"xArr-%@",_xArr);
        NSLog(@"yArr-%@",_yArr);
        NSLog(@"currentData%@",_currentShowData);

        
        [self refreshData];
    }
    
    
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}
#pragma mark - 时间起始处理
-(void)manStartTimeAndEndTime{
    NSLog(@"%@",self.usedate);
    _fromYear = [DateUtils getYear:self.usedate];
    _fromMonth = [DateUtils getMonth:self.usedate];
    _fromDay = [DateUtils getDay:self.usedate];
    
    
    _nowYear = [DateUtils getYear:[NSDate date]];
    _nowMonth = [DateUtils getMonth:[NSDate date]];
    _nowDay = [DateUtils getDay:[NSDate date]];
    
    
    // x  y 清空
    [_xArr removeAllObjects];
    [_yArr removeAllObjects];
    [_currentShowData removeAllObjects];
    
    //showType判断
    _maxY = 0;
    if(_fromYear==_nowYear){
        //一个月内，按天展示
        if(_fromMonth == _nowMonth){
            _showType = SHOW_TYPE_DAY;
            
            int j = _fromDay;
            for(int i=_fromDay;i<=_nowDay;i++){
                //x轴数据
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromMonth,i]];
                
                if(self.dataArr==NULL){
                    [_currentShowData addObject:[NSNumber numberWithInt:0]];
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
                        
                        tmdic = [self.dataArr objectAtIndex:j];
                        tmDate = [tmdic objectForKey:@"dayTime"];
                        //得到x轴数据
                        tmMonth = [DateUtils getMonth:tmDate];
                        tmDay = [DateUtils getDay:tmDate];
                        
                        
                    }
                    
                    if(tmMonth == _fromMonth && tmDay == i){
                        int y = [[tmdic objectForKey:@"dayTotal"] intValue];
                        [self.currentShowData addObject:[NSNumber numberWithInt:y]];
                        _maxY = _maxY >y ? _maxY:y;
                        
                        j++;
                        
                    }
                    else{
                        int y = 0;
                        [self.currentShowData addObject:[NSNumber numberWithInt:y]];
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
                    
                    NSDate *openDate = [DateUtils covnertStrToDate:[self.usedate description]];
                    NSDate *firstWeekStartDay = [DateUtils dateStartOfWeek:openDate];
                    //得到nowDay周的结束日
                    NSDate *endWeekStartDay = [DateUtils dateStartOfWeek:[NSDate date]];
                    
                    //得到开始周天   得到截止周六
                    int startWeekSunday = [DateUtils getDay:firstWeekStartDay];
                    int endWeekSater = [DateUtils getDay:endWeekStartDay]+6;
                    
                    int sumOfWeek = (([DateUtils getDaysOfMonth:_fromMonth year:_fromYear] - startWeekSunday+1) + endWeekSater)/7;
                    
//                    int zz;
                    
                    if(self.dataArr==NULL){
                        //得到一周胡起始日期
                        for(int i=0;i<sumOfWeek;i++){
//                            zz = i;
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [_currentShowData addObject:[NSNumber numberWithInt:0]];
                        }
                    }
                    else{
                        
                        int x = startWeekSunday;
                        int xMonth = [DateUtils getMonth:firstWeekStartDay];
                        int xFromYear = [DateUtils getYear:firstWeekStartDay];
                        int xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:_fromYear];
                        int ySumOfWeek;
                        for(int i=0;i<sumOfWeek;i++){
//                            zz= i;
                            if(i==4){
                                return;
                            }
                            
                            ySumOfWeek = [self getySunOfWeekFromMonth:xMonth fromDay:x fromYear:xFromYear arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
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
                                x = 7- (xCurrentDays - x);
                                NSLog(@"xMonth----%d,xFromYear---%d",xMonth,xFromYear);
                                xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:xFromYear];
                                
                            }
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [_currentShowData addObject:[NSNumber numberWithInt:ySumOfWeek]];
                            _maxY = _maxY>ySumOfWeek?_maxY:ySumOfWeek;
                            
                            NSLog(@"---%@",self.currentShowData);
                            NSLog(@"x---%@",self.xArr);
                            
                            
                        }
                        
                    }
//                    [_xArr addObject:[NSString stringWithFormat:@"第%d周",zz+1]];
                    NSLog(@"%d",[_xArr count]);
                    
                }
                    break;
                case 2:{
                    //总共有多少周
                    //得到fromDay周起始日
                    
                    NSDate *openDate = [DateUtils covnertStrToDate:[self.usedate description]];
                    NSDate *firstWeekStartDay = [DateUtils dateStartOfWeek:openDate];
                    //得到nowDay周的结束日
                    NSDate *endWeekStartDay = [DateUtils dateStartOfWeek:[NSDate date]];
                    
                    //得到开始周天   得到截止周六
                    int startWeekSunday = [DateUtils getDay:firstWeekStartDay];
                    int endWeekSater = [DateUtils getDay:endWeekStartDay]+6;
                    
                    int sumOfWeek = (([DateUtils getDaysOfMonth:_fromMonth year:_fromYear] - startWeekSunday+1)
                                     + [DateUtils getDaysOfMonth:_fromMonth+1 year:_fromYear]
                                     + endWeekSater)/7;
                    
                    
                    
                    if(self.dataArr==NULL){
                        //得到一周胡起始日期
                        for(int i=0;i<sumOfWeek;i++){
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [_currentShowData addObject:[NSNumber numberWithInt:0]];
                        }
                    }
                    else{
                        
                        int x = startWeekSunday;
                        int xMonth = [DateUtils getMonth:firstWeekStartDay];
                        int xFromYear = [DateUtils getYear:firstWeekStartDay];
                        int xCurrentDays = [DateUtils getDaysOfMonth:xMonth year:_fromYear];
                        int ySumOfWeek;
                        for(int i=0;i<sumOfWeek;i++){
                            
                            ySumOfWeek = [self getySunOfWeekFromMonth:xMonth fromDay:x fromYear:xFromYear arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
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
                            //i==5 break;
                            [_xArr addObject:[NSString stringWithFormat:@"第%d周",i+1]];
                            [_currentShowData addObject:[NSNumber numberWithInt:ySumOfWeek]];
                            _maxY = _maxY>ySumOfWeek?_maxY:ySumOfWeek;
                            
                            
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
                int tmsum = [self getSumOfMonth:i arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
                _maxY = _maxY >= tmsum?_maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d月",i]];
                [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
                
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
                int tmsum = [self getSumOfMonth:i arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
                _maxY = _maxY >= tmsum?_maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromYear%100,i]];
                [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
            }
            for(int i=1;i<=_nowMonth;i++){
                int tmsum = [self getSumOfMonth:i arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
                _maxY = _maxY >= tmsum?_maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_nowYear%100,i]];
                [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
            }
        }
    }
    else if(_fromYear-_nowYear>1){
        //3个月外，按月显示
        _showType = SHOW_TYPE_MONTH;
        //头
        for(int i=_fromMonth;i<=12;i++){
            int tmsum = [self getSumOfMonth:i arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
            _maxY = _maxY >= tmsum?_maxY:tmsum;
            //x data
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_fromYear%100,i]];
            [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
        }
        //中
        for(int i = _fromYear+1;i<=_nowYear-1;i++){
            for(int j=1;j<=12;j++){
                int tmsum = [self getSumOfMonth:j arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
                _maxY = _maxY >= tmsum?_maxY:tmsum;
                //x data
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",i%100,j]];
                [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
            }
        }
        //尾
        for(int i=1;i<=_nowMonth;i++){
            int tmsum = [self getSumOfMonth:i arr:self.dataArr sumkey:@"dayTotal" datekey:@"dayTime"];
            _maxY = _maxY >= tmsum?_maxY:tmsum;
            //x data
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",_nowYear%100,i]];
            [_currentShowData addObject:[NSNumber numberWithInt:tmsum]];
        }
    }
    
    
    
    
    
    
    
    
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
            NSLog(@"%@",tmDate);
            NSLog(@"月日%d---%d",tmmonth,tmday);
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


-(void)refreshData{
    //test Data
    //<--------
    /*
    [_currentShowData removeAllObjects];
    _maxY = 14;
    _showType = SHOW_TYPE_DAY;
    [_yArr removeAllObjects];
    [_xArr removeAllObjects];
    for(int i=0;i<31;i++){
        [_currentShowData addObject:[NSNumber numberWithInt:i%14]];
        [_xArr addObject:[NSString stringWithFormat:@"10-%d",i+1]];
    }
    //y
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
    
    */
    //month
    /*
     [_currentShowData removeAllObjects];
     _maxY = 8;
     _showType = SHOW_TYPE_MONTH;
     [_yArr removeAllObjects];
     [_xArr removeAllObjects];
     for(int i=0;i<12;i++){
     [_currentShowData addObject:[NSNumber numberWithInt:i%14]];
     [_xArr addObject:[NSString stringWithFormat:@"13-%d",i+1]];
     }
     //y
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
     */
    //-->

    
    _scrollview.contentOffset = CGPointZero;
    _lbYXSum.text = [NSString stringWithFormat:@"%d",self.yxSum];
    float width = [_xArr count]/8*291.0f + ([_xArr count]%8!=0?291.0f:0);
    _scrollview.contentSize = CGSizeMake(width, _scrollview.bounds.size.height);
    
        
    //line
    self.fdgcYXDis.dataPoints = self.currentShowData;
    float hight = _scrollview.bounds.size.height;
    if(7>=_maxY){
        float tmHight = _maxY<=0?0.3:_maxY;
        hight = hight/6.1*tmHight;
        
    }
    else{
        hight = _scrollview.bounds.size.height;
    }

    CGRect rect ;
    switch (_showType) {
        case SHOW_TYPE_DAY:
        {
            _fdgcYXDis.dataPointsXoffset = 150.0f/4-0.7;
            rect = CGRectMake(_fdgcYXDis.frame.origin.x,
                              _scrollview.bounds.size.height-hight,
                              [_xArr count]*30,
                              hight);
        }
            break;
        case SHOW_TYPE_WEEK:{
            _fdgcYXDis.dataPointsXoffset = 150.0f/4;
            rect = CGRectMake(_fdgcYXDis.frame.origin.x,
                              _scrollview.bounds.size.height-hight,
                              [_xArr count]*30.5,
                              hight);
        }
            break;
        case SHOW_TYPE_MONTH:{
            _fdgcYXDis.dataPointsXoffset = 150.0f/4;
            rect = CGRectMake(_fdgcYXDis.frame.origin.x,
                              _scrollview.bounds.size.height-hight,
                              [_xArr count]*30.5f,
                              hight);
        }
            break;
        default:
            break;
    }

    //时间表示
    _lbTime.text = [NSString stringWithFormat:@"%@ 至 %@",
                    [DateUtils convertDateToString:self.usedate],
                    [DateUtils convertDateToString:[NSDate date]]];
    
    //表数据
    //1.刷新Y轴
    [self reloadx];
    [self reloady];
}

#pragma mark - reloadX
-(void)reloadx{
    for(int i=0;i<8;i++){
        if ([_xArr count]<=i) {
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
-(NSString*)convertTimeToString:(NSDate*)date{
    
    NSLog(@"%@",date);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    
    NSLog(@"locationString:%@",locationString);
    return locationString;
    
}

#pragma mark - scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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
