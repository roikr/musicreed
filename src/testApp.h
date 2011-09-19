#pragma once

#include "ofMain.h"
//#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxAudioFile.h"
#include "ofxAudioInstrument.h"
#include "ofxAudioLimiter.h"
#include "ofxiTexture.h"
#include "Disc.h"
#include "ofTrueTypeFont.h"
#include "ofxButton.h"

enum {
	MUSICREED_STATE_SCALES,
	MUSICREED_STATE_CHORDS
};
	

struct scale {
	vector<int> leaves;
	vector<float> notes;
	string layerName;
	ofxiTexture *texture;
};

struct chord {
	vector<float> intervals;
	string name;
	string layerName;
	ofxiTexture *texture;
};

struct key {
	int x;
	int y;
};


class testApp : public ofSimpleApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void suspend();
	void resume();
	
	void drawKeys();
	
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

	void setState(int state,int rotDuration);
	int getState();
	void setScale(int scale,int mode,float note,int numDivisions,bool bAnimate);
	
	void setKeys();
	void setAltChords();
	
	int getNumKeys();
	int getKeyWidth();
	
	void playChord(int chordIndex,float base);
	void strumChord(int chordIndex,float base);
	
	key pointToKey(ofPoint pos);
	
	void playTaqsim(string filename);
	void stopTaqsim();
	
	
	Disc inner;
	Disc outer;
	
	//ofxiTexture chordTex;
	ofxiTexture scaleNeedle;
	ofxiTexture scaleInnerPattern;
	ofxiTexture scaleOuterPattern;
	
	ofxiTexture scaleBackground;
	ofxiTexture chordBackground;
	ofxiTexture scaleHighlight;
	ofxiTexture chordHighlight;
//	ofxiTexture shadow;
	
	ofxiTexture chordNeedle;
	ofxiTexture chordPattern;
	ofxiTexture chordMask;
	
	ofxiTexture keysTexture;
		
	ofPoint center;
	float scaleFactor;
	
	ofPoint targetCenter;
	float targetScaleFactor;

	ofxAudioInstrument instrument;
	int bufferSize;
	
	
	bool bDown;
	ofPoint downPos;
	ofPoint lastPos;
	key downKey;
	key lastKey;
	
	int lastAltKey;
	bool bAltKeyDown;
	string chordNoteName;
	int lastArp;
	int lastChordIndex;
	
	
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
	
	vector<ofxButton> noteButtons;
	vector<ofxButton> chordButtons;
	
	vector<float>strumNotes;
	int lastStrum;
	
	bool bRot;
	int rotTime;
	int rotDuration;
	
	ofxAudioLimiter limiter;
	ofxAudioFile taqsim;
	string taqsimName;
	bool bPlayTaqsim;
};


