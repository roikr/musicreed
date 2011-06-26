#pragma once

#include "ofMain.h"
//#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxAudioFile.h"
#include "ofxAudioInstrument.h"
#include "ofxiTexture.h"
#include "Disc.h"
#include "ofTrueTypeFont.h"

enum {
	MUSICREED_STATE_SCALES,
	MUSICREED_STATE_CHORDS
};
	

struct scale {
	vector<int> leaves;
	vector<float> notes;
};

struct chord {
	vector<float> intervals;
	string name;
};


class testApp : public ofSimpleApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void suspend();
	void resume();
	
	void soundStreamStart();
	void soundStreamStop();
	
	void audioRequested( float * output, int bufferSize, int nChannels );
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);

	void setState(int state);
	int getState();
	void setScale(int scale,int mode,float note,int numDivisions,bool bAnimate);
	
	void setKeys();
	void setAltChords();
	
	
	Disc inner;
	Disc outer;
	
	ofxiTexture background;
	ofxiTexture needle;
		
	ofPoint center;
	float scaleFactor;

	ofxAudioInstrument instrument;
	int bufferSize;
	
	int lastKey;
	bool bKeyDown;
	int lastAltKey;
	bool bAltKeyDown;
	string chordNoteName;
	int lastArp;
	
	vector <scale> scales;
	vector <scale>::iterator  currentScale;
	vector <float> leaves;
	
	ofTrueTypeFont ttf;
	int mode;
	float firstNote;
	int numDivisions;
	
	bool bRefreshDisplay;
	
	int state;
	
	vector<chord> chords;
	
	vector<int> chordsKeys;
	vector<int> altChords;
	vector<string> keysNames;
	
};


