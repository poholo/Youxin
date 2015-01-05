//
//  ConfirmedInfoViewController.m
//  youxin
//
//  Created by fei on 13-9-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "ConfirmedInfoViewController.h"
#import "InfoCell.h"

@interface ConfirmedInfoViewController ()

@end

@implementation ConfirmedInfoViewController

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
    _tbConfirmeIfnfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44-49) style:UITableViewStylePlain];
    _tbConfirmeIfnfo.delegate = self;
    _tbConfirmeIfnfo.dataSource =self;
    
    [self.view addSubview:_tbConfirmeIfnfo];
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
    
    cell.lbnm.text = @"张小姐1";
    
    cell.lbPhoneno.text = @"13691144520";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

-(void)cellBtnClick:(UIButton*)btn{
    
}

@end
