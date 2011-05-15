#pragma once

#include "ofMain.h"
//#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxAudioFile.h"
#include "ofxiTexture.h"
#include "Disc.h"


class testApp : public ofSimpleApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void suspend();
	void resume();
	
	void audioRequested( float * output, int bufferSize, int nChannels );
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);

	ofxAudioFile click;
	
	Disc inner;
	Disc outer;
	
	ofxiTexture background;
	ofxiTexture needle;
		
	
	ofPoint center;
	float scale;

	
};


