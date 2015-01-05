//
//  TZMonthViewController.m
//  yxios
//
//  Created by fei on 13-11-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "TZMonthViewController.h"
#import "CarCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DateUtils.h"
#import "UIUtils.h"

@interface TZMonthViewController ()

@end

@implementation TZMonthViewController

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
    
    
    
    //数据
    _carArr = [[NSMutableArray alloc] initWithCapacity:0];
    //before month
    self.currentMonth = [DateUtils getMonth:[NSDate date]];
    self.currentYear = [DateUtils getYear:[NSDate date]];
    
    //取得上一月基础数据
    [self manBeforMothData];
    
    
    self.isSort = YES;
    
    
    _src = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44 - 48)];
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
    _lbTitle =[UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 0, 320, 40) text:[NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
    [_src addSubview:_lbTitle];
    
    //lbsum
    _lbCarQuerySum = [[UILabel alloc] initWithFrame:CGRectMake(20, _pieCarAllChart.frame.origin.y + _pieCarAllChart.frame.size.height, 200, 15)];
    _lbCarQuerySum.font = [UIFont systemFontOfSize:15];
    
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
    
    //net
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&parm=%@&timeTag=%@&timeRegion=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"tezheng",
                      @"tag3",
                      [NSString stringWithFormat:@"%d-%0d-01,%d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum]];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Analyse.php"];
    
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
     [self modelData];
    
    
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
    
    //%比计算
    float currentPercent =[[[_carArr objectAtIndex:index] objectForKey:@"vtotal"] floatValue]/self.sum*100;
    self.lbChartDetail.text = [NSString stringWithFormat:@"%2.2f%%",currentPercent];
    self.lbChartTitle.text = [[_carArr objectAtIndex:index] objectForKey:@"hname"];
    
    
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
        
        
        
        [self reloadCurrentData];
    }
    
    
    
    
}

-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}

#pragma mark - reloaddata

-(void)reloadCurrentData{
    _lbTitle.text = [NSString stringWithFormat:@"%d-%0d-01 至 %d-%d-%d",self.currentYear,self.currentMonth,self.currentYear,self.currentMonth,self.currentDaySum];
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
    
    cell.lbKey.text =   [NSString stringWithFormat:@"%d   %@",sort+1,[currentdict objectForKey:@"hname"]];
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
    self.lbChartTitle.text = [[_carArr objectAtIndex:indexPath.row] objectForKey:@"hname"];
    
    
   
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
                              @"tezheng",
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
                              @"tezheng",
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
