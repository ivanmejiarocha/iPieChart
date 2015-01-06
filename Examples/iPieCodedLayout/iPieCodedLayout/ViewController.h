//
//  ViewController.h
//  PieCodedAutolayout
//
//  Created by Ivan Mejia on 1/5/15.
//  Copyright (c) 2015 Ivan Mejia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPieChartDecoratingView.h"
#import "IMPieChartView.h"

@interface ViewController : UIViewController < IMPieChartViewDataSource, IMPieChartViewDelegate, IMPieChartDecoratingViewDelegate >

@property (nonatomic, strong) IMPieChartView * pieChartView;
@property (nonatomic, strong) IMPieChartDecoratingView * pieChartDecoratingView;
@property (nonatomic, strong) UILabel * infoLabel;

@end

