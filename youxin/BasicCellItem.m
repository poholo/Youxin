//
//  BasicCellItem.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicCellItem.h"

@implementation BasicCellItem
-(id)initWithImgnm:(NSString *)imgnm title:(NSString *)title{
    if(self = [super init]){
        _imgnm = imgnm;
        _title = title;
    }
    return self;
}

@end
