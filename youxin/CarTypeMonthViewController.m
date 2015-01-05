//
//  CarTypeMonthViewController.m
//  youxin
//
//  Created by fei on 13-9-13.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "CarTypeMonthViewController.h"
#import "CarCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIUtils.h"
@interface CarTypeMonthViewController ()

@end

@implementation CarTypeMonthViewController

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
    
    _daySumOfMonthByRunYear = [[NSArray alloc] initWithObjects:@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
    _daySumOfMonthByUnRunYear = [[NSArray alloc] initWithObjects:@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
    
    //数据
    _carArr = [[NSMutableArray alloc] initWithCapacity:0];
    //before month
    self.currentMonth = [self getMonth:[NSDate date]];
    self.currentYear = [self getYear:[NSDate date]];
    self.isSort = YES;
    
    //取得上一月基础数据
    [self manBeforMothData];
    
    
    _src = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44 - 48-20)];
//    _src.contentSize = CGSizeMake(self.view.bounds.size.width, 480);
    _src.userInteractionEnabled = YES;
    [self.view addSubview:_src];
    
    _pieCarAllChart = [[XYPieChart alloc] initWithFrame:CHART_FRAME];
    [self.pieCarAllChart setDelegate:self];
    [self.pieCarAllChart setDataSource:self];
    [self.pieCarAllChart setStartPieAngle:M_PI_2];
    [self.pieCarAllChart setAnimationSpeed:1.0];
    //[self.pieCarAllChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieCarAllChart setLabelRadius:1];
    [self.pieCarAllChart setShowPercentage:YES];
    [self.pieCarAllChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //    [self.pieCarAllChart setPieCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2-self.view.bounds.size.height/4)];
    [self.pieCarAllChart setUserInteractionEnabled:YES];
    [self.pieCarAllChart setLabelShadowColor:[UIColor blackColor]];
    [_src addSubview:_pieCarAllChart];
    
    
    _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_percentageLabel.layer setCornerRadius:50];
    
    _percentageLabel.center = _pieCarAllChart.center;
    
