//
//  ScalesTableViewController.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesParser.h"

@class Scale;

@interface ScalesTableViewController : UITableViewController<ScalesParserDelegate,UISearchDisplayDelegate, UISearchBarDelegate> {

	UITableViewCell *scaleCell;
	
	Scale *currentScale;
	
	UIView *backgroundView;
	UIView *searchBackgroundView;
	NSArray *scales;
	NSMutableArray *sections;
	NSMutableArray *searchSections;
	
}


@property (nonatomic, assign) IBOutlet UITableViewCell *scaleCell;
@property (nonatomic, retain) Scale *currentScale;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIView *searchBackgroundView;
@property (nonatomic, retain) NSArray *scales;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *searchSections;

- (void)arrangeContent;
- (void)filterContentForSearchText:(NSString*)searchText;
@end



