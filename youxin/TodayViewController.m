//
//  TodayViewController.m
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "TodayViewController.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

#import "InfoModel.h"

#import "UIUtils.h"
@interface TodayViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}



@end

@implementation TodayViewController

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
    _tbToday = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44 - 49)];
    _tbToday.delegate = self;
    _tbToday.dataSource = self;
    
    _tbToday.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbToday.allowsSelection = NO;
    _tbToday.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tbToday];
    
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _tbToday;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _tbToday;
    
    // 假数据
    //_data = [NSMutableArray array];
    _infoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    _infoArr  = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initBasicData];
    //net
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    NSString *post = [NSString stringWithFormat:
                      @"iosName=%@&skey=%@&page=%@&parm=%@&timeTag=%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm" ],
                       [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                       @"1",
                       @"done",
                       @"tag1"];
    
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
    self.requestType = REQUEST_FIRST;
    
    
    NSLog(@"%@",home_url);
    NSLog(@"%@",post);
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    self.nextPage =2;
    
    
    //no info
    _imgvwNoInfo = [UIUtils createNoInfo];
    [self.view addSubview:_imgvwNoInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据
-(void)initBasicData{
    
    for(int i = 0; i<10; i++){
        InfoModel *info = [[InfoModel alloc] initWithIdentify:[NSString stringWithFormat:@"%d",i] publishtTime:@"09-17 09:09" operationStatus:STATUS_DEFANUT phoneno:@"18950183445" sosnm:@"张小杰" coordinate:CLLocationCoordinate2DMake(23.134844f, 113.317290f)];
        [_infoArr addObject:[NSString stringWithFormat:@"%d",i]];
        [_infoDic setObject:info forKey:[_infoArr objectAtIndex:i]];
        
        [_tbToday reloadData];
        
    }
}


#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int sum = [_infoArr count];
    if(sum==0){
        _imgvwNoInfo.alpha = 0;
        [UIView animateWithDuration:2 animations:^{
            _imgvwNoInfo.alpha = 1.0f;
            _imgvwNoInfo.hidden = NO;
        }];
    }
    else{
        _imgvwNoInfo.hidden =YES;
    }
    return sum;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" btnno:0 taget:self sel:@selector(cellBtnClick:)];
    }
    InfoModel *model = [_infoDic objectForKey:[_infoArr objectAtIndex:indexPath.row]];
    
    cell.identify = model.identify;
    
    cell.lbTime.text = model.publishTime;
    
    cell.lbnm.text = model.sosNm;
    
    cell.lbPhoneno.text = model.phoneno;
    cell.indexpath = indexPath;
    
    cell.lbStatus.text = STATUS_CONFIRMED;
    cell.lbStatus.textColor = COLOR_CONFIRM;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

-(void)cellBtnClick:(UIButton*)btn{
    NSLog(@"cellbtn%d",btn.tag);
    
    NSLog(@"%@",[self.currentInfoCell subviews]);
    self.currentInfoCell = (InfoCell*)[btn superview];
    
    
    NSLog(@"%@",[btn superview]);
    switch (btn.tag) {
            //呼叫
        case 0:
        {
            NSString *number = self.currentInfoCell.lbPhoneno.text;// 此处读入电话号码
            
            // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
            
            
            
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:[NSString stringWithFormat:@"您确定要拨打电话%@吗?",self.currentInfoCell.lbPhoneno.text]
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            [alertview show];
        }
            break;
                default:
            break;
    }
}


#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(refreshView==_header){
        NSString *post = [NSString stringWithFormat:
                          @"iosName=%@&skey=%@&page=%@&parm=%@&timeTag=%@",
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm" ],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                          @"1",
                          @"done",
                          @"tag1"];
        NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Oreder.php"];
        self.requestType = REQUEST_NO1;
        [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    }
    else{
        NSString *post = [NSString stringWithFormat:
                          @"iosName=%@&skey=%@&page=%@&parm=%@&timeTag=%@",
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm" ],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                          [NSString stringWithFormat:@"%d",self.nextPage],
                          @"done",
                          @"tag1"];
        
        NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
        
        self.requestType = REQUEST_NEXT;
        [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    }
}


