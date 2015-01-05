
//
//  WFWeekViewController.m
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WFWeekViewController.h"
#import "UIUtils.h"

#import "AlertUtils.h"
#import "DateUtils.h"

@interface WFWeekViewController ()

@end

@implementation WFWeekViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                                 text:@"累积关注量"];
    rect = _lbAlltt.frame;
    _lbAllSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(rect.origin.x,
                                                                rect.origin.y + rect.size.height,
                                                                rect.size.width,
                                                                rect.size.height) text:@"0"];
    
    _lbAddNewtt = [UIUtils createDataTitleLabelWithFrame:CGRectMake(rect.origin.x+rect.size.width,
                                                                    rect.origin.y,
                                                                    rect.size.width,
                                                                    rect.size.height) text:@"新增关注量"];
    rect = _lbAddNewtt.frame;
    
    _lbAddnewSum = [UIUtils createDataSumLabelWithFrame:CGRectMake(rect.origin.x,
                                                                   rect.origin.y + rect.size.height,
                                                                   rect.size.width,
                                                                   rect.size.height) text:@"0"];
    
    
    _lbCanceltt = [UIUtils createDataTitleLabelWithFrame:CGRectMake(rect.origin.x + rect.size.width,
                                                                    rect.origin.y,
                                                                    rect.size.width,
                                                                    rect.size.height) text:@"取消关注量"];
    
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
    
    
    _fgvSum = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds];
    _fgvCancel = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds];
    _fgvNewAdd = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds];
    
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
    
    //btn before week , next week
    _btnBeforeWeek = [[UIButton alloc] initWithFrame:CGRectMake(35, 40, 35, 35)];
    [_btnBeforeWeek setBackgroundImage:[UIImage imageNamed:@"btn_left_normal"] forState:UIControlStateNormal];
    [_btnBeforeWeek setBackgroundImage:[UIImage imageNamed:@"btn_left_highted"] forState:UIControlStateHighlighted];
    _btnBeforeWeek.tag = 0;
    [_btnBeforeWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBeforeWeek];
    
    _btnNextWeek = [[UIButton alloc] initWithFrame:CGRectMake(250, 40, 35, 35)];
    [_btnNextWeek setBackgroundImage:[UIImage imageNamed:@"btn_right_normal"] forState:UIControlStateNormal];
    [_btnNextWeek setBackgroundImage:[UIImage imageNamed:@"btn_right_highted"] forState:UIControlStateHighlighted];
    _btnNextWeek.tag = 1;
    [_btnNextWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnNextWeek.enabled = NO;
    [self.view addSubview:_btnNextWeek];
    
}

#pragma mark - 数据初始化

-(void)initBasicData{
    
     [self refreshStartDateAndEndDate:[NSDate date]];
    
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"fensi",
                      @"tag2",
                      [NSString stringWithFormat:@"%@,%@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    
    _xArr = [[NSMutableArray alloc] initWithCapacity:0];
    _yArr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine1Arr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine2Arr = [[NSMutableArray alloc] initWithCapacity:0];
    _currentShowLine3Arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
}


#pragma mark - httpdownloaddelegate
-(void)downloadComplete:(HttpDownload *)hd{
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:&e];
    NSLog(@"%@",dict);
    
    
    if(dict==NULL||e){
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
    }
    else{
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];

        NSLog(@"%@",[dict objectForKey:@"qxTotal"]);
        self.useDate = [dict objectForKey:@"useTime"];
        self.allSum = [dict objectForKey:@"ljTotal"]==NULL?0:[[dict objectForKey:@"ljTotal"] intValue];
        self.cancelSum = [dict objectForKey:@"qxTotal"]==NULL?0:[[dict objectForKey:@"qxTotal"] intValue];
        self.addSum = [dict objectForKey:@"xzTotal"]==NULL?0:[[dict objectForKey:@"xzTotal"] intValue];
        self.openDate = [dict objectForKey:@"useTime"];
        self.allArr = [dict objectForKey:@"dayData1"];
        self.addArr = [dict objectForKey:@"dayData2"];
        self.cancelArr = [dict objectForKey:@"dayData3"];
        
        
        _maxYAll = 0;
        _maxYAdd = 0;
        _maxYCancel = 0;
        //清除数据
        [_xArr removeAllObjects];
        [_yArr removeAllObjects];
        [_currentShowLine1Arr removeAllObjects];
        [_currentShowLine2Arr removeAllObjects];
        [_currentShowLine3Arr removeAllObjects];
        
        
        
        _fromYear = [DateUtils getYear:self.useDate];
        _fromMonth = [DateUtils getMonth:self.useDate];
        _fromDay = [DateUtils getDay:self.useDate];
        
        
        _nowYear = [DateUtils getYear:[NSDate date]];
        _nowMonth = [DateUtils getMonth:[NSDate date]];
        _nowDay = [DateUtils getDay:[NSDate date]];
        
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
        NSLog(@"line2%@",_currentShowLine2Arr);
        NSLog(@"line3%@",_currentShowLine3Arr);
        
        
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
    
    //得到
    //dayData处理
    int currentYear = [DateUtils getYear:self.startDate];
    int month = [DateUtils getMonth:self.startDate];
    int currentday = [DateUtils getDay:self.startDate];
    
    //本月最大天数
    int sumOfCurrentMonth = [DateUtils getDaysOfMonth:month year:currentYear];
    int j = 0;
    int count = [fromArr count];
    [_xArr removeAllObjects];
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
            tmdic = [fromArr objectAtIndex:j];
            tmDate = [tmdic objectForKey:@"dayTime"];
            //得到x轴数据
            tmMonth = [DateUtils getMonth:tmDate];
            tmDay = [DateUtils getDay:tmDate];
            
            
        }
        
        if(tmMonth == month && tmDay == currentday){
            int y = [[tmdic objectForKey:@"dayTotal"] intValue]<0?0:[[tmdic objectForKey:@"dayTotal"] intValue];
            [tmArr addObject:[NSNumber numberWithInt:y]];
            maxY = maxY >y ? maxY:y;
            
            j++;
            
        }
        else{
            int y = 0;
            [tmArr addObject:[NSNumber numberWithInt:y]];
        }
        
        
    }
    
    return maxY;
}


