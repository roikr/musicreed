//
//  MusicreedAppDelegate.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MusicreedViewController;
@class EAGLView;
@class MusicalScale;
@class MusicalSystem;
class testApp;

@interface MusicreedAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;	
	MusicreedViewController *viewController;
	EAGLView *eAGLView;
	testApp *OFSAptr;
	
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet MusicreedViewController *viewController;
@property (nonatomic, retain) IBOutlet EAGLView *eAGLView;
@property  testApp *OFSAptr;

- (void) setCurrentScale:(MusicalScale *)scale withSystem:(MusicalSystem *)system;


@end

