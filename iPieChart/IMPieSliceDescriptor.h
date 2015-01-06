//
//  IMPieSliceDescriptor.h
//  PieChart
//
//  Created by Ivan Mejia on 12/29/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import UIKit;

@interface IMPieSliceDescriptor : NSObject

@property (nonatomic, strong) NSString * caption;
@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor * color;

+(instancetype)sliceWithCaption:(NSString *)caption value:(CGFloat)value color:(UIColor *)color;
-(void)setGiometry:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius;
-(BOOL)pointInSlice:(CGPoint)point;

@end