#pragma mark - refreshFrameData
-(void)refreshFrameData{
    _lbTime.text = [NSString stringWithFormat:@"%@ 至 %@",
                    [self converDateToString:_startDate],[self converDateToString:_endDate]];
    
    _lbAllSum.text = [NSString stringWithFormat:@"%d",self.allSum];
    _lbAddnewSum.text = [NSString stringWithFormat:@"%d",self.addSum];
    _lbCancelSum.text = [NSString stringWithFormat:@"%d",self.cancelSum];
    
    //src
    float width = [_xArr count]/8*291.0f + ([_xArr count]%8!=0?291.0f:0);
    _srcvw.contentSize = CGSizeMake(width, _srcvw.bounds.size.height);
    
    NSLog(@"%f---%f--%d",_srcvw.contentSize.width,_srcvw.contentSize.height,[_xArr count]);
    //line
    self.fgvSum.dataPoints = self.currentShowLine1Arr;
    
    CGRect rect = self.fgvSum.frame;
    
    _fgvSum.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    _fgvNewAdd.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color2"]];
    _fgvCancel.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color3"]];
    
    float xsplit = 34;
    float line1Height = [self getFDVHeightByMaxY:_maxYAll];
    float line2Height = [self getFDVHeightByMaxY:_maxYAdd];
    float line3Height = [self getFDVHeightByMaxY:_maxYCancel];
    
    self.fgvSum.dataPoints = self.currentShowLine1Arr;
    self.fgvSum.frame = CGRectMake(0,
                                   _srcvw.bounds.size.height-line1Height-1.5,
                                   xsplit*[_currentShowLine1Arr count],
                                   line1Height);
    self.fgvNewAdd.dataPoints = self.currentShowLine2Arr;
    
    self.fgvNewAdd.frame = CGRectMake(0, _srcvw.bounds.size.height - line2Height-1.5,
                                      xsplit*[_currentShowLine2Arr count],
                                      line2Height);
    self.fgvCancel.dataPoints = self.currentShowLine3Arr;
    NSLog(@"frame-------%f,%f,%f,%f,",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    self.fgvCancel.frame = CGRectMake(0, _srcvw.bounds.size.height - line3Height,
                                      xsplit*[_currentShowLine3Arr count],
                                      line3Height);

    //x
    [self reloadx];
    NSLog(@"%d",[_xArr count]);
    
    //y
    [self reloady];
    
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
            hight = (float)self.srcvw.bounds.size.height/_maxY*tmMaxY;
        }
    }
    if(hight<10){
        hight =10;
    }
    return hight;
}


#pragma mark - reloadX
-(void)reloadx{
    [self clearX];
    for(int i=0;i<8;i++){
        UILabel *tmlb = [self.xlbArr objectAtIndex:i];
        if(i==[_xArr count]){
            return;
        }
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


#pragma mark - 处理数据
-(void)manDataToShowData{
    int count = [self.allArr count];
    NSLog(@"%d --- %d -- %d",[self.allArr count],[self.addArr count],[self.cancelArr count]);
    [_currentShowLine1Arr removeAllObjects];
    [_currentShowLine2Arr removeAllObjects];
    [_currentShowLine3Arr removeAllObjects];
    
    [_xArr removeAllObjects];
    [_yArr removeAllObjects];
    if(count<=30){
        //by day
        int maxY = 0;
        for(int i=0;i<count;i++){
            int line1 = [[[_allArr objectAtIndex:i] objectForKey:@"dayTotal"] intValue];
            
            [_currentShowLine1Arr addObject:[NSNumber numberWithInt:line1]];
            
            //x 轴处理
            int x = [DateUtils getDay:[[_allArr objectAtIndex:i] objectForKey:@"dayTime"]];
            [_xArr addObject:[NSNumber numberWithInt:x]];
            
            //y
            maxY = maxY>line1?maxY:line1;
            
        }
        //
        for(int i=0;i<[_addArr count];i++){
            
            int line2 = [[[_addArr objectAtIndex:i] objectForKey:@"dayTotal"] intValue];
            
            [_currentShowLine2Arr addObject:[NSNumber numberWithInt:line2]];
            
        }
        for(int i=0;i<[_cancelArr count];i++){
            
            int line3 = [[[_cancelArr objectAtIndex:i] objectForKey:@"dayTotal"] intValue];
            
            [_currentShowLine3Arr addObject:[NSNumber numberWithInt:line3]];
            
        }
        
        
        //y 轴处理
        //Y轴定量
        for(int i=0;i<7;i++){
            [_yArr addObject:[NSNumber numberWithInt:maxY*i/6]];
        }
        
    }
    else if(count<=90){
        //by week
    }
    else{
        //by month
    }
}

#pragma mark - scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //x轴换坐标
    NSLog(@"%f",scrollView.contentOffset.x);
    float x = scrollView.contentOffset.x;
    int split = (int)x/288.0f;
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
                              @"fensi",
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
                              @"fensi",
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

#pragma mark - 时间控制
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
@end
