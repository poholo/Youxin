//
//  MapViewController.h
//  youxin
//
//  Created by fei on 13-9-16.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *strplacenm;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) MKPointAnnotation *ann;
@end
    