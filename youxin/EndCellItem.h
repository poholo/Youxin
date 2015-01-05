//
//  EndCellItem.h
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicCellItem.h"

@interface EndCellItem : BasicCellItem
@property (nonatomic,retain) NSString *mention;

-(id)initWithImgnm:(NSString *)imgnm title:(NSString *)title mention:(NSString*)mention;
@end
