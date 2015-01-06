//
//  IMPieChartContainerView.m
//  PieChart
//
//  Created by Ivan Mejia on 1/4/15.
//  Copyright (c) 2015 Ivan Mejia. All rights reserved.
//

#import "IMPieChartDecoratingView.h"

@interface IMPieChartDecoratingView ()
{
   CATransform3D _selectorOriTransform;
}

@property (nonatomic, strong) IMPieChartView * pieChartView;
@property (nonatomic, strong) UIView * selectorView;

@end

@implementation IMPieChartDecoratingView

-(void)layoutSubviews {
   
   self.selectorView = [self.decoratorDelegate decoratorSelectorView];
   if (![self.subviews containsObject:self.selectorView]) {
      [self addSubview:self.selectorView];
      _selectorOriTransform = self.selectorView.layer.transform;
   }
   
   if (self.pieChartView == nil) {
      self.pieChartView = [self.decoratorDelegate decoratorPieChartView];
   }
   
   UIView * containingView = self;
   CGSize selectorSize = CGSizeMake(containingView.bounds.size.width * self.sizingFactor,
                                    containingView.bounds.size.height * self.sizingFactor);
   CGPoint origin = CGPointZero;
   CGFloat centerWidth = (containingView.bounds.size.width - selectorSize.width) / 2;
   CGFloat centerHeight = (containingView.bounds.size.height - selectorSize.height) / 2;
   CGPoint selectorCenter = CGPointZero;
   
   self.selectorView.layer.transform = _selectorOriTransform;
   
   switch (self.pieChartView.selectionType) {
      case IMPieChartSelectionTypeBottom:
         origin = CGPointMake(centerWidth, containingView.bounds.size.height - selectorSize.height);
         self.selectorView.layer.transform = CATransform3DRotate(self.selectorView.layer.transform, 0, 0, 0, 1);
         break;
         
      case IMPieChartSelectionTypeTop:
         origin = CGPointMake(centerWidth, 0);
         self.selectorView.layer.transform = CATransform3DRotate(self.selectorView.layer.transform, M_PI, 0, 0, 1);
         break;
         
      case IMPieChartSelectionTypeLeft:
         origin = CGPointMake(0, centerHeight);
         self.selectorView.layer.transform = CATransform3DRotate(self.selectorView.layer.transform, M_PI / 2, 0, 0, 1);
         break;
         
      case IMPieChartSelectionTypeRight:
         origin = CGPointMake(containingView.bounds.size.width - selectorSize.width, centerHeight);
         self.selectorView.layer.transform = CATransform3DRotate(self.selectorView.layer.transform, -M_PI / 2, 0, 0, 1);
         break;
         
      default:
         break;
   }
   
   selectorCenter = CGPointMake(origin.x + selectorSize.width / 2, origin.y + selectorSize.height / 2);
   self.selectorView.bounds = CGRectMake(0, 0, selectorSize.width, selectorSize.height);
   self.selectorView.center = selectorCenter;
}

@end
