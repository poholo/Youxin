//
//  WXWeekViewController.m
//  youxin
//
//  Created by yuyang on 13-9-26.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WXWeekViewController.h"
#import "DateUtils.h"
#import "UIUtils.h"

@interface WXWeekViewController ()

@end

@implementation WXWeekViewController

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
	self.view.backgroundColor = [UIColor whiteColor];
    
    //0.net  data
    NSDate * currentDate = [NSDate date];
    
    
    [self refreshStartDateAndEndDate:currentDate];
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _currentShowData = [[NSMutableArray alloc] initWithCapacity:0];
    _xArr = [[NSMutableArray alloc] initWithCapacity:0];
    _yArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _lbTime = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 44, 320, 30) text:[NSString stringWithFormat:@"%@ 至 %@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
    
    [self.view addSubview:_lbTime];
    
    _lbYXTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(20, _lbTime.frame.size.height + _lbTime.frame.origin.y, 140, 30) text:@"营销集客总量"];
    [self.view addSubview:_lbYXTitle];
    
    _lbActionTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(160, _lbYXTitle.frame.origin.y, _lbYXTitle.frame.size.width, _lbYXTitle.frame.size.height) text:@"营销活动总量"];
    
    [self.view addSubview:_lbActionTitle];
    
    _lbYXSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(_lbYXTitle.frame.origin.x,
                                                               _lbYXTitle.frame.origin.y + _lbYXTitle.frame.size.height,
                                                               _lbYXTitle.frame.size.width,
                                                               _lbYXTitle.frame.size.height) text:@"0" ];
    
    [self.view addSubview:_lbYXSum];
    
    _lbActionSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(_lbActionTitle.frame.origin.x,
                                                                   self.lbActionTitle.frame.origin.y + self.lbActionTitle.frame.size.height,
                                                                   self.lbActionTitle.bounds.size.width,
                                                                   self.lbActionTitle.bounds.size.height) text:@"0"];
    
    [self.view addSubview:_lbActionSum];

    //折线图
    //1.折线图背景图
    UIImageView *imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebg"]];
    imgvw.frame = CGRectMake(25, _lbYXSum.frame.origin.y + _lbYXSum.frame.size.height, 290, self.view.bounds.size.height - 44 -44 -_lbYXSum.frame.origin.y - _lbYXSum.frame.size.height);
    
    [self.view addSubview:imgvw];
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20+3, _lbYXSum.frame.origin.y + _lbYXSum.frame.size.height+30, 275, self.view.bounds.size.height - 44 -44 -_lbYXSum.frame.origin.y - _lbYXSum.frame.size.height-30)];
    
    _fdgcYXDis = [[FDGraphView alloc] initWithFrame:CGRectMake(0, 0, _scrollview.frame.size.width, self.scrollview.bounds.size.height)
                                        xOffset:150.0f/4-10];
    _fdgcYXDis.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    _fdgcYXDis.dataPoints =_currentShowData;
    
    //高12（两格一标注）  宽 14（两格一标注）
    self.scrollview.delegate =self;
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
        tmlb.text = [NSString stringWithFormat:@"%d199",i];
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
        tmxlb.text = [NSString stringWithFormat:@"%d111",i];
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
                      @"jike",
                      @"tag2",
                      [NSString stringWithFormat:@"%@,%@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    
    //btn
    _btnBeforeWeek = [[UIButton alloc] initWithFrame:CGRectMake(30, 40, 35, 35)];
    [_btnBeforeWeek setBackgroundImage:[UIImage imageNamed:@"btn_left_normal"] forState:UIControlStateNormal];
    [_btnBeforeWeek setBackgroundImage:[UIImage imageNamed:@"btn_left_highted"] forState:UIControlStateHighlighted];
    _btnBeforeWeek.tag = 0;
    [_btnBeforeWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnBeforeWeek];
    
    
    _btnNextWeek = [[UIButton alloc] initWithFrame:CGRectMake(270, 40, 35, 35)];
    [_btnNextWeek setBackgroundImage:[UIImage imageNamed:@"btn_right_normal"] forState:UIControlStateNormal];
    [_btnNextWeek setBackgroundImage:[UIImage imageNamed:@"btn_right_highted"] forState:UIControlStateHighlighted];
    
    _btnNextWeek.tag = 1;
    [_btnNextWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnNextWeek.enabled = NO;
    
    [self.view addSubview:_btnNextWeek];
    
    
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
        self.yxSum = [[dict objectForKey:@"jikeTotal"] intValue];
        self.actionSum = [[dict objectForKey:@"huodongTotal"] intValue];
        self.dataArr = [dict objectForKey:@"dayData"];
        self.usedate = [dict objectForKey:@"useTime"];
        self.openDate = [self.usedate description];
        
        NSLog(@"%@",self.usedate);
        //清除数据
        [_xArr removeAllObjects];
        [_yArr removeAllObjects];
        [_currentShowData removeAllObjects];
       
            
        _maxY = 0;
        //x轴定量
        //初始值
        int currentYear = [DateUtils getYear:self.startDate];
        int month = [DateUtils getMonth:self.startDate];
        int currentday = [DateUtils getDay:self.startDate];
        
        //本月最大天数
        int sumOfCurrentMonth = [DateUtils getDaysOfMonth:month year:currentYear];
        int j = 0;
        int count = [self.dataArr count];
        for(int i =0;i<7;i++){
            if(currentday==sumOfCurrentMonth){
                currentday = 1;
                if(month==12){
                    month = 1;
                    currentYear ++;
                }
                else{
                    month++;
                }
            }
            else{
                currentday ++;
            }
            //x
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",month,currentday]];
            //y
            //得到当前y数据
            NSDictionary *tmdic;
            NSDate *tmDate;
            //得到x轴数据
            int tmMonth;
            int tmDay;

            if(j>=count-1){
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
                       
            if(tmMonth == month && tmDay == currentday){
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
        
        [self reloadCurrentData];
        [self refreshData];
    }
    
       
    
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}

-(void)refreshData{
    self.lbYXSum.text = [NSString stringWithFormat:@"%d",self.yxSum];
    self.lbActionSum.text =[NSString stringWithFormat:@"%d",self.actionSum];
    //重绘画布
     _fdgcYXDis.dataPoints =_currentShowData;
    _fdgcYXDis.frame = _scrollview.bounds;
    /*
    //test Data
    //<--------
     [_currentShowData removeAllObjects];
     _maxY = 14;
     [_yArr removeAllObjects];
     [_xArr removeAllObjects];
     for(int i=0;i<7;i++){
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
    //-->
     */
    
    float width = [_xArr count]/8*275.0f + ([_xArr count]%8!=0?275.0f:0);
    
    //Y
    
    float hight = _scrollview.bounds.size.height;
    if(7>=_maxY){
        float tmHight = _maxY<=0?0.3:_maxY;
        hight = hight/6*tmHight;

    }
    else{
        hight = _scrollview.bounds.size.height;
    }
    _fdgcYXDis.frame=CGRectMake(_fdgcYXDis.frame.origin.x,
                                _scrollview.bounds.size.height-hight,
                                [_xArr count]*34,
                                hight);
    NSLog(@"%f---%f---%f---%f",_fdgcYXDis.frame.origin.x,_fdgcYXDis.frame.origin.y,_fdgcYXDis.frame.size.width,_fdgcYXDis.frame.size.height);
    
    NSLog(@"%f---%f---%f---%f",_scrollview.frame.origin.x,_scrollview.frame.origin.y,_scrollview.frame.size.width,_scrollview.frame.size.height);
    NSLog(@"%@",_fdgcYXDis);
    
    NSLog(@"%@",_currentShowData);
    
    
   
    
    self.scrollview.contentSize = CGSizeMake(width, self.scrollview.bounds.size.height);
    //时间表示
    _lbTime.text = [NSString stringWithFormat:@"%@ 至 %@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]];
    
    //表数据
    //1.刷新Y轴
    [self reloadx];
    [self reloady];
}

#pragma mark - reloadX
-(void)reloadx{
    [self clearX];
    for(int i=0;i<8;i++){
        UILabel *tmlb = [self.xlbArr objectAtIndex:i];
        if([_xArr count]<=i){
            return;
        }
        tmlb.text = [NSString stringWithFormat:@"%@",[self.xArr objectAtIndex:i]];
        
        
    }
}

-(void)clearX{
    for(UILabel* lb in _xlbArr){
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

#pragma mark - date mana
-(NSDate *)dateStartOfWeek:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}
-(NSDate*)dateEndOfWeek:(NSDate*)date{
    
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *weekend = [date dateByAddingTimeInterval:-secondsPerDay];
    return weekend;
}

-(NSDate*)nextDateFirstOfWeek:(NSDate*)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *first = [date dateByAddingTimeInterval:secondsPerDay];
    return first;
}
-(NSDate*)nextDateEndOfFirst:(NSDate*)first{
    NSTimeInterval secondsPerDay = 24 * 60 * 60*6;
    
    NSDate *end = [first dateByAddingTimeInterval:secondsPerDay];
    return end;
}


-(NSString*)converDateToString:(NSDate*)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  dateStr=[dateformatter stringFromDate:date];
    
    NSLog(@"convert:%@",dateStr);
    return dateStr;
    
}

-(void)refreshStartDateAndEndDate:(NSDate*)date{
    self.endDate = [self dateEndOfWeek:[self dateStartOfWeek:date]];
    
    NSLog(@"end%@",self.endDate);
    
    self.startDate = [self dateStartOfWeek:self.endDate];
    NSLog(@"start%@",self.startDate);
}
-(void)refreshNextStartAndEnd:(NSDate*)date{
    self.startDate = [self nextDateFirstOfWeek:self.endDate];
    self.endDate = [self nextDateEndOfFirst:self.startDate];
    
    NSLog(@"nextFirst - %@ nextEnd %@",self.startDate,self.endDate);
}

#pragma mark - reloaddata

-(void)reloadCurrentData{
    _lbTime.text = [NSString stringWithFormat:@"%@ 至 %@",[self converDateToString:_startDate],[self converDateToString:_endDate]];
    
    //reloaddata
    NSLog(@"%@",_lbTime.text);
}


#pragma mark -btnclick
-(void)btnClick:(id)sender{
    UIButton *btn = sender;
    switch (btn.tag) {
            
            //上一周数据
        case 0:
        {
            
            
            [self refreshStartDateAndEndDate:self.startDate];
            
            //startDate
            int rinowYear = [DateUtils getYear:self.startDate];
            int rinowMonth = [DateUtils getMonth:self.startDate];
            
            int rinowDay = [DateUtils getDay:self.startDate];
            
            int openYear = [DateUtils getYearFromStr:self.openDate];
            int openMonth = [DateUtils getMothFromStr:self.openDate];
            int openDay = [DateUtils getDayFromStr:self.openDate];
            
            if(rinowYear<openYear){
                self.btnBeforeWeek.enabled = NO;
            }
            else if(rinowYear == openYear){
                if(rinowMonth<openMonth){
                    self.btnBeforeWeek.enabled = NO;
                }
                else if(rinowMonth==openMonth){
                    if(rinowDay<=openDay){
                        self.btnBeforeWeek.enabled = NO;
                    }
                }
            }
            
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"jike",
                              @"tag2",
                              [NSString stringWithFormat:@"%@,%@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            
            [_mHttpdownload downloadHomeUrl:home_url postparm:post];
            [SVProgressHUD showWithStatus:@"数据加载中"];
            
            //            if(self.endDate<=[self dateStartOfWeek:[NSDate date]]){
            //                self.btnNextWeek.enabled = YES;
            //            }
            //            else{
            //                self.btnNextWeek.enabled = NO;
            //            }
            self.btnNextWeek.enabled = YES;
            
            
            
            
        }
            break;
            //下一周数据
        case 1:{
            [self refreshNextStartAndEnd:nil];
            
            //enddate
            int endYear = [DateUtils getYear:self.endDate];
            int endMonth = [DateUtils getMonth:self.endDate];
            int endDay = [DateUtils getDay:self.endDate];
            
            int openYear = [DateUtils getYear:[NSDate date]];
            int openMonth = [DateUtils getMonth:[NSDate date]];
            int openDay = [DateUtils getDay:[NSDate date]];
            
            
            if(endYear>openYear){
                self.btnNextWeek.enabled = NO;
            }
            else if(endYear==openYear){
                if(endMonth>openMonth){
                    self.btnNextWeek.enabled = NO;
                }
                else if(endMonth==openMonth){
                    if(endDay>=openDay){
                        self.btnNextWeek.enabled = NO;
                    }
                }
            }
            
            self.btnBeforeWeek.enabled = YES;
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"jike",
                              @"tag2",
                              [NSString stringWithFormat:@"%@,%@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            
            [_mHttpdownload downloadHomeUrl:home_url postparm:post];
            [SVProgressHUD showWithStatus:@"数据加载中"];
            
            //            if(self.endDate<=[self dateStartOfWeek:[NSDate date]]){
            //                self.btnNextWeek.enabled = YES;
            //            }
            //            else{
            //                self.btnNextWeek.enabled = NO;
            //            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"end!,%f",scrollView.contentOffset.x);
    
    //x轴换坐标
    NSLog(@"%f",scrollView.contentOffset.x);
    float x = scrollView.contentOffset.x;
    int split = (int)x/275.0f;
    //x轴清空
    [self clearX];
    //from 8
    for(int i=0;i<8;i++){
        int xindex = split*8+i;
        if(xindex+1>[_xArr count]){
            return;
        }
        UILabel *tmlb = [_xlbArr objectAtIndex:i];
        tmlb.text = [NSString stringWithFormat:@"%d",[[_xArr objectAtIndex:xindex] intValue]];
    }
    
}


@end
