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

void Disc::setup(string textureFilename,string clickFilename,int bufferSize) {
	texture.load(textureFilename);
	int bLoaded = click.load(clickFilename, bufferSize);
	assert(bLoaded);

}

void Disc::updatePhi(float phi) {
	
	for (vector<float>::iterator iter = stops.begin(); iter!=stops.end(); iter++) {
		float mult = floor(min(this->phi,phi)/(2.0f*M_PI));
		float stop = *iter+2.0*mult*M_PI;
		if (min(phi,this->phi) < stop &&  max(phi,this->phi)>stop) {
			click.play();
			break;
		}
	}
		
	this->phi = phi;
	
	//printf("degree: %.2f\n",phi);
}

void Disc::update() {
	
	
	
	if (bRotate) {
		if (fabs(endPhi-phi) > M_PI/360.0f) {
			float t = (ofGetElapsedTimeMillis() - startAnim)/1000.0f;
			updatePhi(startPhi+omega*t+alpha*t*t/2.0f);
		} else {
			updatePhi(endPhi);
			bRotate = false;
		}		
	}
	
}

void Disc::draw() {
	ofPushMatrix();
	ofTranslate((int)texture._width/2, (int)texture._height/2);
	ofRotate(180*phi/M_PI+105);
	ofTranslate(-(int)texture._width/2, -(int)texture._height/2);
	texture.draw();
	ofPopMatrix();
	
}


void Disc::exit() {
	texture.release();
}

void Disc::touchDown(ofPoint &pos) {
	
	if (pos.x >innerRadius && pos.x<outerRadius) {
		bRotate = false;
		omega = 0;
		bDown = true;
		lastTime = ofGetElapsedTimeMillis();
		this->pos = pos;
	}
	
}

void Disc::touchMoved(ofPoint &pos) {
	if (bDown) {
		if (pos.x >innerRadius && pos.x<outerRadius) {
			float diff = pos.y-this->pos.y;
			updatePhi(phi+diff);
			omega = diff * 1000.0f / (ofGetElapsedTimeMillis()-lastTime) ;
			lastTime = ofGetElapsedTimeMillis();
			this->pos = pos;
			
		} else {
			touchUp(pos);
		}

	}
}


void Disc::touchUp(ofPoint &pos) {
	if (bDown) {
		bDown = false;
		updatePhi(phi+pos.y-this->pos.y);
		if (ofGetElapsedTimeMillis()-lastTime>50) {
			omega = 0;
			// lastPhi = phi;
		}
		
		if (omega!=0) {
			
			bRotate = true;
			startPhi = phi;
			alpha =-omega/2;
			endPhi = startPhi - omega*omega/2/alpha;
			startAnim = ofGetElapsedTimeMillis();
			//printf("diff: %.2f\n",diff);
			printf("omega: %.2f, alpha: %.2f, start: %.2f, end: %.2f\n",omega,alpha,startPhi,endPhi);
			
			
		}
		
			
		
	}
	
}


