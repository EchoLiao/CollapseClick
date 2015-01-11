//
//  CollapseClickSubSlider.h
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/4/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CollapseClickSubSliderDelegate;
@interface CollapseClickSubSlider : UIView

@property (nonatomic, assign) id<CollapseClickSubSliderDelegate>	sliderDelegate;
@property (nonatomic, assign) int									sliderTag;
@property (nonatomic, assign) float 	oldValue;

+ (id)CCSSWithMinValue:(float)min
		  withMaxValue:(float)max
			 withValue:(float)value
		 withSliderTag:(int)tag
		  withDelegate:(id<CollapseClickSubSliderDelegate>)delegate;

@end




@protocol CollapseClickSubSliderDelegate <NSObject>
@optional

-(void)CCSS:(CollapseClickSubSlider *)range value:(float)value;

@end
