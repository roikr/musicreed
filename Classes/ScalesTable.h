//
//  ScalesTable.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicalSystem.h"

@class MusicalSystem;
@class MusicalScale;
@interface ScalesTable : UITableViewController {
	
	
	
	
	
	UITableViewCell *scaleCell;
	
	MusicalSystem *currentSystem;
	MusicalScale *currentScale;
	
	UIView *backgroundView;
	NSArray *musicalSystems;
	
}


@property (nonatomic, assign) IBOutlet UITableViewCell *scaleCell;
@property (nonatomic, retain) MusicalSystem *currentSystem;
@property (nonatomic, retain) MusicalScale *currentScale;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) NSArray *musicalSystems;
@end
