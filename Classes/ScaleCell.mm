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
	playButton.hidden = NO;
	infoButton.hidden = NO;
	scaleDirection.hidden = !scale.bAscending && !scale.bDescending;
	if (scale.bAscending) {
		[scaleDirection setImage:[UIImage imageNamed:@"SCALE_UP.png"]];
	}
	if (scale.bDescending) {
		[scaleDirection setImage:[UIImage imageNamed:@"SCALE_DOWN.png"]];
	}
	
}

-(void) play:(id)sender {
	NSLog(@"play: %@",scale.filename);
	((MusicreedAppDelegate *)[[UIApplication sharedApplication] delegate]).OFSAptr->playTaqsim([scale.filename UTF8String]);
}

-(void) info:(id)sender {
	NSLog(@"info: %@",scale.name);

}




- (void)dealloc {
    [super dealloc];
}


@end
