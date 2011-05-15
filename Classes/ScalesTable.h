//
//  ScalesTable.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicalSystem.h"

@class MusicalScale;
@interface ScalesTable : UITableViewController<NSXMLParserDelegate> {
	
	
	MusicalSystem *currentMusicalSystem;
	NSMutableArray *parsedMusicalSystems;
	
	UITableViewCell *scaleCell;
	
	MusicalScale *currentScale;
	
	UIView *backgroundView;
	
}

@property (nonatomic, retain) MusicalSystem *currentMusicalSystem;
@property (nonatomic, retain) NSMutableArray *parsedMusicalSystems;

@property (nonatomic, assign) IBOutlet UITableViewCell *scaleCell;
@property (nonatomic, retain) MusicalScale *currentScale;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;

@end
