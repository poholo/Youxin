
//
//  EndCellItem.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "EndCellItem.h"

@implementation EndCellItem


-(id)initWithImgnm:(NSString *)imgnm title:(NSString *)title mention:(NSString*)mention{
    if(self = [super initWithImgnm:imgnm title:title]){
        _mention = mention;
    }
    return self;
}

@end
