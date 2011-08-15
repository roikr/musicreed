//
//  MusicreedViewController.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MusicalSystem;

@interface MusicreedViewController : UIViewController<NSXMLParserDelegate> {
	UILabel *scaleLabel;
	NSString *scaleName;
	
	
	
}

@property (nonatomic,retain) IBOutlet UILabel *scaleLabel;
@property (nonatomic,retain) NSString *scaleName;



- (void)chooseScale:(id)sender;
- (void)toggle:(id)sender;

@end