//    _percentageLabel.text = @"全部：100%";
    _percentageLabel.backgroundColor = [UIColor whiteColor];
    _percentageLabel.textAlignment = UITextAlignmentCenter;
    [_src addSubview:_percentageLabel];
    
    
    _lbChartTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 100, 20)];
    _lbChartTitle.backgroundColor = [UIColor clearColor];
    _lbChartTitle.font = [UIFont boldSystemFontOfSize:15];
    _lbChartTitle.textAlignment = UITextAlignmentCenter;
    
    
    [_src addSubview:_lbChartTitle];
    
    _lbChartDetail = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 100, 20)];
    _lbChartDetail.backgroundColor = [UIColor clearColor];
    _lbChartDetail.textAlignment = UITextAlignmentCenter;
    _lbChartDetail.font = [UIFont systemFontOfSize:17];
    
    [_src addSubview:_lbChartDetail];
    
    _lbChartTitle.text = @"全部";
    _lbChartDetail.text = @"100%";
    
    
    //title
    _lbTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 5, 320, 30)
                                                 text:[NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",
                                                       self.currentYear,
                                                       self.currentMonth,
                                                       self.currentYear,
                                                       self.currentMonth,
                                                       self.currentDaySum]];
    [_src addSubview:_lbTitle];
    
    //lbsum
    _lbCarQuerySum = [[UILabel alloc] initWithFrame:CGRectMake(20, _pieCarAllChart.frame.origin.y + _pieCarAllChart.frame.size.height, 200, 15)];
    _lbCarQuerySum.font = [UIFont boldSystemFontOfSize:15];
    
    _lbCarQuerySum.textColor = [UIColor blackColor];
    _lbCarQuerySum.text = @"车型查询总量:0";
    [_src addSubview:_lbCarQuerySum];
    
    
    
    
    self.sliceColors =[DataUtils createColorArr];
    
    //rotate up arrow
    //    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    
    //view
    CarCell *cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
    cell.bgnm = CELL_BG_TITLE;
    [cell switchbg];
    cell.frame = CGRectMake(10, self.pieCarAllChart.frame.size.height + self.pieCarAllChart.frame.origin.y+20, 300, 30);
    cell.lbKey.text = @"   热词";
    cell.lbSum.text = @"查询量";
    [_src addSubview:cell];
    
    _tbCarSort = [[UITableView alloc] initWithFrame:CGRectMake(10, self.pieCarAllChart.frame.size.height + self.pieCarAllChart.frame.origin.y+50, 300, 115) style:UITableViewStylePlain];
    
    _tbCarSort.backgroundColor = [UIColor clearColor];
    _tbCarSort.delegate = self;
    _tbCarSort.dataSource = self;
    _tbCarSort.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tbCarSort.bounces = NO;
    [_src addSubview:_tbCarSort];

    
    
    
    //    [src addSubview:_tbCarSort];
    
    //net
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"chexing",
                      @"tag3",
                      [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    
    //btn
    _btnBeforeWeek = [[UIButton alloc] initWithFrame:CGRectMake(50, 13, 15, 15)];
    [_btnBeforeWeek setBackgroundImage:[UIImage imageNamed:@"三角-左"] forState:UIControlStateNormal];
    _btnBeforeWeek.tag = 0;
    [_btnBeforeWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_src addSubview:_btnBeforeWeek];
    
    
    _btnNextWeek = [[UIButton alloc] initWithFrame:CGRectMake(255, 13, 15, 15)];
    [_btnNextWeek setBackgroundImage:[UIImage imageNamed:@"三角-右"] forState:UIControlStateNormal];
    
    _btnNextWeek.tag = 1;
    [_btnNextWeek addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnNextWeek.enabled = NO;
    
    [_src addSubview:_btnNextWeek];
    
    [self modelData];
    
}

-(void)modelData{
    
    if (_carArr==nil) {
        _carArr = [[NSMutableArray alloc] init];
    }
    for(int i=0;i<20;i++){
        self.sum +=(i+1);
        [_carArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"car%d",i],@"hname",
                            [NSString stringWithFormat:@"%d",i+1],@"vtotal",
                            nil]];
    }
    
    [self reloadCurrentData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPieCarAllChart:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieCarAllChart reloadData];
}



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.carArr.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[[self.carArr objectAtIndex:index] objectForKey:@"vtotal"] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
//    if(pieChart == self.pieCarAllChart) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    float currentPercent =[[[_carArr objectAtIndex:index] objectForKey:@"vtotal"] floatValue]/self.sum*100;
    self.lbChartDetail.text = [NSString stringWithFormat:@"%2.2f%%",currentPercent];
    self.lbChartTitle.text = [[_carArr objectAtIndex:index] objectForKey:@"keyword"];
    
}

#pragma mark  - net
-(void)downloadComplete:(HttpDownload *)hd{
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    if(dict == NULL){
        
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
    }
    else{
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];
        self.sum = [[dict objectForKey:@"queryTotalNum"] intValue];
        NSString *tmdate = [dict objectForKey:@"useTime"];
        
        NSRange range = [tmdate rangeOfString:@" "];
        _openDate = [tmdate substringToIndex:range.location];
        
        _carArr = [dict objectForKey:@"queryData"];
       
    }
    [self reloadCurrentData];
    
    
}

-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}

#pragma mark - reloaddata

