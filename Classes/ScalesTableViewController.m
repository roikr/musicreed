//
//  ScalesTableViewController.m
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScalesTableViewController.h"
#import "Scale.h"


@implementation ScalesTableViewController

@synthesize scaleCell;
@synthesize currentScale;
@synthesize backgroundView;
@synthesize searchBackgroundView;
@synthesize scales;
@synthesize sections;
@synthesize searchSections;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	((UITableView *)self.view).backgroundView = self.backgroundView;
	

	if (!self.scales) {
		ScalesParser *parser = [[[ScalesParser alloc] init] autorelease]; 
		parser.delegate = self;
		[parser parse];
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
#pragma mark ScalesParser

- (void)parserDidEndParsingData:(ScalesParser *)parser {
	self.scales = [NSArray arrayWithArray:parser.parsedScales];
	[self arrangeContent];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchSections count];
    }
	else
	{
        return [self.sections count];
    }
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	
	NSArray *currentSection;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        currentSection = [searchSections objectAtIndex:section];
    }
	else
	{
        currentSection = [sections objectAtIndex:section];
    }
	
	
	
    return [currentSection count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ScaleCell";
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ScaleCell" owner:self options:nil];
        cell = scaleCell;
        self.scaleCell = nil;
	} 
	
	
	// Configure the cell...
	
	NSArray *currentSection;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        currentSection = [searchSections objectAtIndex:indexPath.section];
    }
	else
	{
        currentSection = [sections objectAtIndex:indexPath.section];
    }
	
	
	Scale *scale = [currentSection objectAtIndex:indexPath.row];
	//UILabel *label = (UILabel *)[cell viewWithTag:1];
	cell.textLabel.text =scale.name;
    
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Section title is the region name
	NSArray *currentSection = [sections objectAtIndex:section];
	Scale *scale = [currentSection objectAtIndex:0];
	return scale.system;
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

- (void)arrangeContent {
	self.sections = [NSMutableArray array];
	NSMutableArray *currentSection;
	NSString *currentSystem = nil;
	
	for (Scale *scale in scales)
	{
		if (![scale.system isEqualToString:currentSystem]) {
			currentSystem = scale.system;
			currentSection = [NSMutableArray array];
		}
		
	
		[currentSection addObject:scale];
		if ([currentSection count] == 1) {
			[sections addObject:currentSection];
			
		}
	}
	
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	/*
	 Update the filtered array based on the search text.
	 */
	
	// Return the number of sections.
	self.searchSections = nil;
	self.searchSections = [NSMutableArray array];
	NSMutableArray *currentSection;
	NSString *currentSystem = nil;
	
	for (Scale *scale in scales)
	{
		if (![scale.system isEqualToString:currentSystem]) {
			currentSystem = scale.system;
			currentSection = [NSMutableArray array];
		}
		
		if (searchText) {
			NSComparisonResult result = [scale.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			if (result == NSOrderedSame)
			{
				//[self.filteredListContent addObject:product];
				[currentSection addObject:scale];
				if ([currentSection count] == 1) {
					[searchSections addObject:currentSection];
					
				}
			}
		} 

		
		
		
	}
	
	
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];   // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	tableView.backgroundView = self.searchBackgroundView;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	
}

@end

