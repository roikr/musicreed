//
//  MainViewController.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController {
	UILabel *label;
}

@property (nonatomic,retain) IBOutlet UILabel *label;

- (void)chooseScale:(id)sender;

@end
