//
//  MusicreedViewController.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicreedViewController.h"
#import "Scale.h"
#import "TouchView.h"
#import "MusicreedAppDelegate.h"
#import "RKMacros.h"
#import "testApp.h"


@interface MusicreedViewController()

@end



@implementation MusicreedViewController

@synthesize scaleLabel;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// roikr: first time check...for memory warning
	((TouchView *)self.view).OFSAptr = ((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr;
	
	
	//if (self.scalesTable == nil) {
//		self.scalesTable = [[ScalesTable alloc] initWithNibName:@"ScalesTable" bundle:nil];
//		((TouchView *)self.view).OFSAptr = ((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr;
//		
//		
//	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"MusicreedViewController::viewWillAppear");
	self.scaleLabel.text = scaleName;
//	if (self.scalesTable) {
//		scaleLabel.text = self.scalesTable.currentScale.name;
//		[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentScale:scalesTable.currentScale withSystem:scalesTable.currentSystem];
//	}
	
	((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr->stopTaqsim();
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)chooseScale:(id)sender {
	[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] presentScalesController];
//	[self presentModalViewController:self.scalesTable animated:YES];
}

- (void)toggle:(id)sender {
	
	[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] toggle:UIInterfaceOrientationLandscapeRight animated:0.3];
}

-(void) setScaleName:(NSString *)name {
	scaleName = name;
	self.scaleLabel.text = scaleName;
}

-(NSString *) scaleName {
	return scaleName;
}


@end
