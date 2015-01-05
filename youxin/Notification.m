//
//  Notification.m
//  youxin
//
//  Created by fei on 13-10-16.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "Notification.h"
#import "AppDelegate.h"
static Notification *notifi = nil;
@implementation Notification

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _lb = [[UILabel alloc] initWithFrame:self.bounds];
        _lb.backgroundColor = [UIColor clearColor];
        _lb.numberOfLines = 2;
        [self addSubview:self.lb];
    }
	
    return self;
}


//- (void)drawRect:(CGRect)rect {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        size_t locationsCount = 2;
//        CGFloat locations[2] = {0.0f, 1.0f};
//        CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
//        CGColorSpaceRelease(colorSpace);
//        
//        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
//        CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
//        CGGradientRelease(gradient);
//}

+(void)showWithStatus:(NSString *)status{
    if(notifi==nil){
        notifi = [[Notification alloc] initWithFrame:CGRectMake(0, 20+44, 320, 40)];
    }
    else{
        notifi.lb.text = status;
    }
    notifi.hidden = NO;
    
    [[SHAREAPP window] addSubview:notifi];
    //dismiss 2s
    [NSTimer scheduledTimerWithTimeInterval:3 target:notifi selector:@selector(dismiss) userInfo:nil repeats:NO];
}

-(void)dismiss{
    notifi.hidden = YES;
}

@end
