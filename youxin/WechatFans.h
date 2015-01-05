//
//  WechatFans.h
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatFans : NSObject
@property (nonatomic,assign) int allsum;
@property (nonatomic,assign) int newaddSum;
@property (nonatomic,assign) int cancelSum;

@property (nonatomic,retain) NSArray *allArr;
@property (nonatomic,retain) NSArray *newaddArr;
@property (nonatomic,retain) NSArray *cancelArr;
@end
