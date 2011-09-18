//
//  SubsystemTableViewController.m
//  ScaleSelection
//
//  Created by Roee Kremer on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubsystemTableViewController.h"
#import "Scale.h"
#import "MusicreedAppDelegate.h"
#import "ScaleCell.h"


@implementation SubsystemTableViewController

@synthesize scales;
@synthesize currentScale;
@synthesize backgroundView;
@synthesize searchBackgroundView;
@synthesize searchScales;
@synthesize cancelButtonItem;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	((UITableView *)self.view).backgroundView = self.backgroundView;
	
	Scale *scale = [scales objectAtIndex:0];
	self.title = NSLocalizedString(scale.subsystem, @"Tertiary view navigation title");
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
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
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSArray *)scalesByView:(UITableView *)tableView {
	
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return self.searchScales;
    }
	else
	{
        return self.scales;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;
   
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    	
    return [[self scalesByView:tableView] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ScaleCell";
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] getScaleCell];
		
	} 
	
	
	// Configure the cell...
	
	Scale *scale = [[self scalesByView:tableView] objectAtIndex:indexPath.row];
	//UILabel *label = (UILabel *)[cell viewWithTag:1];
	[(ScaleCell *)cell configureCellWithScale:scale];
	cell.textLabel.text =scale.name;
		
    return cell;
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
    
	
	[[[UIApplication sharedApplication] delegate] performSelector:@selector(setScale:)  withObject:[[self scalesByView:tableView] objectAtIndex:indexPath.row]];
	 												  
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
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
	self.searchScales = nil;
	self.searchScales = [NSMutableArray array];
		
	for (Scale *scale in scales)
	{
		NSComparisonResult result = [scale.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			//[self.filteredListContent addObject:product];
			[searchScales addObject:scale];
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
