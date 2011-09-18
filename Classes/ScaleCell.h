//
//  ScaleCell.h
//  Musicreed
//
//  Created by Roee Kremer on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scale;

@interface ScaleCell : UITableViewCell {
	IBOutlet UIImageView *scaleDirection; 
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *infoButton;
	
	Scale *scale;
	
}

@property (nonatomic,retain) Scale *scale;

-(void) configureCellWithScale:(Scale *)theScale;

@end
