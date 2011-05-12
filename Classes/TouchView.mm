//
//  TouchView.m
//  Musicreed
//
//  Created by Roee Kremer on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchView.h"
#import "testApp.h"



@implementation TouchView

@synthesize OFSAptr;

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder])
    {
        bzero(activeTouches, sizeof(activeTouches));

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/******************* TOUCH EVENTS ********************/
//------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	//	NSLog(@"touchesBegan: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	
	
	for(UITouch *touch in touches) {
		int touchIndex = 0;
		while(touchIndex < OF_MAX_TOUCHES && activeTouches[touchIndex] != 0) touchIndex++;
		if(touchIndex==OF_MAX_TOUCHES) {
			NSLog(@"touchesBegan - weird!");
			touchIndex=0;	
		}
		
		activeTouches[touchIndex] = touch;
		
		CGPoint touchPoint = [touch locationInView:self];
		ofTouchEventArgs args;
		args.x = touchPoint.x;
		args.y = touchPoint.y;
		args.id = touchIndex;
		
		if([touch tapCount] == 2) {
			OFSAptr->touchDoubleTap(args);// send doubletap
		}
		
		
		OFSAptr->touchDown(args);
	}
}

//------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//	NSLog(@"touchesMoved: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);

	for(UITouch *touch in touches) {
		int touchIndex = 0;
		while(touchIndex < OF_MAX_TOUCHES && (activeTouches[touchIndex] != touch)) touchIndex++;
		if(touchIndex==OF_MAX_TOUCHES) {
			NSLog(@"touchesMoved - weird!");
			continue;	
		}
		
		CGPoint touchPoint = [touch locationInView:self];
		ofTouchEventArgs args;
		args.x = touchPoint.x;
		args.y = touchPoint.y;
		args.id = touchIndex;
		
		OFSAptr->touchMoved(args);
	}
}

//------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//	NSLog(@"touchesEnded: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	
		
	for(UITouch *touch in touches) {
		int touchIndex = 0;
		while(touchIndex < OF_MAX_TOUCHES && (activeTouches[touchIndex] != touch)) touchIndex++;
		if(touchIndex==OF_MAX_TOUCHES) {
			NSLog(@"touchesEnded - weird!");
			continue;	
		}
		
		activeTouches[touchIndex] = 0;
		
		CGPoint touchPoint = [touch locationInView:self];
		ofTouchEventArgs args;
		args.x = touchPoint.x;
		args.y = touchPoint.y;
		args.id = touchIndex;
		
		OFSAptr->touchUp(args);

	}
}

//------------------------------------------------------
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	for(int i=0; i<OF_MAX_TOUCHES; i++){
		if(activeTouches[i]){
			
			CGPoint touchPoint = [activeTouches[i] locationInView:self];
			activeTouches[i] = 0;
			ofTouchEventArgs args;
			args.x = touchPoint.x;
			args.y = touchPoint.y;
			args.id = i;
			
			OFSAptr->touchUp(args);
		}
	}
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	NSLog(@"shake began");
	shakeStartTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	NSTimeInterval diff = [NSDate timeIntervalSinceReferenceDate]-shakeStartTime;
	NSLog(@"shake ended: %2.2f",diff);
	
	
}



- (void)dealloc {
    [super dealloc];
}


@end
