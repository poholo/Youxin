//
//  DDMonthViewController.m
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "DDMonthViewController.h"
#import "UIUtils.h"

#import "AlertUtils.h"
#import "DateUtils.h"
#import "ViewUtils.h"

@interface DDMonthViewController ()

@end

@implementation DDMonthViewController

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
    _fgvCancel = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds xOffset:150.0f/4-0.3];
    _fgvNewAdd = [[FDGraphviewNoCenterPointer alloc] initWithFrame:_srcvw.bounds xOffset:150.0f/4-0.3];
    
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
    
    //btn before nonth , next month
    _btnBefore = [[UIButton alloc] initWithFrame:CGRectMake(35, 40, 35, 35)];
    [_btnBefore setBackgroundImage:[UIImage imageNamed:@"btn_left_normal"] forState:UIControlStateNormal];
    [_btnBefore setBackgroundImage:[UIImage imageNamed:@"btn_left_highted"] forState:UIControlStateHighlighted];
    _btnBefore.tag = 0;
    [_btnBefore addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBefore];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(250, 40, 35, 35)];
    [_btnNext setBackgroundImage:[UIImage imageNamed:@"btn_right_normal"] forState:UIControlStateNormal];
    [_btnNext setBackgroundImage:[UIImage imageNamed:@"btn_right_highted"] forState:UIControlStateHighlighted];
    _btnNext.tag = 1;
    [_btnNext addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.enabled = NO;
    [self.view addSubview:_btnNext];
    
    [self.view addSubview:[ViewUtils createDataBoard]];
    
}

#pragma mark - 数据初始化

-(void)initBasicData{
    self.currentMonth = [DateUtils getMonth:[NSDate date]];
    self.currentYear = [DateUtils getYear:[NSDate date]];
    self.currentDaySum = [DateUtils getDaysOfMonth:self.currentMonth year:self.currentYear];
    
    //取得上一月基础数据
    [self manBeforMothData];
    
    
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"yuyue",
                      @"tag3",
                      [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
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
        
        self.openDate = [dict objectForKey:@"useTime"];
        self.useDate = [dict objectForKey:@"useTime"];
        
        self.allSum = [[dict objectForKey:@"yyTotal"] intValue];
        self.addSum = [[dict objectForKey:@"yyConfirmTotal"] intValue];
        self.cancelSum = [[dict objectForKey:@"yyingoreTotal"] intValue];
        
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
        
        
        
        
        //x轴定量
        //初始值
        _maxYAll = [self manLineAllMonthDataType:0];
        _maxYAdd = [self manLineAllMonthDataType:1];
        _maxYCancel = [self manLineAllMonthDataType:2];
        
        _maxY =(_maxYAll>_maxYAdd?_maxYAll:_maxYAdd)>_maxYCancel?(_maxYAll>_maxYAdd?_maxYAll:_maxYAdd):_maxYCancel;
        
        
        for(int i = 1;i<=self.currentDaySum;i++){
            //x
            [_xArr addObject:[NSString stringWithFormat:@"%d-%d",self.currentMonth,i]];
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
        
        NSLog(@"line1Arr%@",self.currentShowLine1Arr);
        NSLog(@"line2Arr%@",self.currentShowLine2Arr);
        NSLog(@"line3Arr%@",self.currentShowLine3Arr);
    
    NSLog(@"%d---%d--%d",_maxYAll,_maxYAdd,_maxYCancel);
    }
    //按天  按周  按月
    
    
    //框架数据刷新
    [self refreshFrameData];
}

#pragma mark - 处理一条线一个月的数据
-(int)manLineAllMonthDataType:(int)type{
    NSMutableArray *tmArr= nil ;
    NSArray *fromArr = nil;
    int maxY =0;
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
    
    if(tmArr==NULL){
        for(int i = 1;i<=self.currentDaySum;i++){
            //y
            [tmArr addObject:[NSNumber numberWithInt:0]];
        }
    }
    else{
        int j=0;
        for(int i =1;i<=self.currentDaySum;i++){
            //y
            //得到当前y数据
            NSDictionary *tmdic;
            NSDate *tmDate;
            //得到x轴数据
            int tmMonth;
            int tmDay;
            
            int count = [fromArr count];
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
            
            if(tmMonth == self.currentMonth && tmDay == i){
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
    return maxY;
}

-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}


#pragma mark - refreshFrameData
-(void)refreshFrameData{
    _srcvw.contentOffset = CGPointZero;
    _lbTime.text = [NSString stringWithFormat:
                    @"%d-%0d-01 至 %d-%d-%d",
                    self.currentYear,
                    self.currentMonth,
                    self.currentYear,
                    self.currentMonth,
                    self.currentDaySum];
    
    _lbAllSum.text = [NSString stringWithFormat:@"%d",self.allSum];
    _lbAddnewSum.text = [NSString stringWithFormat:@"%d",self.addSum];
    _lbCancelSum.text = [NSString stringWithFormat:@"%d",self.cancelSum];
    
    //src
    float width = [self getSRCWidth];
    _srcvw.contentSize = CGSizeMake(width, _srcvw.bounds.size.height);
    
    NSLog(@"%f---%f--%d",_srcvw.contentSize.width,_srcvw.contentSize.height,[_xArr count]);
   
    
    
    _fgvSum.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_select"]];
    _fgvNewAdd.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color2"]];
    _fgvCancel.linesColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color3"]];
    
    
    float xsplit = 35.5;
    float line1Height = [self getFDVHeightByMaxY:_maxYAll];
    float line2Height = [self getFDVHeightByMaxY:_maxYAdd];
    float line3Height = [self getFDVHeightByMaxY:_maxYCancel];
    
    //line
    self.fgvSum.dataPoints = self.currentShowLine1Arr;
    self.fgvSum.frame = CGRectMake(0,
                                   _srcvw.bounds.size.height-line1Height,
                                   xsplit*[_currentShowLine1Arr count],
                                   line1Height);
    self.fgvNewAdd.dataPoints = self.currentShowLine2Arr;
    
    self.fgvNewAdd.frame = CGRectMake(0, _srcvw.bounds.size.height - line2Height,
                                      xsplit*[_currentShowLine2Arr count],
                                      line2Height);
    self.fgvCancel.dataPoints = self.currentShowLine3Arr;
    self.fgvCancel.frame = CGRectMake(0, _srcvw.bounds.size.height - line3Height,
                                      xsplit*[_currentShowLine3Arr count],
                                      line3Height);
    
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
                self.btnBefore.enabled = NO;
            }
            else if(rinowYear==self.currentYear){
                if(rinowMonth>self.currentMonth){
                    self.btnBefore.enabled = NO;
                }
            }
            
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"yuyue",
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
            self.btnNext.enabled = YES;
            
            
            
            
        }
            break;
            //下一月数据
        case 1:{
            //检查时间范围是否高于当前月
            [self manNextMonthData];
            
            
            int rinowYear = [DateUtils getYear:[NSDate date]];
            int rinowMonth = [DateUtils getMonth:[NSDate date]];
            
            if(rinowYear<self.currentYear){
                self.btnNext.enabled = NO;
            }
            else if(rinowYear==self.currentYear){
                if(rinowMonth-1==self.currentMonth){
                    self.btnNext.enabled = NO;
                }
            }
            self.btnBefore.enabled = YES;
            
            
            NSString *post = [NSString stringWithFormat:
                              @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                              @"yuyue",
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


@end
