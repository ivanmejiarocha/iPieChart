//
//  IMPieChartLayer.h
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@class IMPieSliceLayer;
@class IMPieSliceDescriptor;
@class IMPieChartView;

@interface IMPieChartLayer : CALayer

@property (nonatomic, strong) IMPieChartView * pieChartView;

-(IMPieSliceDescriptor *)pieSliceDescriptorAtPoint:(CGPoint)point;

@end
