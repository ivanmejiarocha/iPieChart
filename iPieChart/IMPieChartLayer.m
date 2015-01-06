//
//  IMPieChartLayer.m
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import GLKit;

#import "IMPieChartLayer.h"
#import "IMMacroToolbox.h"
#import "IMPieSliceDescriptor.h"
#import "IMPieChartView.h"
#import "IMMacroToolbox.h"

/****************************************************
 * IMPieChartLayer
 ****************************************************/

@interface IMPieChartLayer ()

@property (nonatomic, strong) NSMutableArray * slices;

@end

@implementation IMPieChartLayer

#pragma mark - Internal begaviour methods

-(id)init {
   if ((self = [super init]) != nil) {
      self.slices = [[NSMutableArray alloc] initWithCapacity:10];
   }
   return self;
}

-(CGFloat)computeAngleFromSliceValue:(CGFloat)sliceValue {
   // the angle is computed in radians
   return 2.0f * M_PI * sliceValue / 100;
}

-(void)drawInContext:(CGContextRef)ctx {
   im_log(@"drawing the pie...");
   
   // ******* Draw shadow...
   
   const CGFloat factor = self.pieChartView.radiusFactor;
   if (self.pieChartView.enableShadow) {
      CGRect pieStandRect = CGRectMake((self.frame.size.width - (self.frame.size.width * factor)) / 2,
                                       (self.frame.size.height - (self.frame.size.width * factor)) / 2,
                                       self.frame.size.width * factor,
                                       self.frame.size.width * factor);
      
      CGContextSaveGState(ctx);
      {
         CGContextScaleCTM(ctx, 1, 1);
         
         // NOTE:
         //   Basically we create a shadow around the crcle enclosing the pie chart. We start
         //   by pincing a gray scale color space.
         CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
         
         CGFloat shadowComponents[] = {0.0, 0.75};
         CGColorRef shadowColor = CGColorCreate(colorSpace, shadowComponents);
         CGContextSetShadowWithColor(ctx,
                                     CGSizeMake(0, 0), // shadow offset
                                     18,               // shadow blur
                                     shadowColor);
         CGContextSetGrayFillColor(ctx, 0.15, 1.0);
         CGContextFillEllipseInRect(ctx, pieStandRect);
         CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 0, NULL); // disable shadow
         CGColorRelease(shadowColor);
         CGColorSpaceRelease(colorSpace);
      }
      CGContextRestoreGState(ctx);
   }
   
   // ******* Draw pie slices...
   
   CGFloat radius = (self.bounds.size.width / 2.0) * factor;
   CGFloat startAngle = 0.0;
   CGFloat endAngle = 0.0;
   CGPoint pieCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);

   NSUInteger slidesCount = [self.pieChartView.pieChartDataSource pieChartSliceCount:self.pieChartView];
   for (NSUInteger index = 0; index < slidesCount; index++) {
      IMPieSliceDescriptor * slice = [self.pieChartView.pieChartDataSource pieChart:self.pieChartView sliceForIndex:index];
      
      const CGFloat * colorComponents = CGColorGetComponents(slice.color.CGColor);
      float sliceValue = [slice.value floatValue];
      
      endAngle = [self computeAngleFromSliceValue:sliceValue] + startAngle;
      
      CGContextMoveToPoint(ctx, pieCenter.x, pieCenter.y);
      CGContextAddArc(ctx, pieCenter.x, pieCenter.y, radius, startAngle, endAngle, false);
      CGContextSetRGBFillColor(ctx, colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]);
      CGContextFillPath(ctx);
      
      [slice setGiometry:startAngle endAngle:endAngle radius:radius];
      
      startAngle = endAngle;
   }
   
   // inform the pie has finished loading and rendering
   if ([self.pieChartView.pieChartDelegate respondsToSelector:@selector(pieChartIsReady:)]) {
      [self.pieChartView.pieChartDelegate pieChartIsReady:self.pieChartView];
   }
}

-(CGFloat)calculateAngleAtPoint:(CGPoint)point {
   GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(-point.y, point.x));
   
   // the angle moves between 180 and -180 degrees and the slice angle go from 0 to 360 degrees (2 * PI radians)
   CGFloat angle = acos(direction.y);
   if (direction.x > 0) {
      // NOTE:
      //   This converts the angle between 180 to -180 degrees into one between 0 to 360 degrees
      //   so we can compare accuratelly between start and end angles of an slice.
      angle = 2.0 * M_PI - angle;
   }
   return angle;
}


#pragma Public methods

-(IMPieSliceDescriptor *)pieSliceDescriptorAtPoint:(CGPoint)point {
   CGFloat angleAtPoint = [self calculateAngleAtPoint:point];
  
   const NSUInteger sliceCount = [self.pieChartView.pieChartDataSource pieChartSliceCount:self.pieChartView];
   for (NSUInteger index = 0; index < sliceCount; index++) {
      IMPieSliceDescriptor * slice = [self.pieChartView.pieChartDataSource pieChart:self.pieChartView sliceForIndex:index];
      if (angleAtPoint >= slice.startAngle && angleAtPoint <= slice.endAngle) {
         return slice;
      }
   }
   return nil;
}

@end
