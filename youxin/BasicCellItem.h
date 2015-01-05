//
//  BasicCellItem.h
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicCellItem : NSObject
@property (nonatomic,retain) NSString *imgnm;
@property (nonatomic,retain) NSString *title;
-(id)initWithImgnm:(NSString*)imgnm title:(NSString*)title;
@end
