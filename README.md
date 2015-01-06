iPieChart
==============

Objective
--------------
PieChart was concived after my learning of linear algebra's simple vectors arithmetic. I found interesting the idea to start practicing my reacent learning in an interactive Pie Chart control. This control so far is in its basic stage but can be used by anybody and extended to fit your needs. This is a work in progress and any feedback ideas or improvements will be greatly appreciated.

How to use it
--------------
You need to include in your project the following files:

- IMPieChartView.m
- IMPieChartView.h
- IMPieChartLayer.m
- IMPieChartLayer.h
- IMPieSliceDescriptor.m
- IMPieSliceDescriptor.h
- IMMacroToolbox.h

Then on your View Controller implement the protocols IMPieChartViewDelegate and IMPieChartViewDataSource

	@interface MyViewController : UIViewController < IMPieChartDelegate, IMPieChartDataSource >

then declare a property of type IMPieChartView

	@property (nonatomic, strong) IMPieChartView * pieChartView;

then on the viewDidLoad method you configure the pie using the following properties:

	 @property (nonatomic, strong)

    -(void)viewDidLoad {
		// create the chart pie
		self.pieChartView = [[IMPieChartView alloc] initWithFrame:CGRect(self.view.size.width, 0, 300, 300)];
	
	    // setup the delegate 
	    self.pieChartView.pieChartDelegate = self;
	
		// setup the datasource
	    self.pieChartView.pieChartDataSource = self;
	
		// this will enable showing a drop shadow under the pie chart
	    self.pieChartView.enableShadow = YES;
	
		// this is a factor applied to the radius so the drop shadow can be shown without clipping
	    self.pieChartView.radiusFactor = 0.9;
	
		// you can specify the type of animation you want the pie perform when dragging ends
		// or an slice is selected
	    self.pieChartView.animationType = IMPieChartAnimationTypeMechanicGear;
	
		// you can locate the selection point in the top, left, right or bottom of the pie chart.
	    self.pieChartView.selectionType = IMPieChartSelectionTypeBottom;
		
		// add the pie chart to the view controller's main view
		[self.view addSubview];
		...
	}	

now you can add data per slice using the IMPieSliceDescriptor class, for that declare a property of type NSArray on your view controller

	@property (nonatomic, strong) NSArray * data;

then again on your viewDidLoad method at the bottom of the pie chart configuration type the following:

	self.data = @[[IMPieSliceDescriptor sliceWithCaption:@"Slice 1" value:15 color:IMOpaqueHexColor(0xffd019)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 2" value:25 color:IMOpaqueHexColor(0xff7619)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 3" value:10 color:IMOpaqueHexColor(0x0066ff)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 4" value:5 color:IMOpaqueHexColor(0xff00cc)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 5" value:25 color:IMOpaqueHexColor(0xc60329)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 6" value:5 color:IMOpaqueHexColor(0x9bd305)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 7" value:5 color:IMOpaqueHexColor(0x6f49c6)],
                 [IMPieSliceDescriptor sliceWithCaption:@"Slice 8" value:10 color:IMOpaqueHexColor(0x18b8dd)]];

NOTE:

IMOpaqueHexColor is a macro declared in IMMacroToolbox.h that is used to get some more interesting colors out from the ones that come in stock.

Now let's implement the delegate methods as follows:

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

Now let's implement the data source methods as follows:

	-(NSUInteger)pieChartSliceCount:(IMPieChartView *)pieChart {
	   // Here you provide the number of items in the data array.
	   return [self.data count];
	}
	
	-(IMPieSliceDescriptor *)pieChart:(IMPieChartView *)pieChart sliceForIndex:(NSInteger)index {
	   // Here you provide the slice descriptor for the index requested.
	   return self.data[index];
	}

That's pretty much it.
