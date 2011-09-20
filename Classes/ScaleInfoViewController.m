//
//  ScaleInfoViewController.m
//  Musicreed
//
//  Created by Roee Kremer on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScaleInfoViewController.h"
#import "Scale.h"


@implementation ScaleInfoViewController

@synthesize url;

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
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	webView.delegate = nil;
	[url release];
    [super dealloc];
}

-(void)loadScale:(Scale*)scale {
	self.url = [NSURL URLWithString:@"http://www.musicreed.com/"];
	
	self.title = NSLocalizedString(scale.name, @"scale info navigation title");
}



@end
