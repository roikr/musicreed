#include "testApp.h"
#include "ofMainExt.h"
#include "ofSoundStream.h"

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	//ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	//ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	//ofBackground(255,0,0);
	//ofSetCircleResolution(9);
	
	int bufferSize = 256;
	
	bool bLoaded = click.load(ofToResourcesPath("click.caf"), bufferSize);
	assert(bLoaded);
	
	
		
	inner.innerRadius = 100;
	inner.outerRadius = 200;
	outer.innerRadius = 200;
	outer.outerRadius = 500;
	
	
	
	
	scale = 0.6;
	
	center = ofPoint(10,ofGetHeight()/2);
	
	ofSoundStreamSetup(2, 0, this, 44100, bufferSize, 2);
	
	resume();
}



void testApp::resume() {
	inner.setup(ofToResourcesPath("inner.pvr"));
	outer.setup(ofToResourcesPath("outer.pvr"));
	background.load(ofToResourcesPath("background.pvr"));
	needle.load(ofToResourcesPath("needle.pvr"));
	
	ofSoundStreamStart();
}

void testApp::suspend() {
	inner.exit();
	outer.exit();
	background.release();
	needle.release();
}

//--------------------------------------------------------------
void testApp::update(){
	inner.update();
	outer.update();
	
	if (inner.getIsNewSect()) {
		click.play();
		inner.resetNewSectFlag();
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofBackground(100,100,100);
	ofTranslate(center.x,center.y);
	ofScale(scale, scale, 1);
	ofTranslate(-(int)background._width/2, -(int)background._height/2);
	background.draw();
	
	
	outer.draw();
	inner.draw();
	
	needle.draw();

	
}

//--------------------------------------------------------------
void testApp::exit(){
	suspend();
	ofSoundStreamClose();
}

void testApp::audioRequested( float * output, int bufferSize, int nChannels ) {
	
	click.audioRequested(output, 0, bufferSize, nChannels);	
	click.audioRequested(output, 1, bufferSize, nChannels);	
	click.postProcess();
	
	
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scale,180*atan2(pnt.y, pnt.x)/M_PI);
	
//	printf("(%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
	
	inner.touchDown(pos);
	outer.touchDown(pos);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scale,180*atan2(pnt.y, pnt.x)/M_PI);
	
//	printf("(%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,tempPos.x,tempPos.y);
	
	inner.touchMoved(pos);
	outer.touchMoved(pos);
		

	
	if (inner.getIsNewSect()) {
		click.play();
		inner.resetNewSectFlag();
	}
		//printf("%.3f\n",degree);
	
	
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scale,180*atan2(pnt.y, pnt.x)/M_PI);
	
	inner.touchUp(pos);
	outer.touchUp(pos);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

