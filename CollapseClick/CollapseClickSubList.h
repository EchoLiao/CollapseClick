//
//  CollapseClickSubList.h
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/3/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CollapseClickSubListDelegate;
@interface CollapseClickSubList : UITableView

@property (nonatomic, assign) id<CollapseClickSubListDelegate> 	listDelegate;
@property (nonatomic, assign) int								listTag;

+ (id)CCSLWithItems:(NSArray *)items
		withCurItem:(NSObject *)curItem
		withListTag:(int)tag
	   withDelegate:(id<CollapseClickSubListDelegate>)delegate;

@end




@protocol CollapseClickSubListDelegate <NSObject>
@optional

-(void)CCSL:(CollapseClickSubList *)list index:(int)index item:(NSObject *)item;

@end
