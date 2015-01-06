//
//  ViewController.m
//  PieCodedAutolayout
//
//  Created by Ivan Mejia on 1/5/15.
//  Copyright (c) 2015 Ivan Mejia. All rights reserved.
//

#import "ViewController.h"
#import "IMPieSliceDescriptor.h"
#import "IMMacroToolbox.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) UIImageView * selectorView;

@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   
   // create info label view...
   self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
   self.infoLabel.font = [UIFont fontWithName:@"Arial" size:24];
   self.infoLabel.textColor = [UIColor blackColor];
   self.infoLabel.textAlignment = NSTextAlignmentCenter;
   [self.view addSubview:self.infoLabel];
   [ViewController centerView:self.infoLabel toContentView:self.view withSize:CGSizeMake(250, 30)];
   [ViewController pinView:self.infoLabel toContentView:self.view withSpaces:@{@"top":@(40),
                                                                               @"trailing":@(-40),
                                                                               @"leading":@(40)}];
   // create selector view...
   self.selectorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
   
   // create decorator view...
   self.pieChartDecoratingView = [[IMPieChartDecoratingView alloc] initWithFrame:CGRectZero];
   self.pieChartDecoratingView.sizingFactor = 0.16;
   self.pieChartDecoratingView.decoratorDelegate = self;
   
   // add decorating view to root view...
   [self.view addSubview:self.pieChartDecoratingView];
   
   self.pieChartView = [[IMPieChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
   self.pieChartView.backgroundColor = [UIColor clearColor];
   // add pie chart view to decorating view...
   [self.pieChartDecoratingView addSubview:self.pieChartView];

   // configure pie chart view ...
   self.pieChartView.pieChartDelegate = self;
   self.pieChartView.pieChartDataSource = self;
   self.pieChartView.enableShadow = NO;
   self.pieChartView.radiusFactor = 1;
   self.pieChartView.animationType = IMPieChartAnimationTypeBouncing;
   self.pieChartView.selectionType = IMPieChartSelectionTypeRight;
   
   self.data = @[[IMPieSliceDescriptor sliceWithCaption:@"Slice 1" value:35 color:IMOpaqueHexColor(0xffd019)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 2" value:29 color:IMOpaqueHexColor(0xff7619)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 3" value:11 color:IMOpaqueHexColor(0x0066ff)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 4" value:10 color:IMOpaqueHexColor(0xff00cc)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 5" value:8 color:IMOpaqueHexColor(0xc60329)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 6" value:7 color:IMOpaqueHexColor(0x9bd305)]];
   
   [ViewController centerView:self.pieChartDecoratingView toContentView:self.view withSize:CGSizeMake(300, 300)];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
}

#pragma mark - Delegate

-(void)pieChart:(IMPieChartView *)pieChart didSelectSlice:(IMPieSliceDescriptor *)slice {
   self.infoLabel.text = [NSString stringWithFormat:@"%@ - %@%%", slice.caption, slice.value];
}

-(void)pieChartIsReady:(IMPieChartView *)pieChart {
   [pieChart rotateToSlice:0 animated:YES];
}

#pragma mark - Data Source

-(NSUInteger)pieChartSliceCount:(IMPieChartView *)pieChart {
   return self.data.count;
}

-(IMPieSliceDescriptor *)pieChart:(IMPieChartView *)pieChart sliceForIndex:(NSInteger)index {
   return self.data[index];
}

#pragma mark - Decorator View 

-(UIView *)decoratorSelectorView {
   return self.selectorView;
}

-(IMPieChartView *)decoratorPieChartView {
   return self.pieChartView;
}

#pragma mark - Coded contrained layout

+(void)centerView:(UIView *)view toContentView:(UIView *)contentView withSize:(CGSize)size {
   [view setTranslatesAutoresizingMaskIntoConstraints:NO];
   
   [contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:contentView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:contentView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1
                                                               constant:size.width],
                                 [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:size.height]]];
}

+(void)pinView:(UIView *)view toContentView:(UIView *)contentView withSpaces:(NSDictionary *)spacing {
   [view setTranslatesAutoresizingMaskIntoConstraints:NO];
   
   NSMutableArray * constraints = [NSMutableArray arrayWithCapacity:4];
   NSNumber * value = @(0);
   if ((value = spacing[@"top"])) {
      [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:[value floatValue]]];
   }
   if ((value = spacing[@"bottom"])) {
      [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:[value floatValue]]];
   }
   if ((value = spacing[@"trailing"])) {
      [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:-[value floatValue]]];
   }
   if ((value = spacing[@"leading"])) {
      [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:[value floatValue]]];
   }
   
   [contentView addConstraints:constraints];
}

@end
