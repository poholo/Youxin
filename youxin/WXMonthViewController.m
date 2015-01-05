//
//  WXMonthViewController.m
//  youxin
//
//  Created by yuyang on 13-9-26.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WXMonthViewController.h"
#import "DateUtils.h"
#import "UIUtils.h"
#import "ViewUtils.h"

@interface WXMonthViewController ()

@end

@implementation WXMonthViewController

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
    //before month
    self.currentMonth = [DateUtils getMonth:[NSDate date]];
    self.currentYear = [DateUtils getYear:[NSDate date]];
    
    //取得上一月基础数据
    [self manBeforMothData];
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _currentShowData = [[NSMutableArray alloc] initWithCapacity:0];
    _xArr = [[NSMutableArray alloc] initWithCapacity:0];
    _yArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    //1.view
    _lbTime = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 44, 320, 30) text:@""];
    
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
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20+7,
                                                                     _lbYXSum.frame.origin.y + _lbYXSum.frame.size.height+30,
                                                                     275/17.0f*18.0f,
                                                                     self.view.bounds.size.height - 44 -44 -_lbYXSum.frame.origin.y - _lbYXSum.frame.size.height-30)];
    self.scrollview.pagingEnabled = YES;
    self.scrollview.bounces = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    _fdgcYXDis = [[FDGraphView alloc] initWithFrame:CGRectMake(0, 0, ([_xArr count]-1)*37+25, self.scrollview.bounds.size.height)
                                        xOffset:150.0f/4-0.8];

    
    //高12（两格一标注）  宽 14（两格一标注）
    
    _fdgcYXDis.dataPoints = self.currentShowData;
    //_fdgcYXDis.dataPoints = @[@0, @1, @2, @3, @4, @5, @6,@1, @2, @3, @4, @5, @6, @7,@1, @2, @3, @4, @5, @6, @7];
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
        //        tmlb.text = [NSString stringWithFormat:@"%d199",i];
        tmlb.textAlignment =UITextAlignmentRight;
        tmlb.textColor = [UIColor grayColor];
        tmlb.font = [UIFont systemFontOfSize:10];
        tmlb.backgroundColor = [UIColor clearColor];
        [self.ylbArr addObject:tmlb];
        [self.view addSubview:tmlb];
        
    }
    
    for(int i=0;i<8;i++){
        
        UILabel *tmxlb = [[UILabel alloc] initWithFrame:CGRectMake(25 + i*35,
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
    
    
    //btn
    
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
    
    
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate =self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"jike",
                      @"tag3",
                     [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
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
        self.yxSum = [dict objectForKey:@"jikeTotal"]?[[dict objectForKey:@"jikeTotal"] intValue]:0;
        self.actionSum = [dict objectForKey:@"huodongTotal"]?[[dict objectForKey:@"huodongTotal"] intValue]:0;
        self.dataArr = [dict objectForKey:@"dayData"];
        self.usedate = [dict objectForKey:@"useTime"];
        self.openDate = self.usedate;
        
        NSLog(@"%@",self.usedate);
        _maxY = 0;
        //清除数据
        [_xArr removeAllObjects];
        [_yArr removeAllObjects];
        [_currentShowData removeAllObjects];
        
        
        
        //x轴定量
        //初始值
        int currentYear = self.currentYear;
        int month = self.currentMonth;
        int startday = 0;
    
        
        //本月最大天数
        int sumOfCurrentMonth = [DateUtils getDaysOfMonth:month year:currentYear];
        int j = 0;
        int count = [self.dataArr count];
    
        //dayData处理
        if(self.dataArr==NULL){
            for(int i = 0;i<sumOfCurrentMonth;i++){
                if(startday==sumOfCurrentMonth){
                    startday = 1;
                    if(month==12){
                        month = 1;
                        currentYear ++;
                    }
                    else{
                        month++;
                    }
                }
                else{
                    startday ++;
                }
                //x
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",month,startday]];
                //y
                [_currentShowData addObject:[NSNumber numberWithInt:0]];
            }
        }
        else{

            for(int i =0;i<sumOfCurrentMonth;i++){
                if(startday==sumOfCurrentMonth){
                    startday = 1;
                    if(month==12){
                        month = 1;
                        currentYear ++;
                    }
                    else{
                        month++;
                    }
                }
                else{
                    startday ++;
                }
                //x
                [_xArr addObject:[NSString stringWithFormat:@"%d-%d",month,startday]];
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
                
                if(tmMonth == month && tmDay == startday){
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
//        _maxY = 100;
//        [_currentShowData removeAllObjects];
//        for(int i=0;i<31;i++){
//            [_currentShowData addObject:[NSNumber numberWithInt:i%10]];
//        }
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
        

        
    }
    [self refreshData];
    
    
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}

-(void)refreshData{
    _scrollview.contentOffset = CGPointMake(0, 0);
    
    self.lbYXSum.text = [NSString stringWithFormat:@"%d",self.yxSum];
    self.lbActionSum.text =[NSString stringWithFormat:@"%d",self.actionSum];
    
    float width = [_xArr count]/8*291.0f + ([_xArr count]%8!=0?291.0f:0);
    
    
    float hight = _scrollview.bounds.size.height;
    if(7>=_maxY){
        float tmHight = _maxY<=0?0.3:_maxY;
        hight = hight/6.1*tmHight;
        
    }
    else{
        hight = _scrollview.bounds.size.height;
    }
    _fdgcYXDis.frame=CGRectMake(_fdgcYXDis.frame.origin.x,
                                _scrollview.bounds.size.height-hight,
                                [_xArr count]*33,
                                hight);
    NSLog(@"%f---%f---%f---%f",_fdgcYXDis.frame.origin.x,_fdgcYXDis.frame.origin.y,_fdgcYXDis.frame.size.width,_fdgcYXDis.frame.size.height);
    
    NSLog(@"%f---%f---%f---%f",_scrollview.frame.origin.x,_scrollview.frame.origin.y,_scrollview.frame.size.width,_scrollview.frame.size.height);
    _fdgcYXDis.dataPoints =_currentShowData;
    
    _fdgcYXDis.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    
    self.scrollview.contentSize = CGSizeMake(width, self.scrollview.bounds.size.height);
    
    NSLog(@"%d",[_fdgcYXDis.dataPoints count]);
    //时间表示
    _lbTime.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
    
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
        if([_yArr count]>i){
            tmlb.text = [NSString stringWithFormat:@"%@",[self.yArr objectAtIndex:i]];
        }
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




#pragma mark - 处理int月
-(void)manBeforMothData{
    if(self.currentMonth==1){
        self.currentYear--;
        self.currentMonth =12;
    }
    else{
        self.currentMonth --;
    }
    _currentDaySum = [DateUtils getDaysOfMonth:self.currentMonth year:self.currentMonth];
}

-(void)manNextMonthData{
    if(self.currentMonth==12){
        self.currentYear++;
        self.currentMonth=1;
    }
    else{
        self.currentMonth++;
    }
    self.currentDaySum = [DateUtils getDaysOfMonth:self.currentMonth year:self.currentMonth];
}

#pragma mark -btnclick
-(void)btnClick:(id)sender{
    UIButton *btn = sender;
    switch (btn.tag) {
            
            //上一月数据
        case 0:
        {
            
            //得到上一月
            [self manBeforMothData];
            
            //检查时间范围是否超出使用日期
            int rinowYear = [DateUtils getYearFromStr:self.openDate];
            int rinowMonth = [DateUtils getMothFromStr:self.openDate];
            
            if(rinowYear>self.currentYear){
                self.btnBeforeWeek.enabled = NO;
            }
            else if(rinowYear==self.currentYear){
                if(rinowMonth>self.currentMonth){
                    self.btnBeforeWeek.enabled = NO;
                }
            }
            
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"jike",
                              @"tag3",
                              [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            //刷新title显示
            _lbTime.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
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
            //下一月数据
        case 1:{
            //检查时间范围是否高于当前月
            [self manNextMonthData];
            
            
            int rinowYear = [DateUtils getYear:[NSDate date]];
            int rinowMonth = [DateUtils getMonth:[NSDate date]];
            
            if(rinowYear<self.currentYear){
                self.btnNextWeek.enabled = NO;
            }
            else if(rinowYear==self.currentYear){
                if(rinowMonth-1==self.currentMonth){
                    self.btnNextWeek.enabled = NO;
                }
            }
            self.btnBeforeWeek.enabled = YES;
            
            
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"jike",
                              @"tag3",
                              [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            //刷新title显示
            _lbTime.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
            [_mHttpdownload downloadHomeUrl:home_url postparm:post];
            [SVProgressHUD showWithStatus:@"数据加载中"];
            
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
