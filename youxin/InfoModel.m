//
//  InfoModel.m
//  youxin
//
//  Created by fei on 13-9-17.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel
-(id)initWithIdentify:(NSString *)indentify publishtTime:(NSString *)publishTime operationStatus:(NSString *)status phoneno:(NSString*)phoneno sosnm:(NSString *)sosnm coordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    
    if(self){
        self.identify = indentify;
        self.publishTime = publishTime;
        self.operationStatus = status;
        self.sosNm = sosnm;
        self.phoneno = phoneno;
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
