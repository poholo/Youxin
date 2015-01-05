//
//  ServiceSetCell.h
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicCell.h"
#import "SubCell.h"

#define CELL_CLOSE @"dis_close"
#define CELL_OPEN @"dis_open"

@interface ServiceSetCell : BasicCell
@property (nonatomic,retain) UIImageView *imgvwDis;
@property (nonatomic,retain) NSArray *arr;
-(void)showSubCell:(BOOL)isShow;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier subarr:(NSArray*)subarr show:(BOOL)isShow;
@end
