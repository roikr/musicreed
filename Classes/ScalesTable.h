//
//  ScalesTable.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicalSystem.h"

@interface ScalesTable : UITableViewController<NSXMLParserDelegate> {
	
	
	MusicalSystem *currentMusicalSystem;
	NSMutableArray *parsedMusicalSystems;
	
}

@property (nonatomic, retain) MusicalSystem *currentMusicalSystem;
@property (nonatomic, retain) NSMutableArray *parsedMusicalSystems;
@end
