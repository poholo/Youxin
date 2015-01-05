//
//  HttpDownload.h
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpdownloadDelgate.h"

@interface HttpDownload : NSObject<NSURLConnectionDataDelegate>{
@private
    //下载连接类
    NSURLConnection *_con;
    
}
 //下载保存数据
@property (nonatomic,strong) NSMutableData *mData;
//协议

@property (nonatomic,strong) id<HttpdownloadDelegate> delegate;

-(void)downloadFromUrl:(NSString*)url;
-(void)downloadHomeUrl:(NSString*)homeurl postparm:(NSString*)parm;
@end
