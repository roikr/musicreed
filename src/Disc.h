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

class Disc {
	
public:
	Disc():alpha(0),omega(0),daccel(0),bNewSect(false),bDown(false) {};
	
	void setup(string filename);
	void update();
	void draw();
	void exit();
	
	void touchDown(ofPoint &pos);
	void touchMoved(ofPoint &pos);
	void touchUp(ofPoint &pos);
	
	bool getIsNewSect();
	void resetNewSectFlag();
	
	float alpha;
	float omega;
	float daccel;
	float innerRadius;
	float outerRadius;
	ofxiTexture texture;
	
	ofPoint pos;
	bool bNewSect;
	
	bool bDown;
	int lastTime;
	
	
};