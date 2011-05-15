/*
 *  Disc.cpp
 *  Musicreed
 *
 *  Created by Roee Kremer on 5/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Disc.h"
#include <cmath>

void Disc::setup(string filename) {
	texture.load(filename);

}


void Disc::update() {
	
	
	
	if (!bDown) {
		
		
		float diff = omega * (ofGetElapsedTimeMillis()-lastTime) / 1000;
		
		if (floor(min(alpha,alpha+diff)/15) < floor( max(alpha,alpha+diff)/15)) {
			bNewSect = true;
		}
		
		alpha+=diff;
		
		if (omega) {
			float dw = (omega/fabs(omega)) *daccel *(ofGetElapsedTimeMillis()-lastTime) / 1000;
			omega = (fabs(dw)>fabs(omega)) ? 0 : omega-dw;
			
			//printf("%.2f, %.2f\n",alpha,omega);
		}
		
		lastTime = ofGetElapsedTimeMillis();
	}
	
	
	
	
}

void Disc::draw() {
	ofPushMatrix();
	ofTranslate((int)texture._width/2, (int)texture._height/2);
	ofRotate(alpha);
	ofTranslate(-(int)texture._width/2, -(int)texture._height/2);
	texture.draw();
	ofPopMatrix();
	
}


void Disc::exit() {
	texture.release();
}

void Disc::touchDown(ofPoint &pos) {
	
	if (pos.x >innerRadius && pos.x<outerRadius) {
		bDown = true;
		lastTime = ofGetElapsedTimeMillis();
		this->pos = pos;
	}
	
}

void Disc::touchMoved(ofPoint &pos) {
	if (bDown) {
		if (pos.x >innerRadius && pos.x<outerRadius) {
			
			float diff = pos.y-this->pos.y;
			
			omega = diff * 1000 / (ofGetElapsedTimeMillis()-lastTime) ;
			
			//printf("angular velocity: %.2f\n",omega);
			lastTime = ofGetElapsedTimeMillis();
			this->pos = pos;
			
			if (floor(min(alpha,alpha+diff)/15) < floor( max(alpha,alpha+diff)/15)) {
				bNewSect = true;
			}
			alpha+= diff;
		}
	}
}

void Disc::touchUp(ofPoint &pos) {
	bDown = false;
	if (ofGetElapsedTimeMillis()-lastTime>50) {
		omega = 0;
	} else {
		daccel = omega*(omega/fabs(omega)) / 0.5;
	}

	
	lastTime = ofGetElapsedTimeMillis();

}

bool Disc::getIsNewSect() {
	return bNewSect;
}

void Disc::resetNewSectFlag() {
	bNewSect = false;
}