//
//  WaitInfoViewController.m
//  youxin
//
//  Created by fei on 13-9-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "WaitInfoViewController.h"

#import "AllViewController.h"
#import "MoreThan12hViewController.h"
#import "MoreThan24hViewController.h"

#import "UINav.h"
#import "UIViewController+MMDrawerController.h"

@interface WaitInfoViewController (){
    NSArray *normalArr;
    NSArray *normalTitleArr;
    NSString *selectBg;
    NSString *unselectbg;
    
}

@end

@implementation WaitInfoViewController

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
    
//	if(isIOS7)
//	{
//		[self.view addSubview:iOS7StatusBar];
//	}
    
    //bg
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"edit_pas_bg"] stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	// Do any additional setup after loading the view.
    AllViewController *wvc = [[AllViewController alloc] init];
    MoreThan12hViewController *cvc = [[MoreThan12hViewController alloc] init];
    MoreThan24hViewController *avc = [[MoreThan24hViewController alloc] init];
    
    
    
    self.viewControllers = [NSArray arrayWithObjects:wvc,cvc,avc, nil];
    
    
    //tabbar处理
    [[[self.view subviews] objectAtIndex:1] setBackgroundImage:[[UIImage imageNamed:@"tabbar_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:10]];
    NSLog(@"%@",[self.tabBar subviews]);
    normalArr = [[NSArray alloc] initWithObjects:@"sos_all",@"12h",@"24h", nil];
    
    normalTitleArr = [[NSArray alloc] initWithObjects:@"全部",@"超12小时",@"超24小时", nil];
    selectBg = @"baritem";
    unselectbg = @"";
    
    
    [[[self.view subviews] objectAtIndex:1] addSubview:[self settabBarItemViewWithText:[normalTitleArr objectAtIndex:0] andImage:[normalArr objectAtIndex:0] andCenter:CGPointMake(53.5, 24.5) tag:1]];
    
    
    [[[self.view subviews] objectAtIndex:1] addSubview:[self settabBarItemViewWithText:[normalTitleArr objectAtIndex:1] andImage:[normalArr objectAtIndex:1] andCenter:CGPointMake(107+53.5, 24.5) tag:2]];
    [[[self.view subviews] objectAtIndex:1] addSubview:[self settabBarItemViewWithText:[normalTitleArr objectAtIndex:2] andImage:[normalArr objectAtIndex:2] andCenter:CGPointMake(214+53.5,24.5) tag:3]];
    
    [self switchTabbar:0];
    self.delegate = self;
    
    
    
    UINav *nav = [[UINav alloc] initWithFrame:CGRectMake(0, 0, 320, 44) target:self];
    [self.view addSubview:nav];
    nav.lbTile.text = @"待处理信息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 对tabBar的每一个项目背景进行设置，包括图片，文字，坐标
- (UIView *)settabBarItemViewWithText:(NSString *)text andImage:(NSString *)imageName andCenter:(CGPoint)point tag:
(int)tag
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
    imageView.frame = CGRectMake(0, 0, 105, 49);
    imageView.center = point;
	
	imageView.tag = tag;
    
    UIImageView *imgvwIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imgvwIcon.frame = CGRectMake(0, 0, 20, 20);
    imgvwIcon.center = CGPointMake(53.5, 20);
    
    
    [imageView addSubview:imgvwIcon];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, 107, 13)];
    lbtitle.text = text;
    lbtitle.textAlignment = UITextAlignmentCenter;
    lbtitle.backgroundColor = [UIColor clearColor];
    lbtitle.textColor = [UIColor whiteColor];
    
    lbtitle.font = [UIFont systemFontOfSize:13];
    
    
    [imageView addSubview:lbtitle];
    return imageView;
}
-(void)switchTabbar:(NSInteger)tag{
    NSArray *arr =[[[self.view subviews] objectAtIndex:1] subviews];
	NSMutableArray *tmarr = [[NSMutableArray alloc] init];
	for(UIView *vw in arr){
		
		if(vw.tag>0&&vw.tag<4){
			[tmarr addObject:vw];
		}
	}
    NSLog(@"%@----%@",arr ,tmarr);
    
    NSArray * picnmArr =nil;
    
    switch (tag) {
            //news
        case 0:
        {
            picnmArr = [NSArray arrayWithObjects:selectBg,unselectbg,unselectbg, nil];
        }
            break;
            //prize
        case 1:{
            
            picnmArr = [NSArray arrayWithObjects:unselectbg,selectBg,unselectbg, nil];
        }
            break;
            
            //process
        case 2:{
            picnmArr = [NSArray arrayWithObjects:unselectbg,unselectbg,selectBg, nil];
            
        }
            break;
        default:
            break;
    }
    //换图
    for(int i=0; i<3; i++){
		((UIImageView*)[tmarr objectAtIndex:i]).image = [[UIImage imageNamed:[picnmArr objectAtIndex:i]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    }
    
}

// 当被选中的时候，显示高亮
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
	NSLog(@"selectedindex ----%d",self.selectedIndex);
    [self switchTabbar:self.selectedIndex];
}

-(void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 0:
        {
            //打开抽屉
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


@end
