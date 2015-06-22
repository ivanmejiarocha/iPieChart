iPieChart
==============
<img src="http://1.bp.blogspot.com/-7qLnWku9Pog/VLQXacT2jcI/AAAAAAAAAOs/4_IWPiDc7kc/s1600/piechart_screenshot.png" alt="iPieChart Screenshot" width="320" height="568" />

Objective
--------------
PieChart was conceived after my learning about the linear algebra vector's arithmetic. I found interesting the idea to start practicing my new learning in an interactive Pie Chart control. This control so far is in its basic stage but can be used by anyone and extended to fit your needs. This is a work in progress and any feedback ideas or improvements will be greatly appreciated.

Some terminology
--------------

* **Selector View** is the View with a little arrow image that serves as the pie slice selection point
* **Decorating View** is an added view to the main ViewController's view and the one that contains the selector view

How to use it
--------------
You need to include in your project the following files:

- IMPieChartView.m
- IMPieChartView.h
- IMPieChartLayer.m
- IMPieChartLayer.h
- IMPieSliceDescriptor.m
- IMPieSliceDescriptor.h
- IMPieChartDecoratingView.m
- IMPieChartDecoratingView.h
- IMMacroToolbox.h

1) Now make your View Controller to conform to the protocols IMPieChartViewDelegate, IMPieChartViewDataSource and IMPieChartDecoratingViewDelegate:

	@interface MyViewController : UIViewController < IMPieChartDelegate, IMPieChartDataSource, IMPieChartDecoratingViewDelegate >

2) Declare two properties in your View Controller, one of type IMPieChartView and one of type IMPieChartDecoratingView

	@property (nonatomic, strong) IMPieChartView * pieChartView;
	@property (nonatomic, strong) IMPieChartDecoratingView * decoratingView;

3) declare a property of type UIImageView which will be used as the selector view (the little black triangle that points to the current pie slice, as shown in the screenshot), the current implementation uses an UIImageView but here you can provide your own custom view:

	@property (nonatomic, strong) UIImageView * selectorView;

4) Now on the viewDidLoad method you configure the pie using the following properties:

    -(void)viewDidLoad {
		// create the chart pie
		self.pieChartView = [[IMPieChartView alloc] initWithFrame:CGRect(0,0, 300, 300)];
	
	    // setup the delegate 
	    self.pieChartView.pieChartDelegate = self;
	
		// setup the datasource
	    self.pieChartView.pieChartDataSource = self;
	
		// this will enable showing a drop shadow under the pie chart
	    self.pieChartView.enableShadow = YES;
	
		// this is a factor applied to the radius so the drop shadow can be shown without clipping
	    self.pieChartView.radiusFactor = 0.9;
	
		// you can specify the type of animation you want the pie perform when dragging ends
		// or an slice is selected. Currently it supports:
		//  - IMPieChartAnimationTypeMechanicGear 
		//  - IMPieChartAnimationTypeBouncing
	    self.pieChartView.animationType = IMPieChartAnimationTypeMechanicGear;
	
		// you can locate the selection point in the top, left, right or bottom of the pie chart:
		//  - IMPieChartSelectionTypeTop
		//  - IMPieChartSelectionTypeBottom
		//  - IMPieChartSelectionTypeLeft
		//  - IMPieChartSelectionTypeRight
	    self.pieChartView.selectionType = IMPieChartSelectionTypeBottom;
		
		// set the background color of the pie chart view
		self.pieChartView.backgroundColor = [UIColor clearColor];
		
		...	    		
	}	

5) Now configure the decorating view at the bottom of viewDidLoad and add it to the view controller's root view. The decorating view is the one placed at the top of the view controller's root view and it contains the pie chart view and the selector view:

	// we center the decorating view on top of the view controller's view...
	self.decoratingView = [[IMPieChartDecoratingView alloc] initWithFrame:CGRectMake((self.view.size.width - 300) / 2
	                                                                                 (self.view.size.height - 300) / 2, 
																					        300, 
																							 300)];
	// The decorating view calculates the size of the selector view base on this is a percentage number 
	// of the size desired for the selector view
	self.decoratingView.sizingFactor = 0.16;
	
	// this is the decorator's delegate which provide the selector view as well as the contained pie chart view
	self.decoratingView.decoratorDelegate = self;
	
	// add decorator view to the view controller's root view
	[self.view addSubview:self.decoratingView];

6) Add the pieChartView to the decorating view:

	// add pieChartView to the decoratingView
	[self.decoratingView addSubview:self.pieChartView];

7) now you can add data per slice using the IMPieSliceDescriptor class. So for that declare a property of type NSArray on your view controller

	@property (nonatomic, strong) NSArray * data;

8) Now on your viewDidLoad method at the bottom after adding the pieChartView to the decoratingView, type the following:

	// IMPieSliceDescriptor accepts as initialization pramenters:
	// - caption, the description text for the slice
	// - value,   the value to render by the slice
	// - color,   the desired color to show by the slice
	self.data = @[[IMPieSliceDescriptor sliceWithCaption:@"Slice 1" value:15 color:IMOpaqueHexColor(0xffd019)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 2" value:25 color:IMOpaqueHexColor(0xff7619)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 3" value:10 color:IMOpaqueHexColor(0x0066ff)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 4" value:5 color:IMOpaqueHexColor(0xff00cc)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 5" value:25 color:IMOpaqueHexColor(0xc60329)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 6" value:5 color:IMOpaqueHexColor(0x9bd305)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 7" value:5 color:IMOpaqueHexColor(0x6f49c6)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 8" value:10 color:IMOpaqueHexColor(0x18b8dd)]];

NOTE:

IMOpaqueHexColor is a macro declared in IMMacroToolbox.h that is used to get some more interesting colors out from the ones that come in stock, and it uses as input the hex value of the color.

9) Now let's implement the pie chart's delegate methods as follows:

	-(void)pieChart:(IMPieChartView *)pieChart didSelectSlice:(IMPieSliceDescriptor *)slice {
		// Here you get the selected slice, which is the slice that passes 
		// through the selection point.
		im_log(@"slice selected %@ with value %@%%", slice.caption, slice.value);
	}
	
	-(void)pieChartIsReady:(IMPieChartView *)pieChart {
		// Here you can perform some extra initialization code whenever you load new data 
		// this method will be caled. In this case we are rotating to the first slice in 
		// the pie.
	   [pieChart rotateToSlice:0 animated:YES];
	}

NOTE:

The macro im_log allows to print debug messages in the console, this macro is declared in the IMMacroToolbox.h and is available when the DEBUG global macro is defined. Basically when you are using the DEBUG scheme.

10) Now let's implement the data source methods as follows:

	-(NSUInteger)pieChartSliceCount:(IMPieChartView *)pieChart {
	   // Here you provide the number of items in the data array.
	   return [self.data count];
	}
	
	-(IMPieSliceDescriptor *)pieChart:(IMPieChartView *)pieChart sliceForIndex:(NSInteger)index {
	   // Here you provide the slice descriptor for the index requested.
	   return self.data[index];
	}

11) Now let's implement the decorator's delegate methods:

	-(UIView *)decoratorSelectorView {
	   return self.selectorView;
	}
	
	-(IMPieChartView *)decoratorPieChartView {
	   return self.pieChartView;
	}
	

Now you are done, that's pretty much it.
