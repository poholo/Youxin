//
//  MapViewController.m
//  youxin
//
//  Created by fei on 13-9-16.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "MapViewController.h"
#import "UINav.h"

@interface MapViewController (){
    
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINav *nav = [[UINav alloc] initWithFrame:CGRectMake(0, 0, 320, 44) target:self];
    nav.lbTile.text = @"地图导航";
    [self.view  addSubview:nav];
	// Do any additional setup after loading the view.
    // annotation for Golden Gate Bridge
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44,self.view.frame.size.width, self.view.frame.size.height - 44)];
    
    _mapView.delegate = self;
    
    
//    
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = 23.134844f;
//    coordinate.longitude = 113.317290f;
    _ann = [[MKPointAnnotation alloc] init];
    _ann.coordinate = self.coordinate;
    

    
    [self getNmByLocation];
    
    //触发viewForAnnotation
    [_mapView addAnnotation:_ann];
    
    
    MKCoordinateRegion regon;
    regon.span.latitudeDelta = 0.01;
    regon.span.longitudeDelta = 0.01;
    regon.center = self.coordinate;
    
    [_mapView setRegion:regon animated:YES];
    [_mapView regionThatFits:regon];
    
    
    
    [self.view addSubview:_mapView];

    
//    self locationManager:nil didUpdateToLocation:CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)) fromLocation:<#(CLLocation *)#>
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [self performSelector:@selector(showCallout) withObject:nil afterDelay:3.0];
    
        

}


- (void)showCallout {
    [_mapView selectAnnotation:_ann animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.youxin.pin";
    pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                      initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"did select ");
//    [self getNmByLocation];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"deselect");
    
}


#pragma mark - btnclick
-(void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
        //返回
        case 0:
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - mapkit
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    [locationManager stopUpdatingLocation];
    //    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    //    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    //    NSLog(@"Lat: %@ Lng: %@", strLat, strLng);
    //    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //    float zoomLevel = 0.02;
    //    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    //    [map setRegion:[map regionThatFits:region] animated:YES];
    
    if(signbit(newLocation.horizontalAccuracy))
    {
        
    }
    else
    {
        //反地理编码
        //lng=116.319076&lat=39.952659
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:39.952659 longitude:116.319076];
        
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error)
         {
             for(CLPlacemark * plc in placemarks)
             {
                 NSLog(@"address dic %@",plc.addressDictionary);
                 NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",[plc.addressDictionary objectForKey:@"Country"],[plc.addressDictionary objectForKey:@"CountryCode"],[[plc.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0],[plc.addressDictionary objectForKey:@"Name"],[plc.addressDictionary objectForKey:@"State"],[plc.addressDictionary objectForKey:@"Street"],[plc.addressDictionary objectForKey:@"SubLocality"],[plc.addressDictionary objectForKey:@"SubThoroughfare"],[plc.addressDictionary objectForKey:@"Thoroughfare"]);
             }
             
         }];
    }
    
}
#pragma MARK - 反查地理位置
-(void)getNmByLocation{
    NSLog(@"jinlaile---------------------------------------------------------------------------------------------------------------");
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"%@",placemarks);
         for(CLPlacemark * plc in placemarks)
         {
             NSLog(@"address dic %@",plc.addressDictionary);
             NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",[plc.addressDictionary objectForKey:@"Country"],[plc.addressDictionary objectForKey:@"CountryCode"],[[plc.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0],[plc.addressDictionary objectForKey:@"Name"],[plc.addressDictionary objectForKey:@"State"],[plc.addressDictionary objectForKey:@"Street"],[plc.addressDictionary objectForKey:@"SubLocality"],[plc.addressDictionary objectForKey:@"SubThoroughfare"],[plc.addressDictionary objectForKey:@"Thoroughfare"]);
             
             NSString *city = [plc.addressDictionary objectForKey:@"City"];
             NSString *sublocality = [plc.addressDictionary objectForKey:@"SubLocality"];
             NSString *state = [plc.addressDictionary objectForKey:@"state"];
             NSString *street = [plc.addressDictionary objectForKey:@"Street"];
             
             NSString *subtrhoroughfare = [plc.addressDictionary objectForKey:@"SubThoroughfare"];

             NSString *thoroughfare = [plc.addressDictionary objectForKey:@"Thoroughfare"];
             
             NSMutableString *mutstr = [[NSMutableString alloc] initWithFormat:@"%@%@%@%@",city==NULL?@"":city,sublocality==NULL?@"":sublocality,state==NULL?@"":state,street==NULL?(subtrhoroughfare==NULL?thoroughfare:subtrhoroughfare):street];
             
             _ann.title = mutstr;
         }
         
     }];
}

@end
