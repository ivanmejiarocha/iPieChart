//
//  IMPieChartViewController.m
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

#import "IMPieChartViewController.h"
#import "IMMacroToolbox.h"

@interface IMPieChartViewController ()

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) UIImageView * selectorView;

@end

@implementation IMPieChartViewController

-(void)viewDidLoad {
   self.view.backgroundColor = IMOpaqueHexColor(0x424242);
   
   // configure pie chart view ...
   self.pieChartView.pieChartDelegate = self;
   self.pieChartView.pieChartDataSource = self;
   self.pieChartView.enableShadow = YES;
   self.pieChartView.radiusFactor = 0.9;
   self.pieChartView.animationType = IMPieChartAnimationTypeBouncing;
   self.pieChartView.selectionType = IMPieChartSelectionTypeLeft;
   
   self.pieChartView.layer.backgroundColor = [UIColor clearColor].CGColor;
   [self.pieChartView setTranslatesAutoresizingMaskIntoConstraints:NO];
   
   self.data = @[[IMPieSliceDescriptor sliceWithCaption:@"Slice 1" value:35 color:IMOpaqueHexColor(0xffd019)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 2" value:29 color:IMOpaqueHexColor(0xff7619)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 3" value:11 color:IMOpaqueHexColor(0x0066ff)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 4" value:10 color:IMOpaqueHexColor(0xff00cc)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 5" value:8 color:IMOpaqueHexColor(0xc60329)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 6" value:7 color:IMOpaqueHexColor(0x9bd305)]];
   
   [self.pieChartView reloadData];
   
   // configure decorating view ...
   self.decoratingView.sizingFactor = 0.16;
   self.decoratingView.decoratorDelegate = self;
   self.selectorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
   
   // configure color badge ...
   self.colorBadge.layer.cornerRadius = 12;
   self.colorBadge.layer.borderColor = [UIColor whiteColor].CGColor;
   self.colorBadge.layer.borderWidth = 1;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
   return UIStatusBarStyleLightContent;
}

#pragma mark - Pie Chart Delegate methods

-(void)pieChart:(IMPieChartView *)pieChart didSelectSlice:(IMPieSliceDescriptor *)slice {
   im_log(@"Slice has been selected: %@", slice.caption);
   self.colorBadge.backgroundColor = slice.color;
   self.infoLabel.text = [NSString stringWithFormat:@"%@ - %@%%", slice.caption, slice.value];
}

-(void)pieChartIsReady:(IMPieChartView *)pieChart {
   [pieChart rotateToSlice:0 animated:YES];
}

#pragma mark - Pie Chart DataSource methods

-(NSUInteger)pieChartSliceCount:(IMPieChartView *)pieChart {
   return self.data.count;
}

-(IMPieSliceDescriptor *)pieChart:(IMPieChartView *)pieChart sliceForIndex:(NSInteger)index {
   return self.data[index];
}

#pragma mark - Decorating View Delegate

-(UIView *)decoratorSelectorView {
   return self.selectorView;
}

-(IMPieChartView *)decoratorPieChartView {
   return self.pieChartView;
}

@end
