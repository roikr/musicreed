//
//  ScaleCell.m
//  Musicreed
//
//  Created by Roee Kremer on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScaleCell.h"
#import "Scale.h"
#import "MusicreedAppDelegate.h"
#import "testApp.h"
#import "ScaleInfoViewController.h"


@implementation ScaleCell

@synthesize scale;

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder])
    {
        [self.textLabel setFont: [UIFont fontWithName: @"Maiandra GD" size: self.textLabel.font.pointSize]];
		[self.textLabel setTextColor:[UIColor whiteColor]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont: [UIFont fontWithName: @"Maiandra GD" size: self.textLabel.font.pointSize]];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void) configureCellWithScale:(Scale *)theScale {
	self.scale = theScale;
	playButton.hidden = !scale.bTaqsim;
	infoButton.hidden = NO;
	scaleDirection.hidden = !scale.bAscending && !scale.bDescending;
	if (scale.bAscending) {
		[scaleDirection setImage:[UIImage imageNamed:@"APP_SCREEN_4_ARROW_UP.png"]];
	}
	if (scale.bDescending) {
		[scaleDirection setImage:[UIImage imageNamed:@"APP_SCREEN_4_ARROW_DOWN.png"]];
	}
	
}

-(void) play:(id)sender {
	NSLog(@"play: %@",scale.url);
	((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr->playTaqsim([scale.url UTF8String]);
}

-(void) info:(id)sender {
	NSLog(@"info: %@",scale.name);
	
	
	ScaleInfoViewController *scaleInfoViewController = [[ScaleInfoViewController alloc] initWithNibName:@"ScaleInfoViewController" bundle:nil];
	[scaleInfoViewController loadScale:scale];
	
	[[(MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate] scalesNavigationController] pushViewController:scaleInfoViewController animated:YES];
	[scaleInfoViewController release];
}




- (void)dealloc {
    [super dealloc];
}


@end
