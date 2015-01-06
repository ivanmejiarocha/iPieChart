//
//  IMPieChartView.m
//  PieChart
//
//  Created by Ivan Mejia on 12/28/14.
//  Copyright (c) 2014 Ivan Mejia. All rights reserved.
//

@import GLKit;

#import "IMPieChartView.h"
#import "IMMacroToolbox.h"

@interface IMPieChartView ()
{
   GLKVector3              _origin;
   BOOL                    _userIsDragging;
   CGPoint                 _selectionPoint;
   IMPieChartSelectionType _selectionType;
}

@property (nonatomic, strong) IMPieChartLayer * pieChart;
@property (nonatomic, strong) IMPieChartView * pieChartView;

@end

@implementation IMPieChartView

#pragma mark - Initialization and construction

-(id)initWithCoder:(NSCoder *)aDecoder {
   if ((self = [super initWithCoder:aDecoder]) != nil) {
      [self basicInitialization];
   }
   return self;
}

-(id)initWithFrame:(CGRect)frame {
   if ((self = [super initWithFrame:frame]) != nil) {
      [self basicInitialization];
   }
   return self;
}

-(void)basicInitialization {
   
   // Initialize the pie chart layer
   self.pieChart = [[IMPieChartLayer alloc] init];
   self.pieChart.pieChartView = self;
   self.enableShadow = YES;
   self.radiusFactor = 1.0f;
   self.animationType = IMPieChartAnimationTypeMechanicGear;
   self.selectionType = IMPieChartSelectionTypeBottom;
   self.pieChart.frame = CGRectMake(0, (self.frame.size.height - self.frame.size.width) / 2, self.frame.size.width, self.frame.size.width);
   [self.layer addSublayer:self.pieChart];
   _userIsDragging = NO;   
}

-(void)layoutSubviews {
   self.pieChart.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
   [self.pieChart setNeedsDisplay];
   _origin = GLKVector3Make(self.pieChart.position.x, self.pieChart.position.y, 0);
   
   im_log(@"pieChart.size = (%5.2f, %5.2f)", self.pieChart.bounds.size.width, self.pieChart.bounds.size.height);
   im_log(@"pieChart.origin = (%5.2f, %5.2f)", self.pieChart.position.x, self.pieChart.position.y);
 
   switch (_selectionType) {
      case IMPieChartSelectionTypeBottom:
         _selectionPoint = CGPointMake(self.pieChart.frame.size.width / 2.0, self.pieChart.frame.size.height - 5);
         break;
         
      case IMPieChartSelectionTypeTop:
         _selectionPoint = CGPointMake(self.pieChart.frame.size.width / 2.0, self.pieChart.frame.origin.y + 5);
         break;
         
      case IMPieChartSelectionTypeLeft:
         _selectionPoint = CGPointMake(self.pieChart.frame.origin.x + 5, self.pieChart.frame.size.height / 2.0);
         break;
         
      case IMPieChartSelectionTypeRight:
         _selectionPoint = CGPointMake(self.pieChart.frame.size.width - 5, self.pieChart.frame.size.height / 2.0);
         break;
   }

   im_log(@"bottomSelPoint (%2.2f, %2.2f)", _selectionPoint.x, _selectionPoint.y);
}

#pragma mark - Public methods

-(void)rotateToSlice:(NSUInteger)sliceIndex animated:(BOOL)animated {
   // get the slice at the provided index...
   IMPieSliceDescriptor * slice = [self.pieChartDataSource pieChart:self sliceForIndex:sliceIndex];
   // rotate...
   [self autoRotateToSlice:slice withAnimation:animated];
   // inform current selection...
   [self.pieChartDelegate pieChart:self didSelectSlice:slice];
}

-(void)reloadData {
   [self setNeedsDisplay];
}

#pragma mark - Properties

-(IMPieChartSelectionType)selectionType {
   return _selectionType;
}

-(void)setSelectionType:(IMPieChartSelectionType)selectionType {
   _selectionType = selectionType;
}

#pragma mark - Rotation math methods

-(GLKVector3)pointToVector:(CGPoint)point {
   // convert the point into a vector assuming Z at 0 due to we are not handling perspective
   // but as a convinient value used when calculating the direction of the rotation.
   GLKVector3 vectorPoint = GLKVector3Make(point.x, point.y, 0);
   
   // translate the point to the new origin and normilize the resulting vector to the magnitud is always 1.
   return GLKVector3Normalize(GLKVector3Subtract(_origin, vectorPoint));
}

