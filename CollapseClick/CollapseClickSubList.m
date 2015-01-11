//
//  CollapseClickSubList.m
//  CollapseClickDemo
//
//  Created by erlz nuo on 9/3/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickSubList.h"


#define kCCSLItemCellHeight		44.0



@interface CollapseClickSubList () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray		*items;
@property (nonatomic, retain) NSObject		*curItem;
@property (nonatomic, retain) NSIndexPath	*curSel;
@end



@implementation CollapseClickSubList


#pragma mark - Class Methods

+ (id)CCSLWithItems:(NSArray *)items
		withCurItem:(NSObject *)curItem
		withListTag:(int)tag
	   withDelegate:(id<CollapseClickSubListDelegate>)delegate
{
	CGRect sr = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
	rect.origin.x = 20;
	rect.size.width = sr.size.width - (rect.origin.x * 2.0);
	rect.size.height = kCCSLItemCellHeight * (items.count >= 5 ? 5 : items.count);
	CollapseClickSubList *cl = [[CollapseClickSubList alloc] initWithFrame:rect];
//	cl.autoresizingMask = 0xFFFFFFFF;
	cl.rowHeight = kCCSLItemCellHeight;
	cl.items = items;
	cl.curItem = curItem;
	cl.listTag = tag;
	cl.listDelegate = delegate;
	cl.delegate = cl;
	cl.dataSource = cl;
	cl.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	cl.separatorColor = [UIColor colorWithRed:78/255.0 green:22/255.0 blue:114/255.0 alpha:0.15];

	for (int i = 0; i < cl.items.count; i++) {
		if ([cl.curItem isEqual:cl.items[i]]) {
			cl.curSel = [NSIndexPath indexPathForRow:i inSection:0];
			break;
		}
	}

	return cl;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (void)configureCell:(UITableViewCell*)aCell forIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = aCell;
	int row = indexPath.row;
	cell.textLabel.text = self.items[row];
	if (self.curSel && self.curSel.row == row) {
		cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"py_tick"]];
	} else {
		cell.accessoryView = nil;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)index
{
	static NSString *idt = @"CollapseClickSubListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idt];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idt];
        cell.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.accessoryType = UITableViewCellAccessoryCheckmark;
//		cell.textLabel.font = [UIFont systemFontOfSize:17.0];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
		cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.70];
    }
	[self configureCell:cell forIndexPath:index];
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath compare:self.curSel] != NSOrderedSame) {
		if ([self.listDelegate respondsToSelector:@selector(CCSL:index:item:)]) {
			[self.listDelegate CCSL:self index:indexPath.row item:self.items[indexPath.row]];
		}
		NSIndexPath *last = self.curSel ? self.curSel : indexPath;
		self.curSel = indexPath;
		[self updateCellWithIndexPaths:@[last, self.curSel]];
	}
}


#pragma mark -

- (void)updateCellWithIndexPaths:(NSArray *)indexPaths
{
	for (NSIndexPath *idx in indexPaths) {
		UITableViewCell *cell = [self cellForRowAtIndexPath:idx];
        [self configureCell:cell forIndexPath:idx];
		[cell setNeedsDisplay];
	}
}


@end
