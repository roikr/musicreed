//
//  MusicreedViewController.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicreedViewController.h"
#import "ScalesTable.h"
#import "MusicalSystem.h"
#import "MusicalScale.h"
#import "TouchView.h"
#import "MusicreedAppDelegate.h"
#import "RKMacros.h"


@interface MusicreedViewController()
- (void)parse;

@end



@implementation MusicreedViewController

@synthesize scaleLabel;
@synthesize scalesTable;
@synthesize currentMusicalSystem;
@synthesize parsedMusicalSystems;


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
	
	if (!self.parsedMusicalSystems) {
		[self parse];
	}
	
	if (self.scalesTable == nil) {
		self.scalesTable = [[ScalesTable alloc] initWithNibName:@"ScalesTable" bundle:nil];
		((TouchView *)self.view).OFSAptr = ((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr;
		
		scalesTable.musicalSystems = [NSArray arrayWithArray:parsedMusicalSystems];
		scalesTable.currentSystem = [scalesTable.musicalSystems objectAtIndex:0];
		scalesTable.currentScale = [scalesTable.currentSystem.scales objectAtIndex:0];
	}
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
	if (self.scalesTable) {
		scaleLabel.text = self.scalesTable.currentScale.name;
		[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentScale:scalesTable.currentScale withSystem:scalesTable.currentSystem];
	}
	
	
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
	
	[self presentModalViewController:self.scalesTable animated:YES];
}

- (void)toggle:(id)sender {
	
	[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] toggle:UIInterfaceOrientationLandscapeRight animated:0.3];
}

- (void)updateLabelWithMode:(NSUInteger)mode {
	RKLog(@"updateLabel");
	for (int i=0; i<[scalesTable.currentSystem.scales count]; i++) {
		MusicalScale *scale = [scalesTable.currentSystem.scales objectAtIndex:i];
		if (scale.type == scalesTable.currentScale.type && scale.mode == mode) {
			scalesTable.currentScale = scale;
			scaleLabel.text = scalesTable.currentScale.name;
			break;
		}
	}
	

	
}

#pragma mark -
#pragma mark Parser

- (void)parse {
	
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"systems" ofType:@"xml"]]];
	self.parsedMusicalSystems = [NSMutableArray array];
	
	[parser setDelegate:self];
	[parser parse];
	
	
	
	
}



#pragma mark -
#pragma mark Parser constants


// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kSystemElementName = @"system";
static NSString * const kScaleElementName = @"scale";


#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:kSystemElementName]) {
		NSUInteger numDivisions = 12;
		NSNumber *value = [attributeDict valueForKey:@"divisions"];
		if (value ) {
			numDivisions = [value integerValue];
		}
		MusicalSystem *system = [MusicalSystem musicalSystemWithName:[attributeDict valueForKey:@"name"] withNumDivisions:numDivisions];
		self.currentMusicalSystem = system;
		[system release];
		//NSLog(@"system: %@",[attributeDict valueForKey:@"name"]);
    } else if ([elementName isEqualToString:kScaleElementName]) {
		[currentMusicalSystem addScaleWithName:[attributeDict valueForKey:@"name"]  withType:[[attributeDict valueForKey:@"scale"] integerValue]  withMode:[[attributeDict valueForKey:@"mode"] integerValue] withFirstNote:[[attributeDict valueForKey:@"note"] floatValue] withFilename:[attributeDict valueForKey:@"filename"]  ];
		//NSLog(@"scale: %@",[attributeDict valueForKey:@"name"]);
	} 
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {     
    
	if ([elementName isEqualToString:kSystemElementName]) {
		[parsedMusicalSystems addObject:self.currentMusicalSystem];
    }
	
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"foundCharacters: %@",string);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseErrorOccurred: %@",[parseError description]);
}





@end
