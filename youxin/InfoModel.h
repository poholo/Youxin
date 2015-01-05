//
//  InfoModel.h
//  youxin
//
//  Created by fei on 13-9-17.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface InfoModel : NSObject
@property (nonatomic,retain) NSString *identify;
@property (nonatomic,retain) NSString *publishTime;
@property (nonatomic,retain) NSString *operationStatus;
@property (nonatomic,retain) NSString *sosNm;
@property (nonatomic,retain) NSString *phoneno;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id)initWithIdentify:(NSString*)indentify publishtTime:(NSString*)publishTime operationStatus:(NSString*)status phoneno:(NSString*)phoneno sosnm:(NSString*)sosnm coordinate:(CLLocationCoordinate2D)coordinate;
@end