-(CGFloat)rotationAngleFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
   GLKVector3 startPointVec = [self pointToVector:startPoint];
   GLKVector3 endPointVec = [self pointToVector:endPoint];
   
   // IMPORTANT NOTE:
   //    Compute the displacement angle using the resulting magnitud of substracting the vector point at the
   //    end of the movement with the start point and whe use the magnitud of the resulting vector as the angle
   //    value.
   GLKVector3 displacement = GLKVector3Subtract(endPointVec, startPointVec);
   CGFloat rotationAngle = GLKVector3Length(displacement);
   
   // Calculate the rotation direction using the cross product of the end and start vectors and if the value of Z
   // is negative, then the rotation goes clockwise otherwise goes conterclockwise.
   GLKVector3 crossPorduct = GLKVector3CrossProduct(endPointVec, startPointVec);
   CGFloat rotationDirection = crossPorduct.z > 0 ? -1 : 1;
   im_log(@"rotation direction %f", rotationDirection);
   
   // compute the rotation angle including the direction.
   return rotationAngle * rotationDirection;
}

-(CGFloat)distanceToCenter:(CGPoint)touchPoint {
   CGFloat deltaX = touchPoint.x - _origin.x;
   CGFloat deltaY = touchPoint.y - _origin.y;
   
   // calculate the distance between two points.
   return sqrtf((deltaX * deltaX) + (deltaY * deltaY));
}

-(CGFloat)calculateAngleAtSelectionPoint:(CGPoint)selectionPoint {
   // Normalizing the selection point vector provides us with a vector of magnitud 1.
   GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(-selectionPoint.y, selectionPoint.x));
   
   //
   // IMPORTANT NOTE:
   //     From trigonometry we know that cos(angle) = adjacent / hypotenuse; additionally (as in the line above)
   //     we normalize the selectionPoint which becomes in our direction vector which is the hypotenuse (of magnitud = 1)
   //     of the triangle formed between the touchpoint, the origin and the coordinate in Y (the adjacent).
   //     So by value substitution we have that:
   //
   //     cos(angle) = Y / 1 so cos(angle) = Y and the acos(Y) = angle and the angle is what we need ;)
   //
   //     check out here a clearer explanation in case you need it:
   //     http://chimera.labs.oreilly.com/books/1234000001814/ch03.html#OnFingerMove
   //
   CGFloat angle = acos(direction.y);
   if (direction.x > 0)
      angle = -angle;
   return angle;
}

-(CGPoint)calculateTouchInPie:(CGPoint)touchPoint {
   if ([self.pieChart hitTest:touchPoint] == self.pieChart) {
      CGPoint pointInPie = [self.layer convertPoint:touchPoint toLayer:self.pieChart];
      // convert touch point into a vector
      GLKVector2 touchVector = GLKVector2Make(pointInPie.x, pointInPie.y);
      // calculate the pivot point which acts as our origin where the touches move in a circular orbit
      GLKVector2 pivotVector = GLKVector2Make(self.pieChart.bounds.size.width / 2.0f, self.pieChart.bounds.size.height / 2.0f);
      // calculate the point in vector by performing a verctor subtraction between the touchVector and the pivotVector
      GLKVector2 pointInPieVector = GLKVector2Subtract(touchVector, pivotVector);
      return CGPointMake(pointInPieVector.x, pointInPieVector.y);
   }
   return CGPointZero;
}

-(void)autoRotateToSlice:(IMPieSliceDescriptor *)slice withAnimation:(BOOL)animation {
   CGPoint touchInPie = [self calculateTouchInPie:_selectionPoint];
   CGFloat centerAngle = slice.startAngle + (slice.endAngle - slice.startAngle) / 2;
   CGFloat angleAtSelectionPoint = [self calculateAngleAtSelectionPoint:touchInPie];
   CGFloat displacementAngle = angleAtSelectionPoint - centerAngle;
   CATransform3D fromTrans = self.layer.sublayerTransform;
   CATransform3D toTrans = CATransform3DRotate(fromTrans, displacementAngle, 0, 0, 1);
   self.layer.sublayerTransform = toTrans;
   
   if (animation) {
      CAAnimation * autoselectionAnimation = [self selectedAnimationTypeWithTransform:fromTrans toTrans:toTrans];//[self createAutoselectionMechanicAnimationFrom:fromTrans to:toTrans];
      if (autoselectionAnimation != nil) {
         [self.layer addAnimation:autoselectionAnimation forKey:nil];
      }
   }
}

#pragma mark - Touch handling code

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#ifdef DEBUG
   UITouch * touch = [touches anyObject];
   CGPoint touchPoint = [touch locationInView:self];
   im_log(@"touch point (x: %f, y: %f)", touchPoint.x, touchPoint.y);
