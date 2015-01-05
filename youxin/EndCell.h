//
//  EndCell.h
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicCell.h"

@interface EndCell : BasicCell
@property (nonatomic,retain) UIImageView *imgvwMention;
@property (nonatomic,retain) UILabel *lbMention;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
