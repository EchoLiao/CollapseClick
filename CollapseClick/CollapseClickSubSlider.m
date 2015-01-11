//
//  CollapseClickSubSlider.m
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/4/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickSubSlider.h"
#import "NYSliderPopover.h"


@interface CollapseClickSubSlider ()
@property (nonatomic, retain) UIImageView  		*bgImg; 	// 201
@property (nonatomic, retain) NYSliderPopover  	*slider; 	// 202
@end


@implementation CollapseClickSubSlider


+ (id)CCSSWithMinValue:(float)min
		  withMaxValue:(float)max
			 withValue:(float)value
		 withSliderTag:(int)tag
		  withDelegate:(id<CollapseClickSubSliderDelegate>)delegate
{
	CGRect sr = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
	rect.origin.x = 0;
	rect.size.width = sr.size.width - (rect.origin.x * 0.0);
	rect.size.height = 80;
	CollapseClickSubSlider *cl = [[CollapseClickSubSlider alloc] initWithFrame:rect];
//	cl.autoresizingMask = 0xFFFFFFFF;
	cl.backgroundColor = [UIColor clearColor];
	cl.sliderTag = tag;
	cl.sliderDelegate = delegate;

	UIView *carr = nil;
	NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CollapseClickSubSlider" owner:nil options:nil];
	for (id obj in objs) {
		if ([obj isKindOfClass:[UIView class]] && [obj tag] == 101) {
			carr = obj;
			break;
		}
	}
	carr.frame = rect;
	cl.bgImg  = (UIImageView *)[carr viewWithTag:201];
	cl.slider = (NYSliderPopover *)[carr viewWithTag:202];
	cl.slider.minimumValue = min;
	cl.slider.maximumValue = max;
	cl.slider.value = cl.oldValue = value;
	[cl.slider addTarget:cl action:@selector(rangeChanged:) forControlEvents:UIControlEventValueChanged];
	[cl.slider addTarget:cl action:@selector(rangeUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cl.slider showPopoverAnimated:NO];
	[cl rangeChanged:cl.slider];
	[cl addSubview:carr];

	return cl;
}


#pragma mark - Slider Events

- (void)rangeChanged:(NYSliderPopover *)sender
{
	int gap = (self.slider.maximumValue - self.slider.minimumValue) / 60;
	gap = gap == 0 ? 1 : gap;
	int val = (((int)self.slider.value) / gap) * gap;
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"%d", val];
}

- (void)rangeUpInside:(NYSliderPopover *)sender
{
	int gap = (self.slider.maximumValue - self.slider.minimumValue) / 60;
	gap = gap == 0 ? 1 : gap;
	int val = (((int)self.slider.value) / gap) * gap;
	self.slider.value = val;
	if ([self.sliderDelegate respondsToSelector:@selector(CCSS:value:)]) {
		[self.sliderDelegate CCSS:self value:sender.value];
	}
}



@end
