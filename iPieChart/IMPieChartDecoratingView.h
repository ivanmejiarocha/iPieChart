//
//  IMPieChartContainerView.h
//  PieChart
//
//  Created by Ivan Mejia on 1/4/15.
//  Copyright (c) 2015 Ivan Mejia. All rights reserved.
//

@import UIKit;

#import "IMPieChartView.h"

@protocol IMPieChartDecoratingViewDelegate;

@interface IMPieChartDecoratingView : UIView

@property (nonatomic, assign) CGFloat sizingFactor;
@property (unsafe_unretained) id<IMPieChartDecoratingViewDelegate> decoratorDelegate;

@end

@protocol IMPieChartDecoratingViewDelegate <NSObject>

@required
-(UIView *)decoratorSelectorView;
-(IMPieChartView *)decoratorPieChartView;

@end

