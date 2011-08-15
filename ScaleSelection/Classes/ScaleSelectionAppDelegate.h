//
//  ScaleSelectionAppDelegate.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalesParser.h"

@class Scale;
@class MainViewController;
@class ScalesTableViewController;

@interface ScaleSelectionAppDelegate : NSObject <ScalesParserDelegate,UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	MainViewController *mainViewController;
	ScalesTableViewController *scalesViewController;
	
	NSArray *scales;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIViewController *mainViewController;
@property (nonatomic, retain) IBOutlet ScalesTableViewController *scalesViewController;
@property (nonatomic, retain) NSArray *scales;

- (void)setScale:(Scale *)scale;
- (void)presentScalesController;

@end