#pragma mark 提示框操作
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"alert btn.tag - %d",buttonIndex);
    switch (buttonIndex) {
            //cancel
        case 0:
        {
            
        }
            break;
            //拨号
        case 1:{
            
            //需要适配
            NSString *number = self.currentInfoCell.lbPhoneno.text;// 此处读入电话号码
            
            // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
            
            
            
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
            
        }
            break;
            
        default:
            break;
    }
}


#pragma MARK - httpdownload

-(void)downloadComplete:(HttpDownload *)hd{
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%d",hd.mData.length);
    NSLog(@"%@",arr);
    [_header endRefreshing];
    [_footer endRefreshing];
    if(arr == NULL){
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
        return;
    }
    else{
        
        switch (self.requestType) {
            case REQUEST_FIRST:
            {
                for(NSDictionary *dict in arr){
                    NSString *identify = [dict objectForKey:@"0"];
                    NSString *publishtime = [dict objectForKey:@"sosTime"];
                    NSString *status = [dict objectForKey:@"status"];
                    NSString *sosTel = [dict objectForKey:@"sosTel"];
                    NSString *sosName = [dict objectForKey:@"sosName"];
                    InfoModel *model = [[InfoModel alloc] initWithIdentify:identify publishtTime:publishtime operationStatus:status phoneno:sosTel sosnm:sosName coordinate:CLLocationCoordinate2DMake(0, 0)];
                    [_infoArr  addObject:identify];
                    [_infoDic setObject:model forKey:identify];
                }
            }
                break;
            case REQUEST_NO1:{
                for(NSDictionary *dict in arr){
                    NSString *identify = [dict objectForKey:@"0"];
                    NSString *publishtime = [dict objectForKey:@"sosTime"];
                    NSString *status = [dict objectForKey:@"status"];
                    NSString *sosTel = [dict objectForKey:@"sosTel"];
                    NSString *sosName = [dict objectForKey:@"sosName"];
                    //获取到的新数据和数组头条一样，放弃加载。
                    BOOL isHave = NO;
                    for(NSString *tmidentify in _infoArr){
                        if([identify isEqualToString:tmidentify]){
                            isHave =YES;
                            break;
                        }
                    }
                    if(isHave){
                        break;
                    }
                    InfoModel *model = [[InfoModel alloc] initWithIdentify:identify publishtTime:publishtime operationStatus:status phoneno:sosTel sosnm:sosName coordinate:CLLocationCoordinate2DMake(0, 0)];
                    [_infoArr insertObject:identify atIndex:0];
                    [_infoDic setObject:model forKey:identify];
                    [_header endRefreshing];
                    
                }
            }
                break;
            case REQUEST_NEXT:{
                for(NSDictionary *dict in arr){
                    NSString *identify = [dict objectForKey:@"0"];
                    NSString *publishtime = [dict objectForKey:@"sosTime"];
                    NSString *status = [dict objectForKey:@"status"];
                    NSString *sosTel = [dict objectForKey:@"sosTel"];
                    NSString *sosName = [dict objectForKey:@"sosName"];
                    BOOL isHave = NO;
                    for(NSString *tmidentify in _infoArr){
                        if([identify isEqualToString:tmidentify]){
                            isHave =YES;
                            break;
                        }
                    }
                    if(isHave){
                        break;
                    }
                    InfoModel *model = [[InfoModel alloc] initWithIdentify:identify publishtTime:publishtime operationStatus:status phoneno:sosTel sosnm:sosName coordinate:CLLocationCoordinate2DMake(0, 0)];
                    [_infoArr  addObject:identify];
                    [_infoDic setObject:model forKey:identify];
                    
                    [_footer endRefreshing];
                }
                self.nextPage ++;
            }
                break;
            default:
                break;
        }
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];
    }
    [_tbToday reloadData];
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}

@end
