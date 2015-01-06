//
//  IMPieChartViewController.h
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import UIKit;

#import "IMPieChartView.h"
#import "IMPieChartDecoratingView.h"

@interface IMPieChartViewController : UIViewController < IMPieChartViewDelegate, IMPieChartViewDataSource, IMPieChartDecoratingViewDelegate >

@property (nonatomic, strong) IBOutlet IMPieChartDecoratingView * decoratingView;
@property (nonatomic, strong) IBOutlet IMPieChartView * pieChartView;
@property (nonatomic, strong) IBOutlet UILabel * infoLabel;
@property (nonatomic, strong) IBOutlet UIView * colorBadge;

@end