-(void)reloadCurrentData{
    //_lbTitle.text = [NSString stringWithFormat:@"%@ 至 %@",[self converDateToString:_startDate],[self converDateToString:_endDate]];
    _lbCarQuerySum.text = [NSString stringWithFormat:@"车型查询总量:%d",self.sum];
    
    [self.tbCarSort reloadData];
    [self.pieCarAllChart reloadData];
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_carArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    NSDictionary *currentdict  =  nil;
    int sort = 0;
    //正序
    if(self.isSort){
        sort = indexPath.row;
    }
    //倒叙
    else {
        sort = [_carArr count]-indexPath.row-1;
        
        
    }
    currentdict = [_carArr objectAtIndex:sort];
    
    cell.lbKey.text =   [NSString stringWithFormat:@"%d   %@",sort+1,[currentdict objectForKey:@"keyword"]];
    cell.lbSum.text = [currentdict objectForKey:@"vtotal"];
    
    if(indexPath.row%2!=0){
        cell.bgnm=CELL_BG_WHITE;
    }
    else{
        cell.bgnm=CELL_BG_GRAY;
    }
    
    [cell switchbg];
    return cell;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(self.beforeselectindexpath!=nil){
    //        [_pieCarAllChart setSliceDeselectedAtIndex:self.beforeselectindexpath.row];
    //    }
    //    if(self.beforeSelectAsChartDid>=0){
    //        [_pieCarAllChart setSliceDeselectedAtIndex:self.beforeSelectAsChartDid];
    //        self.beforeSelectAsChartDid = -99;
    //    }
    //
    if(_pieCarAllChart.selectedSliceIndex>=0){
        [_pieCarAllChart setSliceDeselectedAtIndex:[_pieCarAllChart selectedSliceIndex]];
    }
    [_pieCarAllChart setSliceSelectedAtIndex:indexPath.row];
    _pieCarAllChart.selectedSliceIndex = indexPath.row;
    
    
    //%比计算
    float currentPercent =[[[_carArr objectAtIndex:indexPath.row] objectForKey:@"vtotal"] floatValue]/self.sum*100;
    self.lbChartDetail.text = [NSString stringWithFormat:@"%2.2f%%",currentPercent];
    self.lbChartTitle.text = [[_carArr objectAtIndex:indexPath.row] objectForKey:@"keyword"];
}

-(NSDate *)dateStartOfMonth:(NSDate *)date {
    
    
    return nil;
}
#pragma mark - 处理当前年月得到月份 - 一个月多少天
-(int)getYear:(NSDate*)date{
    NSString *tmStr = [date description];
    
    NSString *currentYear = [tmStr substringToIndex:4];
    
    return [currentYear intValue];
}

-(int)getYearFromStr:(NSString*)datestr{
    return [[datestr substringToIndex:4] intValue];
}
-(int)getMonth:(NSDate*)date{
    NSString *tmStr = [date description];
    NSRange range = [tmStr rangeOfString:@" "];
    NSString *endDateStr = [tmStr substringToIndex:range.location];
    
    range = [endDateStr rangeOfString:@"-"];
    NSString *tmMonth = [endDateStr substringFromIndex:range.location+1];
    NSString *currentMonth = [tmMonth substringToIndex:2];
    
    return [currentMonth intValue];
    
    
}

-(int)getMothFromStr:(NSString*)datestr{
    NSRange range = [datestr rangeOfString:@"-"];
    NSString *tmMonth = [datestr substringFromIndex:range.location+1];
    NSString *currentMonth = [tmMonth substringToIndex:2];
    
    return [currentMonth intValue];
}

-(int)getDaysOfMonth:(int)month{
    if(self.currentYear%4==0||(self.currentYear%100==0&&self.currentYear%4==0)){
        return [[self.daySumOfMonthByRunYear objectAtIndex:month-1] intValue];
    }
    else{
        return [[self.daySumOfMonthByUnRunYear objectAtIndex:month-1] intValue];
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
    self.currentDaySum = [self getDaysOfMonth:self.currentMonth];
}

-(void)manNextMonthData{
    if(self.currentMonth==12){
        self.currentYear++;
        self.currentMonth=1;
    }
    else{
        self.currentMonth++;
    }
    self.currentDaySum = [self getDaysOfMonth:self.currentMonth];
}



-(NSString*)converDateToString:(NSDate*)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  dateStr=[dateformatter stringFromDate:date];
    
    NSLog(@"convert:%@",dateStr);
    return dateStr;
    
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
            int rinowYear = [self getYearFromStr:self.openDate];
            int rinowMonth = [self getMothFromStr:self.openDate];
            
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
                              @"chexing",
                              @"tag3",
                              [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            //刷新title显示
            _lbTitle.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
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
            
            
            int rinowYear = [self getYear:[NSDate date]];
            int rinowMonth = [self getMonth:[NSDate date]];
            
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
                              @"chexing",
                              @"tag3",
                              [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
            NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
            
            //刷新title显示
            _lbTitle.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
            [_mHttpdownload downloadHomeUrl:home_url postparm:post];
            [SVProgressHUD showWithStatus:@"数据加载中"];
            
        }
            break;
        case 11:{
            self.isSort = !self.isSort;
            [_tbCarSort reloadData];
        }
            break;
        default:
            break;
    }
}

@end
