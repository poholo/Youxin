// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMExampleSideDrawerViewController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "MMLogoView.h"


#import "BasicCellItem.h"
#import "EndCellItem.h"
#import "AppDelegate.h"


#import "BasicCell.h"
#import "ServiceSetCell.h"
#import "EndCell.h"

#import "MentionCell.h"


#import "AppDelegate.h"


//center viewcontroller
//save
#import "WaitInfoViewController.h"
#import "ConfirmViewController.h"
#import "AbandenViewController.h"

//MAAbanden
#import "ManageAbandenViewController.h"
#import "ManageConfirmViewController.h"
#import "ManageWaitInfoViewController.h"

//data
#import "CarTypeViewController.h"
#import "DataBusinessViewController.h"
#import "WXViewController.h"

#import "WechatFansViewController.h"
#import "DDViewController.h"
#import "WechatInteractionViewController.h"
//修改密码
#import "EditpasViewController.h"
//意见反馈
#import "MesViewController.h"
//特征
#import "TZViewController.h"

#import "UIUtils.h"
#import "ViewUtils.h"
@implementation MMExampleSideDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:49.0/255.0
                                                      green:54.0/255.0
                                                       blue:57.0/255.0
                                                      alpha:1.0]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tb_bg"]]];
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
        [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    //展开
    self.isFirstOpen = YES;
    
    //Head
    UIView *imgvwlogo = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 320, 27)];
    imgvwlogo.backgroundColor = [UIColor blueColor];
    UILabel *lbYou = [UIUtils createLb:@"优" oragin:CGPointMake(5, 5) color:[UIColor colorWithRed:217/255.0 green:116/255.0 blue:0/255.0 alpha:1] fontSize:25];
    UILabel *lbXin = [UIUtils createLb:@"信" oragin:CGPointMake(lbYou.frame.origin.x+lbYou.frame.size.width +5,
                                                               lbYou.frame.origin.y) color:[UIColor whiteColor] fontSize:25];
    
    NSString *youxinVr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dealerName"];
    NSString *version = (youxinVr==NULL||[youxinVr isEqualToString:@""])?@"1.7":youxinVr;
    UILabel *lbSubTitle = [UIUtils createLb:version oragin:CGPointMake(lbXin.frame.origin.x+lbXin.frame.size.width +10,
                                                                   lbXin.frame.origin.y + 5) color:[UIColor whiteColor] fontSize:15];
    
    
    [self.view addSubview:lbYou];
    [self.view addSubview:lbXin];
    [self.view addSubview:lbSubTitle];
    
    CGRect rect = self.tableView.frame;
    self.tableView.frame = CGRectMake(rect.origin.x , imgvwlogo.frame.size.height + imgvwlogo.frame.origin.y + 5,  rect.size.width,rect.size.height -imgvwlogo.frame.size.height - imgvwlogo.frame.origin.y - 5);
    
    
    //net
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    _mSetHttpdownload = [[HttpDownload alloc] init];
    _mSetHttpdownload.delegate = self;
    
    
    _mUploadHttpdownload = [[HttpDownload alloc] init];
    _mUploadHttpdownload.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
   
    //数据
    //[self getMontionInfo];
    NSString *post = nil;
    NSString *home_url = nil;
    //服务预约管理
    self.isDownloadData = NO;
    switch (self.usrtype) {
            //预约服务管理
        case VW_TYPE_SAVE:
        {
            post = [NSString stringWithFormat:
                    @"iosName=%@&skey=%@&parm=%@",
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                    @"count"];
            home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Order.php"];
        }
            break;
            //救援服务管理
        case VW_TYPE_ORDER:{
            post = [NSString stringWithFormat:
                    @"iosName=%@&skey=%@&parm=%@",
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                    @"count"];
            home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Sos.php"];
        }
            break;
            //优信数据
        case VW_TYPE_DIN:{
            post = [NSString stringWithFormat:
                    @"iosName=%@&skey=%@&parm=%@",
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                    @"count"];
            home_url = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Sos.php"];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"%@ - %@",home_url,post);
    
    [_mHttpdownload downloadHomeUrl:home_url postparm:post];
    
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"indexpath.row = %d  usrtype = %d",indexPath.row,self.usrtype);
    
    static NSString *CellIdentifier = @"Cell";
    switch (indexPath.row) {
        case 0:{
            switch (self.usrtype) {
                case VW_TYPE_SAVE:
                {
                    SubCell *waitInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 40, 320, 40) target:self tag:0 sel:@selector(subcellSaveClick:)];
                    SubCell *confirmInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 80, 320, 40) target:self tag:1 sel:@selector(subcellSaveClick:)];
                    SubCell *undoInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 120, 320, 40) target:self tag:2 sel:@selector(subcellSaveClick:)];
                    
                    

                    
                    waitInfo.tag = 0;
                    confirmInfo.tag = 1;
                    undoInfo.tag = 2;
                    
                    waitInfo.lbTitle.text = @"待处理信息";
                    confirmInfo.lbTitle.text = @"已确认信息";
                    undoInfo.lbTitle.text = @"已忽略信息";
                    
                    
                    
                    NSArray *arr = [NSArray arrayWithObjects:waitInfo,confirmInfo,undoInfo, nil];
                    //提示信息
                    if(self.isDownloadData){
                        [self showMontionInfo:arr];
                    }
                    
                    
                    
                    ServiceSetCell *servicecell = [[ServiceSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier subarr:arr show:self.isFirstOpen];
                    servicecell.imgvwDis.image = [UIImage imageNamed:self.isFirstOpen?CELL_OPEN:CELL_CLOSE];
                    servicecell.imgvwIcon.image = [UIImage imageNamed:@"order"];
                    servicecell.lb.text = @"服务预约管理";
                    //待处理信息   已确认信息  已忽略信息
                    
                    
                    
                    

                    return servicecell;
                }
                    break;
                case VW_TYPE_ORDER:{
                    
                    SubCell *waitInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 40, 320, 40) target:self tag:0 sel:@selector(subcellOrderClick:)];
                    SubCell *confirmInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 80, 320, 40) target:self tag:1 sel:@selector(subcellOrderClick:)];
                    SubCell *undoInfo = [[SubCell alloc] initWithFrame:CGRectMake(0, 120, 320, 40) target:self tag:2 sel:@selector(subcellOrderClick:)];
                    
                    waitInfo.tag = 0;
                    confirmInfo.tag =1;
                    undoInfo.tag =2;
                    
                    waitInfo.lbTitle.text = @"待处理信息";
                    confirmInfo.lbTitle.text = @"已确认信息";
                    undoInfo.lbTitle.text = @"已放弃信息";
                    
                    NSArray *arr = [NSArray arrayWithObjects:waitInfo,confirmInfo,undoInfo, nil];
                    
                    //提示信息
                    if(self.isDownloadData){
                        [self showMontionInfo:arr];
                    }
                    NSLog(@"%@",((SubCell*)[arr lastObject]).lbTitle.text);
                    
                    ServiceSetCell *servicecell = [[ServiceSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier subarr:arr show:self.isFirstOpen];
                    servicecell.imgvwDis.image = [UIImage imageNamed:self.isFirstOpen?CELL_OPEN:CELL_CLOSE];
                    servicecell.imgvwIcon.image = [UIImage imageNamed:@"order"];
                    servicecell.lb.text = @"救援服务管理";
                    
                    
                    //待处理信息   已确认信息  已忽略信息
                
                    
                    return servicecell;
                    
                }
                    break;
                case VW_TYPE_DIN:{
                    
                    //车型关注排行
                    //                    业务关注排行
                    //                    微信集客数据
                    //                    服务预约数据
                    //                    微信互动汇总
                    //                    微信粉丝汇总
                    
                    NSArray *strArr = [NSArray arrayWithObjects:@"粉丝关注汇总",@"粉丝互动汇总",@"粉丝特征分析",@"车型关注排行",@"业务关注排行",@"服务预约数据",@"微信集客数据", nil];
                    
                    NSMutableArray *tmArr = [[NSMutableArray alloc] initWithCapacity:7];
                    int jikeSwith = [[[NSUserDefaults standardUserDefaults] objectForKey:@"jikeSwith"] intValue];
                    int sum = jikeSwith==0?6:7;
                    for(int i= 0;i<sum;i++){
                        SubCell *subcell = [[SubCell alloc] initWithFrame:CGRectMake(0, 40*i+40, 320, 40) target:self tag:i sel:@selector(subcellDinClick:)];
                        subcell.lbTitle.text = [strArr objectAtIndex:i];
                        [tmArr addObject:subcell];
                        //                        [servicecell addSubview:subcell];
                    }
                    

                    
                    
                    ServiceSetCell *servicecell = [[ServiceSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier subarr:tmArr show:self.isFirstOpen];
                    servicecell.imgvwDis.image = [UIImage imageNamed:self.isFirstOpen?CELL_OPEN:CELL_CLOSE];
                    servicecell.imgvwIcon.image = [UIImage imageNamed:@"order"];
                    servicecell.lb.text = @"优信数据管理";
                    
                    return servicecell;
                }
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            MentionCell *dotAsk = [[MentionCell alloc] initWithFrame:CGRectMake(0, 40, 320, 40) target:self tag:0 sel:@selector(subcellSetClick:)];
            SubCell *alerPas = [[SubCell alloc] initWithFrame:CGRectMake(0, 80, 320, 40) target:self tag:1 sel:@selector(subcellSetClick:)];

            int type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sval"] intValue];
            switch (type) {
                case 0:
                {
                    dotAsk.imgvwMetion.image = [UIImage imageNamed:@"mention_off"];
                }
                    break;
                case 1:{
                    dotAsk.imgvwMetion.image = [UIImage imageNamed:@"mention_on"];
                }
                    break;
                default:
                    break;
            }
            
            
            dotAsk.lbTitle.text = @"夜间防骚扰";
            
            alerPas.lbTitle.text = @"修改密码";
            
            
            ServiceSetCell *servicecell = [[ServiceSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier subarr:[NSArray arrayWithObjects:dotAsk,alerPas,nil] show:self.isSecOpen];
            servicecell.imgvwDis.image = [UIImage imageNamed:self.isSecOpen?CELL_OPEN:CELL_CLOSE];
            servicecell.imgvwIcon.image = [UIImage imageNamed:@"set"];
            servicecell.lb.text = @"设置";
            
            
            return servicecell;
        }
            break;
        case 2:{
            BasicCell *cell = [[BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.imgvwIcon.image = [UIImage imageNamed:@"reback"];
            cell.lb.text = @"意见反馈";
            return cell;
        }
            break;
        case 3:{
            EndCell *endcell = [[EndCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            endcell.imgvwIcon.image = [UIImage imageNamed:@"upload"];
            endcell.lb.text = @"版本更新";
            endcell.imgvwMention.hidden = !self.hasNew;
            return endcell;
        }
            break;
        case 4:{
            BasicCell *cell  =[[BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.imgvwIcon.image = [UIImage imageNamed:@"exit"];
            cell.lb.text = @"退出登陆";
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if(self.isFirstOpen){
                if(self.isYXdata){
                    int jikeSwith = [[[NSUserDefaults standardUserDefaults] objectForKey:@"jikeSwith"] intValue];
                    switch (jikeSwith) {
                        case 0:
                        {
                            return 40.0f + 6*40.0f;
                        }
                            break;
                        case 1:{
                            return 40.0f + 7*40.0f;
                        }
                            break;
                        default:
                            break;
                    }
                    
                }
                return 40.0f + 3*40.0f;
            }
        }
            break;
        case 1:{
            if(self.isSecOpen){
                return 40.0f + 2*40.0f;
            }
        
        }
            break;
        default:
            break;
    }
    
    return 40.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isUploadRequest=NO;
//    BasicCell *nowCell = [tableView ];
    switch (indexPath.row) {
            //救援服务管理   服务预约管理  优信数据管理  可打开
        case 0:
        {
            //判断状态
            ServiceSetCell *currentcell = (ServiceSetCell*)[tableView cellForRowAtIndexPath:indexPath];
                        
            self.isFirstOpen =  !self.isFirstOpen;
            [currentcell showSubCell:self.isFirstOpen];
            
            currentcell.imgvwDis.image = [UIImage imageNamed:self.isFirstOpen?CELL_OPEN:CELL_CLOSE];
            
            [tableView reloadData];
            
        }
            break;
            //设置  
        case 1:{
            //判断状态
            
            //判断状态
            ServiceSetCell *currentcell = (ServiceSetCell*)[tableView cellForRowAtIndexPath:indexPath];
            self.isSecOpen = !self.isSecOpen;
            
            [currentcell showSubCell:self.isSecOpen];
            currentcell.imgvwDis.image = [UIImage imageNamed:self.isSecOpen?CELL_OPEN:CELL_CLOSE];
            [tableView reloadData];
        }
            break;
            //意见反馈
        case 2:{
            BasicCell *currentCell = (BasicCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            
            MesViewController *mvc = [[MesViewController alloc] init];
            [self presentModalViewController:mvc animated:YES];
            currentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            //版本更新
        case 3:{
            [_mUploadHttpdownload downloadFromUrl:APP_URL];
            //版本更新为手动状态
            self.isUploadRequest = YES;
            self.uploadRequestType = UPLOADREQUEST_HANDLE;
        }
            break;
            
            //exit
        case 4:{
            [SHAREAPP switchViewController:VW_TYPE_LOGIN];
            
        }
            break;
            
        default:
            break;
    }
    
    //两秒后清除选定颜色
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - montion
-(void)changeMontionStatus:(int)type obj:(MentionCell*)mentionCell{
    switch (type) {
        case MONTION_CLOSE:
        {
            mentionCell.imgvwMetion.image = [UIImage imageNamed:@"mention_off"];
        }
            break;
        case MONTION_OPEN:{
            mentionCell.imgvwMetion.image = [UIImage imageNamed:@"mention_on"];
        }
            break;
        default:
            break;
    }


}


#pragma mark - subcellSaveClick
-(void)subcellSaveClick:(id)sender{
    UITapGestureRecognizer *tap = sender;
    SubCell *subcell = (SubCell*)[tap view];
    
    //变色 1s

    subcell.image= [UIImage imageNamed:SUBCELL_BG_IMG_SELECT];
    self.currentSubCell = subcell;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subcellSetCome:) userInfo:nil repeats:NO];
    
    NSLog(@"%@",subcell);
    NSLog(@"save viewcontroller  ----   %d",subcell.tag);
    switch (subcell.tag) {
            //待处理信息
        case 0:
        {
            
            WaitInfoViewController *wvc = [[WaitInfoViewController alloc] init];
            NSLog(@"%@",[wvc.view subviews]);
            [SHAREAPP replaceCurrentCenterViewController:wvc];
        }
            break;
            //已确认信息
        case 1:{
            ConfirmViewController *cvc = [[ConfirmViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:cvc];
        }
            break;
            //已忽略信息
        case 2:{
            AbandenViewController *avc = [[AbandenViewController alloc] init];
            NSLog(@"%@",[avc.view subviews]);
            [SHAREAPP replaceCurrentCenterViewController:avc];
        }
            break;
        default:
            break;
    }

}


#pragma mark -subcellOrderClick
-(void)subcellOrderClick:(id)sender{
    UITapGestureRecognizer *tap = sender;
    SubCell *subcell = (SubCell*)[tap view];
    
    self.currentSubCell = subcell;
    subcell.image= [UIImage imageNamed:SUBCELL_BG_IMG_SELECT];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subcellSetCome:) userInfo:nil repeats:NO];
    
    NSLog(@"%@ ------------- subcell.tag = %d",subcell,subcell.tag);
    switch (subcell.tag) {
            //待处理信息   替换中栏viewcontroller
        case 0:
        {
            ManageWaitInfoViewController *mwivc = [[ManageWaitInfoViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:mwivc];
        }
            break;
            //已确认信息
        case 1:{
            ManageConfirmViewController *mcvc = [[ManageConfirmViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:mcvc];
        }
            break;
            //已忽略信息
        case 2:{
            ManageAbandenViewController *mavc = [[ManageAbandenViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:mavc];
        }
            break;
        default:
            break;
    }
}

#pragma mark -subcellDinClick
-(void)subcellDinClick:(id)sender{
    //@"粉丝关注汇总",@"粉丝互动汇总",@"粉丝特征分析",@"车型关注排行",@"业务关注排行",@"服务预约数据",@"微信集客数据"
    UITapGestureRecognizer *tap = sender;
    SubCell *subcell = (SubCell*)[tap view];
    
    self.currentSubCell = subcell;
    
    subcell.image= [UIImage imageNamed:SUBCELL_BG_IMG_SELECT];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subcellSetCome:) userInfo:nil repeats:NO];
    switch (subcell.tag) {
            //  微信互动汇总
            
        case 0:{
            WechatFansViewController *wfve = [[WechatFansViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:wfve];
        }
            break;
            //  微信互动汇总
            
        case 1:{
            WechatInteractionViewController *wivc = [[WechatInteractionViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:wivc];
        }
            break;
            //粉丝特征汇总
        case 2:{
            TZViewController *tzvc = [[TZViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:tzvc];
        
        }
            break;
            //车型关注排行
        case 3:
        {
            CarTypeViewController *cvc = [[CarTypeViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:cvc];
        }
            break;
            // 业务关注排行
        case 4:{
            DataBusinessViewController *dvc = [[DataBusinessViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:dvc];
        
        }
            break;
            
            //服务预约数据
        case 5:{
            DDViewController *ddvc = [[DDViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:ddvc];
        }
            break;
        
           // 微信集客数据
        case 6:{
            WXViewController *wxvc = [[WXViewController alloc] init];
            [SHAREAPP replaceCurrentCenterViewController:wxvc];
            
        }
            
            break;
        
            
        default:
            break;
    }
    
}


#pragma mark - 设置
-(void)subcellSetClick:(id)sender{
    UITapGestureRecognizer *tap = sender;
    SubCell *subcell = (SubCell*)[tap view];
    self.currentSubCell = subcell;
    
    
    switch (subcell.tag) {
            //夜间防骚扰
        case 0:
        {
            //保存到userdefault中 ， 修改状态
            int type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sval"] intValue];
            switch (type) {
                case MONTION_CLOSE:
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"sval"];
                }
                    break;
                case MONTION_OPEN:{
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"sval"];
                }
                    break;
                default:
                    break;
            }
            
            
            MentionCell *mcell = (MentionCell*)subcell;
            type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sval"] intValue];
            [self changeMontionStatus:type obj:mcell];
            NSString *home_url_set = [NSString stringWithFormat:@"%@%@",HOME_URL,@"Login.php"];
            NSString *post_set = [NSString stringWithFormat:
                                  @"iosName=%@&skey=%@&sval=%@&parm=%@",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"sval"],
                                  @"set"];
            
            [_mSetHttpdownload downloadHomeUrl:home_url_set postparm:post_set];
            self.montionHadDownload = YES;
        
        }
            break;
            //修改密码
        case 1:
        {
            subcell.image= [UIImage imageNamed:SUBCELL_BG_IMG_SELECT];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subcellSetCome:) userInfo:nil repeats:NO];
            EditpasViewController *editpasvc = [[EditpasViewController alloc] init];
            [self presentModalViewController:editpasvc animated:YES];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - 变回原色
-(void)subcellSetCome:(id)sender{
    self.currentSubCell.image = [UIImage imageNamed:SUBCELL_BG_IMG_NORMAL];
}

#pragma mark -提示信息展

-(void)showMontionInfo:(NSArray*)arr{
    
    switch (self.usrtype) {
        case VW_TYPE_SAVE:
        {
            
            NSString *montionInfo = nil;
            for(SubCell *currentSubCell in arr){
                switch (currentSubCell.tag) {
                    case 0:
                    {
                        montionInfo = [NSString stringWithFormat:@"%d",self.montionWaitSum];
                    }
                        break;
                    case 1:{
                        montionInfo =[NSString stringWithFormat:@"%d",self.montionConfirmSum];
                    }
                        break;
                    case 2:{
                        montionInfo = [NSString stringWithFormat:@"%d",self.montionAbanSum];
                    }
                        break;
                    default:
                        break;
                }
                
                 NSLog(@"dlkajsd;fklasdjfasldkfjalskdfjaskjld%d--%@",currentSubCell.tag,montionInfo);
                
                [self switchMontion:currentSubCell montioninfo:montionInfo];
               
            }
        }
            break;
        case VW_TYPE_ORDER:{
            NSString *montioninfo = nil;
            for(SubCell *tmsubcell in arr){
                switch (tmsubcell.tag) {
                    case 0:
                    {
                        montioninfo =[NSString stringWithFormat:@"%d",self.montionJiuyuanWaitSum];
                    }
                        break;
                    case 1:{
                        montioninfo = [NSString stringWithFormat:@"%d",self.montionJiuyuanConfirmSum];
                    }
                        break;
                    case 2:{
                        montioninfo = [NSString stringWithFormat:@"%d",self.montionJiuyuanAbanSum];
                    }
                        break;
                    default:
                        break;
                }
                 [self switchMontion:tmsubcell montioninfo:montioninfo];
            }
            
           
        }
            break;
        case VW_TYPE_DIN:{
            
        }
            break;
        default:
            break;
    }
   
    
}


#pragma mark - 显示 or 关闭提示
-(void)switchMontion:(SubCell*)currentCell montioninfo:(NSString*)montionInfo{
    NSLog(@"montionInfo - %@",montionInfo);
    if(montionInfo==nil||[montionInfo isEqualToString:@"0"]){
        NSLog(@"montionInfo == nil");
        currentCell.imgvwMetion.hidden = YES;
        return;
    }
    else if(montionInfo){
        currentCell.imgvwMetion.hidden = NO;
        
        currentCell.lbMention.text = [NSString stringWithFormat:@"%d",[montionInfo intValue]];
    }
    NSLog(@"currentcell status - %@  -- %@",currentCell,currentCell.imgvwMetion);
}


#pragma mark - net 
-(void)downloadComplete:(HttpDownload *)hd{
    NSLog(@"%d",hd.mData.length);
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",dict);
    if(nil == dict){
        return;
    }
    else{
        self.hasNew = NO;
        //调用显示
        
        //更新控制
        NSString *newVersion = [dict objectForKey:@"version"];
        //获取应用程序地址
        NSString *newUrl = [dict objectForKey:@"trackViewUrl"];
        //取得本地版本号
        NSDictionary *localDic = [[NSBundle mainBundle] infoDictionary];
        NSString *localVersion = [localDic objectForKey:@"CFBundleShortVersionString"];
        if(_isUploadRequest){
            
            switch (self.uploadRequestType) {
                case UPLOADREQUEST_AUTO:
                {
                    //显示新版本提示，但不跳出更新提示框。
                    self.hasNew=YES;
                    
                }
                    break;
                case UPLOADREQUEST_HANDLE:{
                    //手都更新
                    if(![newVersion isEqualToString:localVersion]){
                        //提供下载页面
                        NSLog(@"upload app");
                        [SVProgressHUD showSuccessWithStatus:@"程序更新中..." duration:DELAY_SEC];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newUrl]];
                    }
                    
                    else{
                        //提示当前为最新版本！
                        [SVProgressHUD showSuccessWithStatus:@"当前为最新版本" duration:DELAY_SEC];
                    }
                }
                    break;
                default:
                    break;
            }
        }
        else{
            switch (self.usrtype) {
                    //预约服务管理
                case VW_TYPE_SAVE:
                {
                    
                    
                    self.montionWaitSum = [[dict objectForKey:@"waitCount"] intValue];
                    self.montionConfirmSum = 0;
                    self.montionAbanSum = 0;
                    
                    //
                    [SHAREAPP refreshBadge:self.montionWaitSum];
                    
                    NSLog(@"%d  %d  %d",self.montionWaitSum,self.montionConfirmSum,self.montionAbanSum);
                    self.isDownloadData = YES;
                    [self.tableView reloadData];
                    
                }
                    break;
                    //救援服务管理
                case VW_TYPE_ORDER:{
                    self.montionJiuyuanWaitSum = [[dict objectForKey:@"waitCount"] intValue];
                    self.montionJiuyuanConfirmSum = 0;
                    self.montionJiuyuanAbanSum = 0;
                    
                    [SHAREAPP refreshBadge:self.montionJiuyuanWaitSum];
                    NSLog(@"%d  %d  %d",self.montionJiuyuanWaitSum,self.montionJiuyuanConfirmSum,self.montionJiuyuanAbanSum);
                    self.isDownloadData = YES;
                    [self.tableView reloadData];
                }
                    break;
                    //优信数据
                case VW_TYPE_DIN:{
                    [SHAREAPP refreshBadge:0];
                }
                    break;
                default:
                    break;
            }
        }
    }
   
    
}

-(void)downloadError:(HttpDownload *)hd{
    
}

@end