#endif
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   // the user started to rotate the pie ...
   im_log(@"origin (%f, %f)", _origin.x, _origin.y);
   // get the touch information.
   UITouch * touch = [touches anyObject];
   // get the previous touch in our view
   CGPoint startPoint = [touch previousLocationInView:self];
   
   // avoid passing through the center or out of the cicle perimeter, so the rotation keeps stady.
   CGFloat distance = [self distanceToCenter:startPoint];
   CGFloat outterLimit = (self.bounds.size.width / 2);
   CGFloat innerLimit = outterLimit / 4;
   if (distance < innerLimit || distance > outterLimit) {
      return;
   }
   
   // get current touch point on our view
   CGPoint endPoint = [touch locationInView:self];
   
   // test the touch hits our view's sublayer
   if ([self.layer.sublayers[0] hitTest:endPoint]) {
      // if we reach this point in code then is official, the user is starting to rotate the pie
      _userIsDragging = YES;
      // get current transform which contains current rotation transform so we rotate from here to the next angle
      CATransform3D currentTransform = self.layer.sublayerTransform;
      // compute rotation angle.
      CGFloat rotationAngle = [self rotationAngleFromPoint:startPoint toPoint:endPoint];
      
      // compute the slice selected by a fixed selection point...
      IMPieSliceDescriptor * slice = [self.pieChart pieSliceDescriptorAtPoint:[self calculateTouchInPie:_selectionPoint]];
      if (slice != nil) {
         im_log(@"slice %@", slice.caption);
         if ([self.pieChartDelegate respondsToSelector:@selector(pieChart:didSelectSlice:)]) {
            [self.pieChartDelegate pieChart:self didSelectSlice:slice];
         }
      }
      
      // compute new rotation transform (we pass 1 on z because we rotate on that axis)
      CATransform3D rotationTransform = CATransform3DRotate(currentTransform, rotationAngle, 0, 0, 1);
      
      // apply rotation transform to our view's layer
      self.layer.sublayerTransform = rotationTransform;
   }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   if (_userIsDragging) { // handle end of dragging
      // compute touch in pie passing a fixed selection point...
      CGPoint touchInPie = [self calculateTouchInPie:_selectionPoint];
      IMPieSliceDescriptor * slice = [self.pieChart pieSliceDescriptorAtPoint:touchInPie];
      // perform roation animation
      [self autoRotateToSlice:slice withAnimation:YES];
   }
   else { // handle end of touch
      UITouch * touch = [touches anyObject];
      CGPoint touchPoint = [touch locationInView:self];
      CGPoint touchInPie = [self calculateTouchInPie:touchPoint];
      IMPieSliceDescriptor * slice = [self.pieChart pieSliceDescriptorAtPoint:touchInPie];
      if (slice) {
         // perform rotation animation
         [self autoRotateToSlice:slice withAnimation:YES];
         
         // compute the slice selected by a fixed selection point...
         IMPieSliceDescriptor * slice = [self.pieChart pieSliceDescriptorAtPoint:[self calculateTouchInPie:_selectionPoint]];
         if (slice != nil) {
            im_log(@"slice %@", slice.caption);
            if ([self.pieChartDelegate respondsToSelector:@selector(pieChart:didSelectSlice:)]) {
               [self.pieChartDelegate pieChart:self didSelectSlice:slice];
            }
         }

      }
   }
   _userIsDragging = NO;
}

#pragma mark - Animations

-(CAAnimation *) selectedAnimationTypeWithTransform:(CATransform3D)fromTrans toTrans:(CATransform3D)toTrans {
   switch (self.animationType) {
      case IMPieChartAnimationTypeMechanicGear:
         return [self createAutoselectionMechanicAnimationFrom:fromTrans to:toTrans];
         
      case IMPieChartAnimationTypeBouncing:
         return [self createAutoselectionBouncingAnimationFrom:fromTrans to:toTrans];
   }
}

-(CABasicAnimation *) createAutoselectionMechanicAnimationFrom:(CATransform3D)fromTans to:(CATransform3D)toTrans {
   CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
   animation.fromValue = [NSValue valueWithCATransform3D:fromTans];
   animation.toValue = [NSValue valueWithCATransform3D:toTrans];
   animation.duration = 0.25;
   animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.9 :0.1 :0.7 :0.9];
   return animation;
}

-(CABasicAnimation *) createAutoselectionBouncingAnimationFrom:(CATransform3D)fromTrans to:(CATransform3D)toTrans {
   CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
   animation.fromValue = [NSValue valueWithCATransform3D:fromTrans];
   animation.toValue = [NSValue valueWithCATransform3D:toTrans];
   animation.duration = 0.30;
   animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :.8 :0.8];
   return animation;
}

@end

