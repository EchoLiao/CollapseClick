//
//  CollapseClickSubRange.h
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/3/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CollapseClickSubRangeDelegate;
@interface CollapseClickSubRange : UIView

@property (nonatomic, assign) id<CollapseClickSubRangeDelegate> rangeDelegate;
@property (nonatomic, assign) int								rangeTag;
@property (nonatomic, assign) float 	oldLeftValue;
@property (nonatomic, assign) float 	oldRightValue;

+ (id)CCSRWithMinValue:(float)min
		  withMaxValue:(float)max
		 withLeftValue:(float)left
		withRightValue:(float)right
		  withRangeTag:(int)tag
		  withDelegate:(id<CollapseClickSubRangeDelegate>)delegate;

@end




@protocol CollapseClickSubRangeDelegate <NSObject>
@optional

-(void)CCSR:(CollapseClickSubRange *)range leftValue:(float)left rightValue:(float)right;

@end
