//
//  SubsystemTableViewController.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Scale;

@interface SubsystemTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate> {
	
	Scale *currentScale;
	
	UIView *backgroundView;
	UIView *searchBackgroundView;
	NSArray *scales;
	NSMutableArray *searchScales;
	
	UIBarButtonItem *cancelButtonItem;
}


@property (nonatomic, retain) Scale *currentScale;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIView *searchBackgroundView;
@property (nonatomic, retain) NSArray *scales;
@property (nonatomic, retain) NSMutableArray *searchScales;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButtonItem;

- (void)arrangeScales;
- (NSArray *)scalesByView:(UITableView *)tableView;
- (void)filterContentForSearchText:(NSString*)searchText;
- (void)cancel:(id)sender;

@end
