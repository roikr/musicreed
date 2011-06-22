//
//  MusicreedViewController.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScalesTable;
@class MusicalSystem;

@interface MusicreedViewController : UIViewController<NSXMLParserDelegate> {
	UILabel *scaleLabel;
	ScalesTable *scalesTable;
	
	MusicalSystem *currentMusicalSystem;
	NSMutableArray *parsedMusicalSystems;
	
}

@property (nonatomic,retain) IBOutlet UILabel *scaleLabel;
@property (nonatomic,retain) ScalesTable *scalesTable;

@property (nonatomic, retain) MusicalSystem *currentMusicalSystem;
@property (nonatomic, retain) NSMutableArray *parsedMusicalSystems;

- (void)chooseScale:(id)sender;
- (void)updateLabelWithMode:(NSUInteger)mode;
- (void)toggle:(id)sender;

@end

