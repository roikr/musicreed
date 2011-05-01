//
//  ScalesTable.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScalesTable.h"
#import "MusicalScale.h"

@interface ScalesTable ()

- (void)parse;

@end

@implementation ScalesTable

@synthesize currentMusicalSystem;
@synthesize parsedMusicalSystems;

@synthesize scaleCell;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!parsedMusicalSystems) {
		[self parse];
	}
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
		MusicalSystem *system = [MusicalSystem musicalSystemWithName:[attributeDict valueForKey:@"name"]];
		self.currentMusicalSystem = system;
		[system release];
		//NSLog(@"system: %@",[attributeDict valueForKey:@"name"]);
    } else if ([elementName isEqualToString:kScaleElementName]) {
		[currentMusicalSystem addScaleWithName:[attributeDict valueForKey:@"name"]];
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



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [parsedMusicalSystems count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	MusicalSystem *system = [parsedMusicalSystems objectAtIndex:section];
	NSArray *scales = system.scales;
	return [scales count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicalScaleCell";
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ScaleCell" owner:self options:nil];
        cell = scaleCell;
        self.scaleCell = nil;
	} 

	
	// Configure the cell...
	
	MusicalSystem *system = [parsedMusicalSystems objectAtIndex:indexPath.section];
	NSArray *scales = system.scales;
	MusicalScale *scale = [scales objectAtIndex:indexPath.row];
	//UILabel *label = (UILabel *)[cell viewWithTag:1];
	cell.textLabel.text =scale.name;
    
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Section title is the region name
	MusicalSystem *system = [parsedMusicalSystems objectAtIndex:section];
	return system.name;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}




@end

