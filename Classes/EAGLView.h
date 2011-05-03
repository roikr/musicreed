//
//  EAGLView.h
//  Milgrom
//
//  Created by Roee Kremer on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>




// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
class testApp;

@interface EAGLView : UIView
{
@private
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
    GLuint defaultFramebuffer, colorRenderbuffer;
	
	//float eyeX;
	//float eyeY;
	//float dist;
	
	BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    /*
	 Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	 CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	 The NSTimer object is used only as fallback when running on a pre-3.1 device where CADisplayLink isn't available.
	 */
    id displayLink;
    NSTimer *animationTimer;
	//CFTimeInterval startTime;
	
	EAGLContext *secondaryContext;
	testApp* OFSAptr;
}

@property (nonatomic, retain) EAGLContext *context;
@property  GLint framebufferHeight;

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

@property (nonatomic, retain) EAGLContext *secondaryContext;
@property testApp *OFSAptr;

- (void)setOFSAptr:(testApp*)theOFSAptr;
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

- (void)setSecondaryContextCurrent;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawFrame;
- (void)setInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
