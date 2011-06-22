//
//  ChordsViewController.m
//  Milgrom
//
//  Created by Roee Kremer on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChordsViewController.h"
#import "TouchView.h"
#import "MusicreedAppDelegate.h"

@implementation ChordsViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	((TouchView *)self.view).OFSAptr = ((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr; // roikr: only for the first time
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)toggle:(id)sender {
	
	[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] toggle:UIInterfaceOrientationPortrait animated:0.3];
}

@end
