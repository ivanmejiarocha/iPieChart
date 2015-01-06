//
//  IMPieSliceDescriptor.m
//  PieChart
//
//  Created by Ivan Mejia on 12/29/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import GLKit;

#import "IMPieSliceDescriptor.h"
#import "IMMacroToolbox.h"

@interface IMPieSliceDescriptor ()
{
   CGMutablePathRef _slicePath;
}


@end

@implementation IMPieSliceDescriptor

+(instancetype)sliceWithCaption:(NSString *)caption value:(CGFloat)value color:(UIColor *)color {
   IMPieSliceDescriptor * slice = [[[self class] alloc] init];
   slice.caption = caption;
   slice.value = @(value);
   slice.color = color;
   return slice;
}

-(void)setGiometry:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius {
   CGFloat centerAngle = (endAngle - startAngle) / 2.0;
   im_log(@"startAng = %f (%f) endAng = %f (%f) centerAng %f (%f)",
          startAngle,
          GLKMathRadiansToDegrees(startAngle),
          endAngle,
          GLKMathRadiansToDegrees(endAngle),
          centerAngle,
          GLKMathRadiansToDegrees(centerAngle));
   _startAngle = startAngle;
   _endAngle = endAngle;
   _radius = radius;
   _slicePath = CGPathCreateMutable();
   CGPathAddArc(_slicePath, NULL, 0, 0, _radius, _startAngle, _endAngle, false);
   CGPathCloseSubpath(_slicePath);
}

-(BOOL)pointInSlice:(CGPoint)point {
   return CGPathContainsPoint(_slicePath, NULL, point, true);
}

@end
