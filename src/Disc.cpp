/*
 *  Disc.cpp
 *  Musicreed
 *
 *  Created by Roee Kremer on 5/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#define MIN_DIST_TO_CLICK M_PI/360.0f
#define SNAP_ANIMATION_TIME 500.0f
#define MIN_ANGULAR_VELOCITY_TO_SNAP M_PI

#include "Disc.h"
#include "easing.h"
#include <cmath>

void Disc::setup(/*string textureFilename,string backgroundFilename,*/string clickFilename,int bufferSize,int innerRadius,int outerRadius) {
	
	int bLoaded = click.load(clickFilename, bufferSize);
	this->innerRadius = innerRadius;
	this->outerRadius = outerRadius;
//	this->textureFilename = textureFilename;
//	this->backgroundFilename = backgroundFilename;
	assert(bLoaded);

}

/*
void Disc::loadTextures() {
//	texture.load(textureFilename);
//	background.load(backgroundFilename);
}

void Disc::unloadTextures() {
//	texture.release();
//	background.release();
}
*/

void Disc::updatePhi(float phi,bool bStop) {
	
	
	float sum = floor(min(phi,this->phi)/2.0f/M_PI)*2.0f*M_PI;
	
	
	for (vector<float>::iterator iter = stops.begin(); iter!=stops.end(); iter++) {
		
		/*
		if (bSnap || bRotate ) {
			if (fabs(this->phi-stop) > MIN_DIST_TO_CLICK && fabs(phi-stop) < MIN_DIST_TO_CLICK ) {
				click.play();
				break;
			}
		} else {
			if ((fabs(this->phi-stop) > MIN_DIST_TO_CLICK && fabs(phi-stop) < MIN_DIST_TO_CLICK) || (fabs(this->phi-stop) < MIN_DIST_TO_CLICK && fabs(phi-stop) > MIN_DIST_TO_CLICK) ) {
				if (!click.getIsPlaying()) {
					click.play();
				}
				
				break;
			}
		}
		*/
		
		if ((*iter+sum-this->phi) * (*iter+sum-phi)<=0 ) {
			click.play();
			
			if (bStop) {
				currentStop = iter;
				bNewStop = true;
			}
			
			break;
		}
		
		
		
	}
	//printf("%.3f %.3f\n",this->phi,sum);
	
	
	
	this->phi = phi;
	
	//printf("degree: %.2f\n",phi);
}

void Disc::update() {
	
	if (bRotate || bSnap) {
		if (fabs(endPhi-phi) < MIN_DIST_TO_CLICK) {
			updatePhi(endPhi,true);
			bRotate = false;
			bSnap = false;
			
			
		} else {
			if (bRotate) {
				float t = (ofGetElapsedTimeMillis() - startAnim)/1000.0f; // time [second]
				updatePhi(startPhi+omega*t+alpha*t*t/2.0f,false);
			}
			if (bSnap) {
				float t = (float)(ofGetElapsedTimeMillis() - startAnim)/SNAP_ANIMATION_TIME; // time to finish the animation
				updatePhi(easeInOutQuad(t,phi,endPhi),false);
				//updatePhi(easeOutBounce(t,phi,endPhi));
			}
		}

			
		
	}
	
}

/*
void Disc::draw() {
	ofPushMatrix();
	ofTranslate(-(int)background._width/2, -(int)background._height/2);
	background.draw();
	ofPopMatrix();
//	ofPushMatrix();
//	ofTranslate((int)texture._width/2, (int)texture._height/2);
//	ofRotate(180*phi/M_PI+105);
//	ofTranslate(-(int)texture._width/2, -(int)texture._height/2);
//	texture.draw();
//	ofPopMatrix();
	
}
*/

void Disc::exit() {
	
	click.exit();
}

void Disc::touchDown(ofPoint &pos) {
	
	if (pos.x >innerRadius && pos.x<outerRadius) {
		bRotate = false;
		bSnap = false;
		omega = 0;
		bDown = true;
		lastTime = ofGetElapsedTimeMillis();
		this->pos = pos;
	}
	
}

void Disc::touchMoved(ofPoint &pos) {
	if (bDown) {
		if (pos.x >innerRadius && pos.x<outerRadius) {
			updatePhi(phi+pos.y-this->pos.y,false);
			
			/*
			if (ofGetElapsedTimeMillis()-lastTime>50 ) {
				omega = 0;
				// lastPhi = phi;
			} else {
				omega = diff * 1000.0f / (ofGetElapsedTimeMillis()-lastTime) ;
			}
			 */
			omega = (pos.y-this->pos.y) * 1000.0f / (ofGetElapsedTimeMillis()-lastTime) ;
			
			if (fabs(omega)<MIN_ANGULAR_VELOCITY_TO_SNAP) { 
				omega = 0;
			}
			
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
		
		updatePhi(phi+pos.y-this->pos.y,false);
		
		
		if (omega==0) {
			bSnap = true;
			float sum = floor(phi/2.0f/M_PI)*2.0f*M_PI;
			startPhi = phi;
						
			vector<float>::iterator iter = stops.begin();
			endPhi = *iter+sum;
			iter++;
			
			for (; iter!=stops.end(); iter++) {
				if (fabs(*iter+sum-startPhi) < fabs(endPhi-startPhi)) {
					endPhi = *iter+sum;
				}
			}
			startAnim = ofGetElapsedTimeMillis();
		}
		
		else {
			
			bRotate = true;
			startPhi = phi;
			alpha =-omega/2;
			endPhi = startPhi - omega*omega/2/alpha;
			float sum = floor(endPhi/(2.0f*M_PI)) * 2.0*M_PI;
			float nearest = omega>0 ? endPhi + M_PI/3 : endPhi - M_PI/3;
			
			for (vector<float>::iterator iter = stops.begin(); iter!=stops.end(); iter++) {
				if (fabs(*iter+sum-endPhi) < fabs(nearest-endPhi)) {
					nearest = *iter+sum;
				}
			}				
			
			endPhi = nearest;
			alpha = - omega*omega/2/(endPhi-startPhi);
			
			startAnim = ofGetElapsedTimeMillis();
			//printf("diff: %.2f\n",diff);
			printf("omega: %.2f, alpha: %.2f, start: %.2f, end: %.2f\n",omega,alpha,startPhi,endPhi);
			
			
		} 
		
			
		
	}
	
}


bool Disc::getIsDown() {
	return bDown;
}

void Disc::updateStops(vector <float> stops) {
	this->stops = stops;
	
//	bSnap = true;
//	float sum = floor(phi/2.0f/M_PI)*2.0f*M_PI;
//	endPhi = this->stops.front()+sum;
//	startAnim = ofGetElapsedTimeMillis();
}

void Disc::setStop(int stop) {
	phi = stops[stop];
	currentStop = stops.begin()+stop;
}

int Disc::getStop() {
	return distance(stops.begin(), currentStop);
	
}

bool Disc::getIsNewStop() {
	return bNewStop;
}

void Disc::resetIsNewStop() {
	bNewStop = false;
}

float Disc::getPhi() {
	return phi;
}

