//
//  CarTypeWeekViewController.m
//  youxin
//
//  Created by fei on 13-9-13.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "CarTypeWeekViewController.h"
#import "CarCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DateUtils.h"
#import "UIUtils.h"
@interface CarTypeWeekViewController ()

@end

@implementation CarTypeWeekViewController

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
	
    self.isSort = YES;
    //数据
    _carArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSDate * currentDate = [NSDate date];
    
   
    [self refreshStartDateAndEndDate:currentDate];
    
   
    
    
    
    
    
    _src = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44 - 48)];
//    _src.contentSize = CGSizeMake(self.view.bounds.size.width, _src.frame.size.height);
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
    
   
    
    _lbChartTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 130, 100, 20)];
    _lbChartTitle.backgroundColor = [UIColor clearColor];
    _lbChartTitle.font = [UIFont boldSystemFontOfSize:15];
    _lbChartTitle.textAlignment = UITextAlignmentCenter;
    
    
    [self.view addSubview:_lbChartTitle];
    
    _lbChartDetail = [[UILabel alloc] initWithFrame:CGRectMake(110, 100+50, 100, 20)];
    _lbChartDetail.backgroundColor = [UIColor clearColor];
    _lbChartDetail.textAlignment = UITextAlignmentCenter;
    _lbChartDetail.font = [UIFont systemFontOfSize:17];
    
    [self.view addSubview:_lbChartDetail];
    
    _lbChartTitle.text = @"全部";
    _lbChartDetail.text = @"100%";
    

    
    //title
    _lbTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 5, 320, 30)
                                                 text:[NSString stringWithFormat:@"%@ 至 %@",
                                                       [self converDateToString:_startDate],
                                                       [self converDateToString:_endDate]]];
    
    [_src addSubview:_lbTitle];
    
    //lbsum
    _lbCarQuerySum = [[UILabel alloc] initWithFrame:CGRectMake(20, _pieCarAllChart.frame.origin.y + _pieCarAllChart.frame.size.height, 200, 15)];
    _lbCarQuerySum.font = [UIFont boldSystemFontOfSize:15];
    
    _lbCarQuerySum.textColor = [UIColor blackColor];
    _lbCarQuerySum.backgroundColor = [UIColor clearColor];
    _lbCarQuerySum.text = @"车型查询总量:0";
    [_src addSubview:_lbCarQuerySum];
    
    
    
    
    self.sliceColors =[DataUtils createColorArr];
    
    //rotate up arrow
    //    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    
    //view
    
    CarCell *cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
    cell.bgnm = CELL_BG_TITLE;
    [cell switchbg];
    cell.frame = CGRectMake(10, self.pieCarAllChart.frame.size.height + self.pieCarAllChart.frame.origin.y+63, 300, 30);
    cell.lbKey.text = @"   热词";
    cell.lbSum.text = @"查询量";
    [self.view addSubview:cell];
    
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
                      @"tag2",
                      [NSString stringWithFormat:@"%@,%@",[self converDateToString:self.startDate],[self converDateToString:self.endDate]]];
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
                            [NSString stringWithFormat:@"car%d",i],@"queryData",
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
    //if(pieChart == self.pieCarAllChart) return nil;
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
        [SVProgressHUD dismissWithSuccess:@"暂无数据" afterDelay:DELAY_SEC];
        
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
    _lbTitle.text = [NSString stringWithFormat:@"%@ 至 %@",[self converDateToString:_startDate],[self converDateToString:_endDate]];
    _lbCarQuerySum.text = [NSString stringWithFormat:@"信息查询总量:%d",self.sum];
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
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0f;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
                              @"chexin",
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
                              @"chexin",
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
