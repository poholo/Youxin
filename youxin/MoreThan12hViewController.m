
//
//  MoreThan12hViewController.m
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "MoreThan12hViewController.h"
#import "InfoCell.h"

#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "InfoModel.h"
#import "UIUtils.h"

@interface MoreThan12hViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation MoreThan12hViewController

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
    _tbMoreThan12h = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44 - 49)];
    _tbMoreThan12h.delegate = self;
    _tbMoreThan12h.dataSource = self;
    
    _tbMoreThan12h.allowsSelection = NO;
    _tbMoreThan12h.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tbMoreThan12h.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tbMoreThan12h];
    
    
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _tbMoreThan12h;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _tbMoreThan12h;
    
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
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                      @"1",
                      @"wait",
                      @"tag2"];
    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
    
    NSLog(@"%@    %@",home_url,post);
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    self.requestType = REQUEST_FIRST;
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    //0.1下一页页码
    self.nextPage = 2;
    
    //noinfo montion
    
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
        
        [_tbMoreThan12h reloadData];
        
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
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" btnno:2 taget:self sel:@selector(cellBtnClick:)];
    }
    InfoModel *model = [_infoDic objectForKey:[_infoArr objectAtIndex:indexPath.row]];
    
    cell.identify = model.identify;
    
    cell.lbTime.text = model.publishTime;
    
    cell.lbnm.text = model.sosNm;
    
    cell.lbPhoneno.text = model.phoneno;
    cell.indexpath = indexPath;
    
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
            //忽略
        case 1:{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"忽略原因-电话未通",@"忽略愿意-放弃预约", nil];
            actionsheet.tag = 1;
            actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
            //确认
        case 2:{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
            actionsheet.tag = 2;
            actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        default:
            break;
    }
}


#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        NSString *post = [NSString stringWithFormat:
                          @"iosName=%@&skey=%@&page=%@&parm=%@&timeTag=%@",
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                          @"1",
                          @"wait",
                          @"tag2"];
        NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
        [_mHttpdownload downloadHomeUrl:home_url postparm:post];
        self.requestType = REQUEST_NO1;
        
    } else {
        NSString *post = [NSString stringWithFormat:
                          @"iosName=%@&skey=%@&page=%@&parm=%@&timeTag=%@",
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                          [NSString stringWithFormat:@"%d",self.nextPage],
                          @"wait",
                          @"tag2"];
        //请求完成再++
        NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
        self.requestType = REQUEST_NEXT;
        
        NSLog(@"%@    %@",home_url,post);
        
        [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    }
}


#pragma mark  操作表响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"actionbtntag%d",buttonIndex);
    switch (actionSheet.tag) {
            //放弃
        case 1:
        {
            switch (buttonIndex) {
                case 0:
                {
                    //电话未通
                    //根据id修改网络状态，从待处理列表中删除
                    //                    self.currentInfoCell.identify
                    NSString *post = [NSString stringWithFormat:
                                      @"iosName=%@&skey=%@&id=%@&parm=%@&ignoreCase=%@",
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                      self.currentInfoCell.identify,
                                      @"doneIgnore",
                                      @"1"];
                    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
                    self.requestType = REQUEST_IGNORE_UNCALLED;
                    
                    
                    NSLog(@"%@-%@",post,home_url);
                    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
                    
                }
                    break;
                case 1:{
                    //放弃预约
                    NSString *post = [NSString stringWithFormat:
                                      @"iosName=%@&skey=%@&id=%@&parm=%@&ignoreCase=%@",
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                      self.currentInfoCell.identify,
                                      @"doneIgnore",
                                      @"2"];
                    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
                    self.requestType = REQUEST_IGNORE_ABANEN;
                    
                    
                    NSLog(@"%@-%@",post,home_url);
                    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
                    
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            //确认
        case 2:{
            switch (buttonIndex) {
                case 0:
                {
                    //确认
                    NSString *post = [NSString stringWithFormat:
                                      @"iosName=%@&skey=%@&id=%@&parm=%@",
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                      self.currentInfoCell.identify,
                                      @"doneConfirm"];
                    NSString *home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
                    self.requestType = REQUEST_CONFIRM;
                    
                    
                    NSLog(@"%@-%@",post,home_url);
                    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
                }
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
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


#pragma mark -roloadData
-(void)reloadTableCellinfo{
    
    [_infoArr removeObject:self.currentInfoCell.identify];
    [_infoDic removeObjectForKey:self.currentInfoCell.identify];
    
    
    [_tbMoreThan12h deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentInfoCell.indexpath] withRowAnimation:UITableViewRowAnimationTop];
    
    [_tbMoreThan12h reloadData];
}

#pragma mark - download complete
-(void)downloadComplete:(HttpDownload *)hd{
    NSLog(@"hd.mdata.length %d",hd.mData.length);
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",arr);
    [_footer endRefreshing];
    [_header endRefreshing];
    if(arr == NULL){
        [SVProgressHUD dismissWithError:@"暂无数据" afterDelay:DELAY_SEC];
        return;
    }
    else{
    
        switch (self.requestType) {
            case REQUEST_FIRST:
            {
                for(NSDictionary *dict in arr){
                    NSString *identify = [dict objectForKey:@"id"];
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
                    NSString *identify = [dict objectForKey:@"id"];
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
                    NSString *identify = [dict objectForKey:@"id"];
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
                //确认处理
            case REQUEST_CONFIRM:{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dict);
                int status = [[dict objectForKey:@"status"] intValue];
                if(status == 1){
                    [self reloadTableCellinfo];
                }
                else{
                    UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"处理失败，可能是网络原因，请重复处理，联系管理员！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alervw show];
                }
            }
                break;
                
                //忽略处理 - 电话未通
            case REQUEST_IGNORE_UNCALLED:{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
                int status = [[dict objectForKey:@"status"] intValue];
                if(status == 1){
                    [self reloadTableCellinfo];
                }
                else{
                    UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"处理失败，可能是网络原因，请重复处理，联系管理员！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alervw show];
                }
            }
                break;
                //忽略处理 - 放弃
            case REQUEST_IGNORE_ABANEN:{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
                int status = [[dict objectForKey:@"status"] intValue];
                if(status == 1){
                    [self reloadTableCellinfo];
                }
                else{
                    UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"处理失败，可能是网络原因，请重复处理，联系管理员！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alervw show];
                }
            }
                break;

            default:
                break;
        }
        [SVProgressHUD dismissWithSuccess:@"加载成功" afterDelay:DELAY_SEC];
    }
    
    [_tbMoreThan12h reloadData];
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:DELAY_SEC];
}
@end
