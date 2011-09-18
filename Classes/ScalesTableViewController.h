//
//  ScalesTableViewController.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Scale;

@interface ScalesTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate> {

	Scale *currentScale;
	
	UIView *backgroundView;
	UIView *searchBackgroundView;
	NSArray *scales;
	NSMutableArray *sections;
	NSMutableArray *searchSections;
	
	UIBarButtonItem *cancelButtonItem;
		
}

@property (nonatomic, retain) Scale *currentScale;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIView *searchBackgroundView;
@property (nonatomic, retain) NSArray *scales;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *searchSections;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButtonItem;

- (void)arrangeScales;
- (NSMutableArray *)sectionsByView:(UITableView *)tableView;
- (void)filterContentForSearchText:(NSString*)searchText;
- (void)cancel:(id)sender;
@end



