//
//  ScaleCell.m
//  Musicreed
//
//  Created by Roee Kremer on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScaleCell.h"
#import "Scale.h"

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
	scaleDirection.hidden = !scale.bAscending && !scale.bDescending;
	infoButton.hidden = NO;
	playButton.hidden = NO;
}


- (void)dealloc {
    [super dealloc];
}


@end
