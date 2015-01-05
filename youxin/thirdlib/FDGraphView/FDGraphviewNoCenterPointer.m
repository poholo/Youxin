//
//  FDGraphviewNoCenterPointer.m
//  youxin
//
//  Created by fei on 13-9-30.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "FDGraphviewNoCenterPointer.h"

@implementation FDGraphviewNoCenterPointer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    [self.linesColor setStroke];
    // lines width
    CGContextSetLineWidth(context, 2);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    //    min = ((NSNumber *)[self minDataPoint]).floatValue;
    min = 0.0;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSNumber *)self.dataPoints[i]).floatValue;
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else // il grafico si riduce a una retta
                y = rect.size.height/2;
            
            graphPoints[i] = CGPointMake(x, y);
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
    
    // DISEGNO I CERCHI NEL GRANO
    
    CGRect ellipseRect = CGRectMake(graphPoints[0].x-3, graphPoints[0].y-3, 6, 6);
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextSetLineWidth(context, 2);
    [self.dataPointStrokeColor setStroke];
    [self.dataPointColor setFill];
    CGContextFillEllipseInRect(context, ellipseRect);
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
    CGRect ellipseRect1 = CGRectMake(graphPoints[count-1].x-3, graphPoints[count-1].y-3, 6, 6);
    CGContextAddEllipseInRect(context, ellipseRect1);
    CGContextSetLineWidth(context, 1);
    [self.dataPointStrokeColor setStroke];
    [self.dataPointColor setFill];
    CGContextFillEllipseInRect(context, ellipseRect1);
    CGContextStrokeEllipseInRect(context, ellipseRect1);
    
//    for (int i = 0; i < count; ++i) {
//        CGRect ellipseRect = CGRectMake(graphPoints[i].x-3, graphPoints[i].y-3, 6, 6);
//        CGContextAddEllipseInRect(context, ellipseRect);
//        CGContextSetLineWidth(context, 2);
//        [self.dataPointStrokeColor setStroke];
//        [self.dataPointColor setFill];
//        CGContextFillEllipseInRect(context, ellipseRect);
//        CGContextStrokeEllipseInRect(context, ellipseRect);
//    }
}
@end
