//
//  MusicreedViewController.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScalesTable;

@interface MusicreedViewController : UIViewController {
	UILabel *scaleLabel;
	ScalesTable *scalesTable;
}

@property (nonatomic,retain) IBOutlet UILabel *scaleLabel;
@property (nonatomic,retain) ScalesTable *scalesTable;

- (void)chooseScale:(id)sender;

@end

