//
//  HttpdownloadDelgate.h
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HttpDownload;
@protocol HttpdownloadDelegate <NSObject>

//下载成功
-(void)downloadComplete:(HttpDownload*)hd;


//下载失败
-(void)downloadError:(HttpDownload*)hd;

@end

