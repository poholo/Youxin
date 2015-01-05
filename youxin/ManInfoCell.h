//
//  ManInfoCell.h
//  youxin
//
//  Created by fei on 13-9-12.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "InfoCell.h"
#import <MapKit/MapKit.h>

@interface ManInfoCell : InfoCell
@property (nonatomic,retain) UIButton *btnLbs;
@property (nonatomic,retain) UILabel *lbLbsText;
@property (nonatomic,assign) CLLocationCoordinate2D locationxy;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier btnno:(NSInteger)btnsum taget:(id)target sel:(SEL)sel sel2:(SEL)sel2;
@end
