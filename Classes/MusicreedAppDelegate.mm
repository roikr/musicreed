//
//  MusicreedAppDelegate.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicreedAppDelegate.h"
#import "MusicreedViewController.h"
#import "ChordsViewController.h"
#import <OpenGLES/EAGL.h>
#import <AVFoundation/AVFoundation.h>
#import "EAGLView.h"
#include "testApp.h"
#include "Scale.h"
#include "RKMacros.h"
#include "ofMainExt.h"
#include "ScalesTableViewController.h"



@implementation MusicreedAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize viewController;
@synthesize chordsViewController;
@synthesize scalesNavigationController;
@synthesize scalesTable;
@synthesize eAGLView;
@synthesize OFSAptr;
@synthesize currentScale;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	//----- DAMIAN
	// set data path root for ofToDataPath()
	// path on iPhone will be ~/Applications/{application GUID}/openFrameworks.app/data
	// get the resource path for the bundle (ie '~/Applications/{application GUID}/openFrameworks.app')
	NSString *bundle_path_ns = [[NSBundle mainBundle] resourcePath];
	// convert to UTF8 STL string
	string path = [bundle_path_ns UTF8String];
	// append data
	//path.append( "/data/" ); // ZACH
	path.append( "/" ); // ZACH
	ofLog(OF_LOG_VERBOSE, "setting data path root to " + path);
	ofSetDataPathRoot( path );
	//-----
	
	// Override point for customization after application launch.
	self.OFSAptr = new testApp;
	self.eAGLView.OFSAptr = self.OFSAptr;
	self.OFSAptr->setup();
	

    // Add the view controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
	
	ScalesParser *parser = [[[ScalesParser alloc] init] autorelease]; 
	parser.delegate = self;
	[parser parse];
	
    return YES;
}

- (void)beginInterruption {
	RKLog(@"beginInterruption");
	if (OFSAptr) {
		OFSAptr->soundStreamStop();
	}
}

- (void)endInterruptionWithFlags:(NSUInteger)flags {
	RKLog(@"endInterruptionWithFlags: %u",flags);
	
	if (flags && AVAudioSessionInterruptionFlags_ShouldResume) {
		NSError *activationError = nil;
		[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
		RKLog(@"audio session activated");
		if (OFSAptr) {
			OFSAptr->soundStreamStart();
		}
		
	}
	
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[self.eAGLView stopAnimation];
	self.OFSAptr->suspend();
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	self.OFSAptr->resume();
	[self.eAGLView startAnimation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    RKLog(@"applicationDidBecomeActive");
	/*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		RKLog(@"update loop started");
		while ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			
			if (OFSAptr->bRefreshDisplay) {
				dispatch_async(dispatch_get_main_queue(), ^{
					RKLog(@"updateLabel");
					if (OFSAptr->mode != currentScale.mode) {
						for (Scale *scale in scalesTable.scales)
						{
							if (currentScale!=scale && scale.type == currentScale.type && scale.mode == OFSAptr->mode && [scale.system isEqualToString:currentScale.system] ) {
								[self setScale:scale];
								break;
							}
						}
					}
					
					
				});
				OFSAptr->bRefreshDisplay = false; // this should stay out off the main view async call
			}
			
		}
			
		
		RKLog(@"update loop exited");		
	});
	
	
	
	OFSAptr->soundStreamStart();
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self.eAGLView stopAnimation];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
    [viewController release];
	[eAGLView release];
    [window release];
    [super dealloc];
}

- (void)toggle:(UIInterfaceOrientation)orientation animated:(BOOL)animated{
	switch (orientation) {
		case UIInterfaceOrientationPortrait:
			
			ofxiPhoneSetOrientation(UIDeviceOrientationPortrait);
			[self.navigationController dismissModalViewControllerAnimated:animated];
			
			break;
		case UIInterfaceOrientationLandscapeRight:
			ofxiPhoneSetOrientation(UIDeviceOrientationLandscapeRight);
			if (self.chordsViewController == nil) { // this check use in case of loading after warning message...
				self.chordsViewController = [[ChordsViewController alloc] initWithNibName:@"ChordsViewController" bundle:nil];
				chordsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			}
			[self.navigationController presentModalViewController:chordsViewController animated:animated];	
			
			break;
			
		default:
			break;
	}
	
	
//	switch (self.OFSAptr->getState()) {
//		case MUSICREED_STATE_CHORDS:
//			
//			[self.eAGLView setInterfaceOrientation:UIInterfaceOrientationPortrait duration: 0.3];
//			
//			break;
//		case MUSICREED_STATE_SCALES:
//			
//			[self.eAGLView setInterfaceOrientation:UIInterfaceOrientationLandscapeRight duration: 0.3];
//
//			
//			break;
//		default:
//			break;
//	}
	
	[self.eAGLView setInterfaceOrientation:orientation duration: 0.3];
	
}

- (void)setScale:(Scale *)scale {
	currentScale = scale;
	self.OFSAptr->setScale(scale.type,scale.mode,scale.note,scale.divisions,true); 
	viewController.scaleName = scale.name;
}


- (void)presentScalesController {	
	[self.navigationController presentModalViewController:self.scalesNavigationController animated:YES];
}

#pragma mark -
#pragma mark ScalesParser

- (void)parserDidEndParsingData:(ScalesParser *)parser {
	scalesTable.scales = [NSArray arrayWithArray:parser.parsedScales];
	[scalesTable arrangeScales];
	[self setScale:[scalesTable.scales objectAtIndex:0]];
	[self.eAGLView startAnimation];
}


@end
