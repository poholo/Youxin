//
//  WaitConfirmInfoViewController.m
//  youxin
//
//  Created by fei on 13-9-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WaitConfirmInfoViewController.h"
#import "UINav.h"
#import "UIViewController+MMDrawerController.h"
#import "ManInfoCell.h"

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@interface WaitConfirmInfoViewController () <MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSMutableArray *_data;
}


@end

@implementation WaitConfirmInfoViewController

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
    
    _tbWaitConfirmInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44 - 49)];
    _tbWaitConfirmInfo.delegate = self;
    _tbWaitConfirmInfo.dataSource = self;
    
    [self.view addSubview:_tbWaitConfirmInfo];
    
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _tbWaitConfirmInfo;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _tbWaitConfirmInfo;
    
    // 假数据
    _data = [NSMutableArray array];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview delegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" btnno:2 taget:self sel:@selector(cellBtnClick:)];
    }
    cell.lbTime.text = @"8-30 12:30";

    cell.lbnm.text = @"张小姐";
    
    cell.lbPhoneno.text = @"13691144520";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

-(void)cellBtnClick:(UIButton*)btn{

}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView) {
        for (int i = 0; i<5; i++) {
            [_data insertObject:[formatter stringFromDate:[NSDate date]] atIndex:0];
        }
        
    } else {
        for (int i = 0; i<5; i++) {
            [_data addObject:[formatter stringFromDate:[NSDate date]]];
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:_tbWaitConfirmInfo selector:@selector(reloadData) userInfo:nil repeats:NO];
}




@end
