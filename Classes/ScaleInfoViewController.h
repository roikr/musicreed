//
//  ScaleInfoViewController.h
//  Musicreed
//
//  Created by Roee Kremer on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scale;

@interface ScaleInfoViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	NSURL *url;
}

@property (nonatomic,retain) NSURL *url;

-(void)loadScale:(Scale*)scale;
@end
