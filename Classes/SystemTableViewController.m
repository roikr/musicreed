//
//  SystemTableViewController.m
//  ScaleSelection
//
//  Created by Roee Kremer on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SystemTableViewController.h"
#import "Scale.h"
#import "SubsystemTableViewController.h"

@implementation SystemTableViewController

@synthesize scales;
@synthesize scaleCell;
@synthesize currentScale;
@synthesize backgroundView;
@synthesize searchBackgroundView;
@synthesize sections;
@synthesize searchSections;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	((UITableView *)self.view).backgroundView = self.backgroundView;
	
	Scale *scale = [scales objectAtIndex:0];
	self.title = NSLocalizedString(scale.system, @"Secondary view navigation title");
	
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





- (void)arrangeScales {
	
	
	self.sections = [NSMutableArray array];
	NSMutableArray *currentSection;
	NSString *currentSystem = nil;
	
	NSMutableArray *firstSection = [NSMutableArray array];
	[sections addObject:firstSection];
	
	for (Scale *scale in scales)
	{
		if (![scale.subsystem isEqualToString:currentSystem]) {
			currentSystem = scale.subsystem;
			currentSection = [NSMutableArray array];
		}
		
		
		[currentSection addObject:scale];
		if ([currentSection count] == 1) {
			[firstSection addObject:currentSystem];
//			if (![sections count]) {
//				[sections addObject:firstSection];
//			}
			[sections addObject:currentSection];
			
		}
	}
	
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
		
		if (!indexPath.section ) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
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
	
	if (indexPath.section ) {
		Scale *scale = [currentSection objectAtIndex:indexPath.row];
		//UILabel *label = (UILabel *)[cell viewWithTag:1];
		cell.textLabel.text =scale.name;
	} else {
		cell.textLabel.text =[currentSection objectAtIndex:indexPath.row];
	}
	
	
	
    
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Section title is the region name
	NSArray *currentSection = [sections objectAtIndex:section];
	NSString *title;
	if (section) {
		Scale *scale = [currentSection objectAtIndex:0];
		title = scale.subsystem;
	} else {
		title = @"Subsystems";
	}
	
	
	return title ;
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
	/*
     When a row is selected, create the detail view controller and set its detail item to the item associated with the selected row.
     */
	
	if (!indexPath.section) {
		SubsystemTableViewController *subsystemTableViewController = [[SubsystemTableViewController alloc] initWithNibName:@"SubsystemTableViewController" bundle:nil];
		
		subsystemTableViewController.scales = [sections objectAtIndex:indexPath.row+1];
		[subsystemTableViewController arrangeScales];
		
		// Push the detail view controller.
		[[self navigationController] pushViewController:subsystemTableViewController animated:YES];
		[subsystemTableViewController release];
	}
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
	
	NSMutableArray *firstSection = [NSMutableArray array];
	[searchSections addObject:firstSection];
	
	for (Scale *scale in scales)
	{
		if (![scale.subsystem isEqualToString:currentSystem]) {
			currentSystem = scale.subsystem;
			currentSection = [NSMutableArray array];
			
			NSComparisonResult result = [currentSystem compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			if (result == NSOrderedSame)
			{
				[firstSection addObject:currentSystem];
				
//				if ([firstSection count] == 1) {
//					[searchSections insertObject:firstSection atIndex:0];
//				}
			}
		}
		
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

