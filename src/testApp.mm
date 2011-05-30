#include "testApp.h"
#include "ofMainExt.h"
#include "ofSoundStream.h"
#include "ofxXmlSettings.h"



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
	
	ofxXmlSettings xml;
	ofDisableDataPath();
	assert(xml.loadFile(ofToResourcesPath("creed.xml")));
	ofEnableDataPath();
	xml.pushTag("creed");
	xml.pushTag("scales");
	for (int i=0; i<xml.getNumTags("scale"); i++) {
		scale s;
		s.firstNote = xml.getAttribute("scale", "first", 0.0f, i);
		xml.pushTag("scale", i);
		float note = 0;
		s.notes.push_back(note);
		for (int j=0; j<xml.getNumTags("note")-1; j++) {
			note+=xml.getAttribute("note", "interval", 0.0f, j);
			s.notes.push_back(note);
		}
		xml.popTag();
		printf("scale: %i, first:%.2f, notes: %i, last: %.2f\n",i,s.firstNote,(int)s.notes.size(),note);
		scales.push_back(s);
		
	}
	
	xml.popTag();
	
	xml.pushTag("leaves");
	
	float note = 0;
	leaves.push_back(note);
	for (int j=0; j<xml.getNumTags("leaf")-1; j++) {
		note+=xml.getAttribute("leaf", "interval", 0.0f, j);
		leaves.push_back(note);
	}
	xml.popTag();
	printf("leafs: %i, last: %.2f\n",(int)leaves.size(),note);
	xml.popTag();
	
	
	
	bufferSize = 256;
	
	
	instrument.setup(256,2);
	
	for (int i=48; i<=72; i++) {
		string filename = ofToResourcesPath("samples/Littlevoice_"+ofToString(i)+".caf");
		instrument.loadSample(filename,i);
	}
	
	
	inner.innerRadius = 100;
	inner.outerRadius = 200;
	outer.innerRadius = 200;
	outer.outerRadius = 500;
	
	for (vector<float>::iterator iter = leaves.begin(); iter!=leaves.end(); iter++) {
		outer.stops.push_back(2.0f*M_PI-(*iter)*M_PI/3.0f);
	}
	
	for (int i=0; i<=12; i++) {
		inner.stops.push_back(i*M_PI/6);
	}
	
	
	scaleFactor = 0.55;
	bKeyDown = false;
	
	
	center = ofPoint(-30,ofGetHeight()/2);
	
	ofSoundStreamSetup(2, 0, this, 44100, bufferSize, 2);
	
	resume();
}



void testApp::resume() {
	inner.setup(ofToResourcesPath("inner.pvr"),ofToResourcesPath("click.caf"), bufferSize);
	outer.setup(ofToResourcesPath("outer.pvr"),ofToResourcesPath("click.caf"), bufferSize);
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
}

//--------------------------------------------------------------
void testApp::draw(){
	ofBackground(100,100,100);
	ofTranslate(center.x,center.y);
	ofScale(scaleFactor, scaleFactor, 1);
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
	instrument.exit();
}

void testApp::audioRequested( float * output, int bufferSize, int nChannels ) {
	
	memset(output, 0, bufferSize*sizeof(float)*nChannels);
	
	
	inner.click.audioRequested(output, 0, bufferSize, nChannels);	
	inner.click.audioRequested(output, 1, bufferSize, nChannels);	
	inner.click.postProcess();
	
	outer.click.audioRequested(output, 0, bufferSize, nChannels);	
	outer.click.audioRequested(output, 1, bufferSize, nChannels);	
	outer.click.postProcess();
	
	instrument.preProcess();
	instrument.mixChannel(output,0,2);
	instrument.mixChannel(output,1,2);
	instrument.postProcess();
	
	
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	
	//printf("touchDown\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
	printf("touchDown (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
//	printf("touchDown (%.2f,%.2f)\n",pos.x,pos.y);
	
	
	inner.touchDown(pos);
	outer.touchDown(pos);
	
	if (!inner.bDown && !outer.bDown) {
		bKeyDown = true;
		lastKey = 48+(int)(touch.y/20) ;
		lastArp = (int)((ofGetWidth()-touch.x)/80) ;
		
		
		instrument.noteOn(lastKey+lastArp*4, 127);
		//instrument.noteOff(iter->note);
	}
	
	
	
	
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
	//printf("touchMoved\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
	printf("touchMoved (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
//	printf("touchMoved (%.2f,%.2f)\n",pos.x,pos.y);
	
	inner.touchMoved(pos);
	outer.touchMoved(pos);
		

	
	
//	printf("%.3f\n",outer.phi);
	
	if (bKeyDown) {
		int key = 48+(int)(touch.y/20) ;
		int arp = (int)((ofGetWidth()-touch.x)/80) ;
		if (key!=lastKey || arp!=lastArp) {
			lastKey = key;
			lastArp = arp;
			instrument.noteOn(lastKey+lastArp*4, 127);
			
		}
	}
	
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	
	//printf("touchUp\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
	printf("touchUp (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);	
	inner.touchUp(pos);
	outer.touchUp(pos);
	bKeyDown = false;
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

