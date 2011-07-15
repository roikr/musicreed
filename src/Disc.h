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
	Disc():phi(0),omega(0),alpha(0),bDown(false),bRotate(false),bSnap(false),bNewStop(false) {};
	
	void setup(/*string textureFilename,string backgroundFilename,*/string clickFilename,int bufferSize,int innerRadius,int outerRadius);
	void update();
//	void draw();
	void exit();
	
	void touchDown(ofPoint &pos);
	void touchMoved(ofPoint &pos);
	void touchUp(ofPoint &pos);
	
//	void loadTextures();
//	void unloadTextures();

	bool getIsDown();
	
	void updateStops(vector <float> stops);
	void setStop(int stop);
	int	 getStop();
	bool getIsNewStop();
	void resetIsNewStop();
	
	float getPhi();
		
	ofxAudioFile click;
		
	
private:
	float phi;

	void updatePhi(float phi,bool bStop);
		
//	string textureFilename;
//	string backgroundFilename;
	
	float innerRadius;
	float outerRadius;
	
	
	
	float omega;
	float alpha;
	
//	ofxiTexture texture;
//	ofxiTexture background;
	
	ofPoint pos;
	int lastTime;
	
	bool bDown;
	
	int startAnim;
	float startPhi;
	float endPhi;
	bool bRotate;
	bool bSnap;
	
	vector <float> stops;
	vector <float>::iterator currentStop;
	bool bNewStop;
	bool bPlaying;
	
	
	
};