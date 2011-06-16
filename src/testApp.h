#pragma once

#include "ofMain.h"
//#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxAudioFile.h"
#include "ofxAudioInstrument.h"
#include "ofxiTexture.h"
#include "Disc.h"
#include "ofTrueTypeFont.h"

struct scale {
	vector<int> leaves;
	vector<float> notes;
};


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

	void setScale(int scale,int mode,float note,int numDivisions,bool bAnimate);
	
	void setKeys();
	
	Disc inner;
	Disc outer;
	
	ofxiTexture background;
	ofxiTexture needle;
		
	
	ofPoint center;
	float scaleFactor;

	ofxAudioInstrument instrument;
	int bufferSize;
	
	bool bKeyDown;
	int lastKey;
	int lastArp;
	
	vector <scale> scales;
	vector <scale>::iterator  currentScale;
	vector <float> leaves;
	
		
	
	ofTrueTypeFont ttf;
	int mode;
	float firstNote;
	int numDivisions;
	
	vector<string> keys;
	
};


