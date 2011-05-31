/*
 *  Disc.h
 *  Musicreed
 *
 *  Created by Roee Kremer on 5/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "ofMain.h"
#include "ofxiTexture.h"
#include "ofxAudioFile.h"

class Disc {
	
public:
	Disc():phi(0),omega(0),alpha(0),bDown(false),bRotate(false),bSnap(false) {};
	
	void setup(string filename,string clickFilename,int bufferSize);
	void update();
	void draw();
	void exit();
	
	void touchDown(ofPoint &pos);
	void touchMoved(ofPoint &pos);
	void touchUp(ofPoint &pos);
	
	void updatePhi(float phi);
		
	ofxAudioFile click;
	
	float phi;
	
	float omega;
	float alpha;
	float innerRadius;
	float outerRadius;
	ofxiTexture texture;
	
	ofPoint pos;
	int lastTime;
	
	bool bDown;
	
	int startAnim;
	float startPhi;
	float endPhi;
	bool bRotate;
	bool bSnap;
	
	vector <float> stops;
	bool bPlaying;
	
	
};