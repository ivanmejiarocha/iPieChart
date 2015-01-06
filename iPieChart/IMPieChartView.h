//
//  IMPieChartView.h
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import UIKit;

#import "IMPieChartLayer.h"
#import "IMPieSliceDescriptor.h"

typedef NS_ENUM(NSInteger, IMPieChartSelectionType) {
   IMPieChartSelectionTypeTop,
   IMPieChartSelectionTypeBottom,
   IMPieChartSelectionTypeLeft,
   IMPieChartSelectionTypeRight
};

typedef NS_ENUM(NSInteger, IMPieChartAnimationType) {
   IMPieChartAnimationTypeMechanicGear,
   IMPieChartAnimationTypeBouncing
};

@protocol IMPieChartViewDelegate;
@protocol IMPieChartViewDataSource;

@interface IMPieChartView : UIView

@property (unsafe_unretained) id<IMPieChartViewDelegate> pieChartDelegate;
@property (unsafe_unretained) id<IMPieChartViewDataSource> pieChartDataSource;
@property (nonatomic, assign) IMPieChartSelectionType selectionType;
@property (nonatomic, assign) IMPieChartAnimationType animationType;
@property (nonatomic, assign) BOOL enableShadow;
@property (nonatomic, assign) CGFloat radiusFactor;

-(void)rotateToSlice:(NSUInteger)sliceIndex animated:(BOOL)animated;
-(void)reloadData;

@end

@protocol IMPieChartViewDelegate <NSObject>

@optional
-(void)pieChart:(IMPieChartView *)pieChart didSelectSlice:(IMPieSliceDescriptor *)slice;
-(void)pieChartIsReady:(IMPieChartView *)pieChart;

@end

@protocol IMPieChartViewDataSource <NSObject>

@required
-(NSUInteger)pieChartSliceCount:(IMPieChartView *)pieChart;
-(IMPieSliceDescriptor *)pieChart:(IMPieChartView *)pieChart sliceForIndex:(NSInteger)index;

@end
