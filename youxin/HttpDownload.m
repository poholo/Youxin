//
//  HttpDownload.m
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//




#import "HttpDownload.h"
@implementation HttpDownload
-(void)downloadFromUrl:(NSString *)url{
    //1.数据存储器初始化
    if(!_mData){
        _mData = [[NSMutableData alloc] initWithCapacity:0];
        
    }
    if(_con){
        _con = nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    _con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)downloadHomeUrl:(NSString*)homeurl postparm:(NSString*)parm{
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSLog(@"%@",homeurl);
    NSLog(@"post:%@",parm);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [parm dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:homeurl]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    
    //1.数据存储器初始化
    if(!_mData){
        _mData = [[NSMutableData alloc] initWithCapacity:0];
        
    }
    if(_con){
        _con = nil;
    }
    _con = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}


#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_mData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if([self.delegate respondsToSelector:@selector(downloadComplete:)]){
        [self.delegate downloadComplete:self];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(downloadError:)]){
        [self.delegate downloadError:self];
    }
}
@end
