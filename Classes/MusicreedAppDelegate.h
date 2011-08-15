//
//  MusicreedAppDelegate.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ScalesParser.h"

@class MusicreedViewController;
@class ChordsViewController;
@class EAGLView;
@class Scale;
@class ScalesTableViewController;

class testApp;


@interface MusicreedAppDelegate : NSObject <ScalesParserDelegate,UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;	
	MusicreedViewController *viewController;
	ChordsViewController *chordsViewController;
	UINavigationController *scalesNavigationController;
	ScalesTableViewController *scalesTable;
	
	EAGLView *eAGLView;
	testApp *OFSAptr;
	
	Scale* currentScale;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet MusicreedViewController *viewController;
@property (nonatomic, retain) ChordsViewController *chordsViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *scalesNavigationController;
@property (nonatomic, retain) IBOutlet ScalesTableViewController *scalesTable;
@property (nonatomic, retain) IBOutlet EAGLView *eAGLView;
@property  testApp *OFSAptr;
@property (nonatomic, retain) Scale *currentScale;

- (void)toggle:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

- (void)setScale:(Scale *)scale;
- (void)presentScalesController;

@end

