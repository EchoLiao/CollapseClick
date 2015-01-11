//
//  CollapseClickSubRange.m
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/3/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickSubRange.h"
#import "ACVRangeSelector.h"
#import "Utilities.h"
#import "NSString+Comm.h"


@interface CollapseClickSubRange () <UITextFieldDelegate>
@property (nonatomic, retain) UITextField		*curLeftFld;  // 201
@property (nonatomic, retain) UITextField		*curRightFld; // 202
@property (nonatomic, retain) ACVRangeSelector 	*rangeSld; 	  // 203
@property (nonatomic, retain) UIButton			*applyBtn;    // 204
@property (nonatomic, retain) UILabel		    *minLbl;      // 205
@property (nonatomic, retain) UILabel	     	*maxLbl;      // 206
@property (nonatomic, assign) float minVal;
@property (nonatomic, assign) float maxVal;
@end


@implementation CollapseClickSubRange


+ (id)CCSRWithMinValue:(float)min
		  withMaxValue:(float)max
		 withLeftValue:(float)left
		withRightValue:(float)right
		  withRangeTag:(int)tag
		  withDelegate:(id<CollapseClickSubRangeDelegate>)delegate
{
	CGRect sr = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
	rect.origin.x = 0;
	rect.size.width = sr.size.width - (rect.origin.x * 0.0);
	rect.size.height = 118;
	CollapseClickSubRange *cl = [[CollapseClickSubRange alloc] initWithFrame:rect];
//	cl.autoresizingMask = 0xFFFFFFFF;
	cl.rangeTag = tag;
	cl.rangeDelegate = delegate;

	UIView *carr = nil;
	NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CollapseClickSubRange" owner:self options:nil];
	for (id obj in objs) {
		if ([obj isKindOfClass:[UIView class]] && [obj tag] == 101) {
			carr = obj;
			break;
		}
	}
	carr.frame = rect;
	cl.curLeftFld = (UITextField *)[carr viewWithTag:201];
	cl.curRightFld = (UITextField	*)[carr viewWithTag:202];
	cl.rangeSld  = (ACVRangeSelector *)[carr viewWithTag:203];
	cl.applyBtn  = (UIButton *)[carr viewWithTag:204];
	cl.minLbl = (UILabel *)[carr viewWithTag:205];
	cl.maxLbl = (UILabel *)[carr viewWithTag:206];
	cl.applyBtn.hidden = YES;
	cl.minLbl.text = [Utilities timeToHumanString:min];
	cl.maxLbl.text = [Utilities timeToHumanString:max];
	cl.curLeftFld.delegate = cl;
	cl.curRightFld.delegate = cl;
	cl.rangeSld.minimumValue = cl.minVal = min;
	cl.rangeSld.maximumValue = cl.maxVal = max;
	cl.rangeSld.leftValue = cl.oldLeftValue = left;
	cl.rangeSld.rightValue = cl.oldRightValue = right;
	[cl.rangeSld addTarget:cl action:@selector(rangeChanged:) forControlEvents:UIControlEventValueChanged];
	[cl.rangeSld addTarget:cl action:@selector(rangeUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[cl addSubview:carr];
	
	[cl rangeChanged:cl.rangeSld]; // init values

	return cl;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.applyBtn.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	float val = [textField.text timeStringToSeconds] * 1000.0;
	if (textField.tag == self.curLeftFld.tag) {
		if (self.rangeSld.rightValue <= val)
			self.rangeSld.rightValue = self.maxVal;
		self.rangeSld.leftValue = val;
	} else if (textField.tag == self.curRightFld.tag) {
		if (self.rangeSld.leftValue >= val)
			self.rangeSld.leftValue = self.minVal;
		self.rangeSld.rightValue = val;
	}
	[self rangeChanged:self.rangeSld];
	[self rangeUpInside:self.rangeSld];
}

- (BOOL)               textField:(UITextField *)textField
   shouldChangeCharactersInRange:(NSRange)range
			   replacementString:(NSString *)appStr
{
	NSString *oldStr = textField.text;
	NSString *newStr = [oldStr stringByReplacingCharactersInRange:range withString:appStr];
	NSString *numStr = [newStr stringByReplacingOccurrencesOfString:@":" withString:@""];
	int oldlen =[oldStr length];
	int numLen = [numStr length];
	int h = 0, m = 0, s = 0;
	
	if (oldlen >= [newStr length]) {
		return YES;
	} else if (numLen > 6) {
		return NO;
	} else if (numLen > 0 && numLen <= 2) {
		h = [[numStr substringFromIndex:0] intValue];
	} else if (numLen > 2 && numLen <= 4) {
		h = [[numStr substringToIndex:2] intValue];
		m = [[numStr substringFromIndex:2] intValue];
	} else if (numLen > 4 && numLen <= 6) {
		h = [[numStr substringToIndex:2] intValue];
		m = [[numStr substringWithRange:NSMakeRange(2, 2)] intValue];
		s = [[numStr substringFromIndex:4] intValue];
	}
	if (h >= 60 || m >= 60 || s >= 60) {
		return NO;
	}
	
	float val = ((h*3600 + m*60 + s) * 1000.0);
//	float min = textField.tag == self.curLeftFld.tag ? self.minVal : ([self.curLeftFld.text timeStringToSeconds]+1)*1000;
//	float max = textField.tag == self.curLeftFld.tag ? ([self.curRightFld.text timeStringToSeconds]-1)*1000 : self.maxVal;
	float min = self.minVal;
	float max = self.maxVal;
	if (val >= min && val <= max) {
		if (oldlen == 1 || oldlen == 4) {
			textField.text = [NSString stringWithFormat:@"%@:", newStr];
			return NO;
		} else if (oldlen == 2 || oldlen == 5) {
			textField.text = [NSString stringWithFormat:@"%@:", oldStr];
		}
		return YES;
	}
	
	return NO;
}


#pragma mark - Buttons Action

-(IBAction)applyButton:(id)sender
{
	self.applyBtn.hidden = YES;
	if ([self.curLeftFld isFirstResponder])
		[self.curLeftFld resignFirstResponder];
	if ([self.curRightFld isFirstResponder])
		[self.curRightFld resignFirstResponder];
}


#pragma mark - ACVRangeSelector Events

- (void)rangeChanged:(ACVRangeSelector *)sender
{
    self.curLeftFld.text = [Utilities timeToHumanString:sender.leftValue];
    self.curRightFld.text = [Utilities timeToHumanString:sender.rightValue];
}

- (void)rangeUpInside:(ACVRangeSelector *)sender
{
	if ([self.rangeDelegate respondsToSelector:@selector(CCSR:leftValue:rightValue:)]) {
		[self.rangeDelegate CCSR:self leftValue:sender.leftValue rightValue:sender.rightValue];
	}
}


@end
