//
//  Notification.h
//  youxin
//
//  Created by fei on 13-10-16.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notification : UIView
@property (nonatomic,retain) UILabel *lb;
+ (void)showWithStatus:(NSString*)status;
@end
