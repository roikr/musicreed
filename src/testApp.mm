#include "testApp.h"
#include "ofMainExt.h"
#include "ofSoundStream.h"
#include "ofxXmlSettings.h"
#include "notationUtils.h"

#define VERTICAL_KEYS_NUMBER 16

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
	
	ofBackground(255,255,255);
	
	
	
	ofxXmlSettings xml;
	ofDisableDataPath();
	assert(xml.loadFile(ofToResourcesPath("creed.xml")));
	 ttf.loadFont(ofToResourcesPath("MAIAN.TTF"),12); 
	ofEnableDataPath();
	xml.pushTag("creed");
	
	xml.pushTag("leaves");
	
	float note = 0;
	leaves.push_back(note);
	for (int j=0; j<xml.getNumTags("leaf")-1; j++) {
		note+=xml.getAttribute("leaf", "interval", 0.0f, j);
		leaves.push_back(note);
	}
	xml.popTag();
	
	//printf("leafs: %i, last: %.2f\n",(int)leaves.size(),note);
	
	xml.pushTag("scales");
	for (int i=0; i<xml.getNumTags("scale"); i++) {
		
		xml.pushTag("scale", i);
		scale s;
		
		for (int j=0; j<xml.getNumTags("note"); j++) {
			s.leaves.push_back(xml.getAttribute("note", "leaf", 0, j));
		}
		
		printf("scale %i\t - ",i);
		int octave = 0;
		float first = leaves[s.leaves.front()];
		for (vector<int>::iterator iter=s.leaves.begin(); iter!=s.leaves.end(); iter++) {
			s.notes.push_back(leaves[*iter]+octave*6-first);
			if ((iter+1)!=s.leaves.end() && *iter>*(iter+1)) {
				octave++;
			}
			printf("%i-%2.3f\t\t",*iter,s.notes.back());
		}
		printf("\n");
		
		xml.popTag();
		//printf("scale: %i, leaf: %i, first:%.2f, notes: %i, last: %.2f\n",i,s.leaf,s.firstNote,(int)s.notes.size(),note);
		scales.push_back(s);
		
	}
	
	xml.popTag();
	
	
	xml.popTag();
	
	
	
	bufferSize = 256;
	
	
	instrument.setup(256,2);
	
	for (int i=48; i<=72; i++) {
		string filename = ofToResourcesPath("samples/Littlevoice_"+ofToString(i)+".caf");
		instrument.loadSample(filename,i);
	}
	
	inner.setup(ofToResourcesPath("inner.pvr"),ofToResourcesPath("click.caf"), bufferSize,100,200);
	outer.setup(ofToResourcesPath("outer.pvr"),ofToResourcesPath("click.caf"), bufferSize,200,500);
	
	scaleFactor = 0.55;
	bKeyDown = false;
	
	
	center = ofPoint(-30,ofGetHeight()/2);
	
	ofSoundStreamSetup(2, 0, this, 44100, bufferSize, 2);
	
	resume();
	bRefreshDisplay = false;
	
	
}



void testApp::resume() {
	inner.loadTextures();
	outer.loadTextures();
	background.load(ofToResourcesPath("background.pvr"));
	needle.load(ofToResourcesPath("needle.pvr"));
	
	
	
	ofSoundStreamStart();
}

void testApp::suspend() {
	inner.unloadTextures();
	outer.unloadTextures();
	background.release();
	needle.release();
}

void testApp::soundStreamStart() {
	ofSoundStreamStart();
}

void testApp::soundStreamStop() {
	ofSoundStreamStop();
}

//--------------------------------------------------------------
void testApp::update(){
	ofBackground(20,100,20);
	inner.update();
	
	if (inner.getIsNewStop()) {
		firstNote = (float)inner.getStop()* 6.0f / numDivisions ;
		cout << "stop - first note: " << firstNote << endl;
		setKeys();
		inner.resetIsNewStop();
		// = -note * 2.0f * M_PI / 6.0f;
	}
	
	
	
	outer.update();
	
	if (outer.getIsNewStop()) {
		mode = outer.getStop();
		cout << "stop - mode: " << mode << endl;
		setKeys();
		outer.resetIsNewStop();
		bRefreshDisplay = true;
		// = -note * 2.0f * M_PI / 6.0f;
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofPushMatrix();
	//ofEnableAlphaBlending();
	
	ofTranslate(center.x,center.y);
	ofScale(scaleFactor, scaleFactor, 1);
	ofTranslate(-(int)background._width/2, -(int)background._height/2);
	background.draw();
	
	
	outer.draw();
	inner.draw();
	
	needle.draw();
	//ofDisableAlphaBlending();
	ofPopMatrix();
	
	
	char str[15];
	
	
	int height = ofGetHeight()/VERTICAL_KEYS_NUMBER;
	int width = ofGetWidth()/4;
	
	
	for (int i=0; i<VERTICAL_KEYS_NUMBER; i++) {
		if (bKeyDown && i==lastKey) {
			ofFill();
			ofSetColor(0xA0A0A0);
		} else {
			ofNoFill();
			ofSetColor(0xFFFFFF);
			
		}

		ofRect(ofGetWidth()-width, ofGetHeight()-(i+1)* height,width, height);
		
		ofNoFill();
		ofSetColor(0xFFFFFF);
		
		int octave = floor((i+mode) / currentScale->notes.size());
		//float note = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
		
		//sprintf(str, "%s(%2.3f)",keys[i % keys.size()].c_str(),note);
		ttf.drawString(keys[i % keys.size()], ofGetWidth()-width, ofGetHeight()-(i*height+ttf.getLineHeight()));
	
		
	}
	
}

//--------------------------------------------------------------
void testApp::exit(){
	suspend();
	ofSoundStreamClose();
	instrument.exit();
}

void testApp::audioRequested( float * output, int bufferSize, int nChannels ) {
	
	memset(output, 0, bufferSize*sizeof(float)*nChannels);
	
	
	inner.click.mixChannel(output, 0, nChannels);
	inner.click.mixChannel(output, 1, nChannels);
	inner.click.postProcess();
	
	outer.click.mixChannel(output, 0, nChannels);	
	outer.click.mixChannel(output, 1, nChannels);	
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
	
//	printf("touchDown (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
//	printf("touchDown (%.2f,%.2f)\n",pos.x,pos.y);
	
	
	inner.touchDown(pos);
	outer.touchDown(pos);
	
	if (!inner.getIsDown() && !outer.getIsDown()) {
		bKeyDown = true;
		int key = (int)((ofGetHeight()-touch.y)/(ofGetHeight()/VERTICAL_KEYS_NUMBER)) ;
		int arp = (int)((ofGetWidth()-touch.x)/(ofGetWidth()/4)) ;
		
		int octave = floor((key+mode) / currentScale->notes.size());
		float note = firstNote+currentScale->notes[(key+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
		int midi = floor(48+2.0f*note);
		float intpart;
		int cents = floor(modf(2.0f*note,&intpart)*100.0f);
		
		printf("note: %s(%2.3f), midi: %i, cents: %i\n",keys[key % keys.size()].c_str(),note,midi,cents);
		
		
		
		instrument.noteOn(midi, 127,cents);
		
		//instrument.noteOn(lastKey+lastArp*4, 127);
		//instrument.noteOff(iter->note);
		
		lastKey = key;
		lastArp = arp;
	}
	
	
	
	
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
	//printf("touchMoved\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
//	printf("touchMoved (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
//	printf("touchMoved (%.2f,%.2f)\n",pos.x,pos.y);
	
	inner.touchMoved(pos);
	outer.touchMoved(pos);
		

	
	
//	printf("%.3f\n",outer.phi);
	
	if (bKeyDown) {
		int key = (int)((ofGetHeight()-touch.y)/(ofGetHeight()/VERTICAL_KEYS_NUMBER)) ;
		int arp = (int)((ofGetWidth()-touch.x)/(ofGetWidth()/4)) ;
		if (key!=lastKey || arp!=lastArp) {
			
			
			int octave = floor((key+mode) / currentScale->notes.size());
			float note = firstNote+currentScale->notes[(key+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
			int midi = floor(48+2.0f*note);
			float intpart;
			int cents = floor(modf(2.0f*note,&intpart)*100.0f);
			
			printf("note: %3.3f, midi: %i, cents: %i\n",note,midi,cents);
			instrument.noteOn(midi, 127,cents);
			
			lastKey = key;
			lastArp = arp;
			
		}
	}
	 
	
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	
	//printf("touchUp\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
//	printf("touchUp (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);	
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

void testApp::setScale(int scale,int mode,float note,int numDivisions,bool bAnimate) {
	this->numDivisions = numDivisions;// = 12;
	
	printf("scale: %u, mode: %u, note: %3.3f, numDivisions: %u\n",scale,mode,note,numDivisions);
	currentScale = scales.begin()+scale;
	
	vector<float> stops;
	int firstLeaf = currentScale->leaves.front();
	cout << "modes: ";
	for (int i=0; i<currentScale->leaves.size(); i++) {
		int cmode = currentScale->leaves[(i+firstLeaf) % currentScale->leaves.size()];
		
		stops.push_back(fmod(2.0f*M_PI-(leaves[cmode])*M_PI/3.0f,2*M_PI));
		cout << cmode << "-" << stops.back() << ", ";
	}
	cout << endl;
	
	outer.updateStops(stops);
	outer.setStop(mode);
	
	stops.clear();
	float div = 2.0f*M_PI/numDivisions;
	
	for (int i=0; i<numDivisions; i++) {
		stops.push_back(2.0f*M_PI-i * div);
	}
	inner.updateStops(stops);
	inner.setStop(note * numDivisions / 6.0f);
	
	this->mode = mode;
	//outer.phi = -*(leaves.begin()+(currentScale->leaf+mode) % (int)leaves.size()) * 2.0f * M_PI / 6.0f;
	
	firstNote = note;
	setKeys();
	

}


void testApp::setKeys() {
	keys.clear();
	
	if (currentScale->notes.size()==7) {
		int firstScale = evalScaleNote(firstNote);
		for (vector<float>::iterator iter=currentScale->notes.begin(); iter!=currentScale->notes.end(); iter++) {
			int i = distance(currentScale->notes.begin(),iter);
			float knote = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]-currentScale->notes[mode];
			keys.push_back(findNote(firstScale+i,knote));
			printf("note: %i, %f, %s\n",firstScale+i,knote,keys.back().c_str());
					 
		}
	} else {
		for (vector<float>::iterator iter=currentScale->notes.begin(); iter!=currentScale->notes.end(); iter++) {
			int i = distance(currentScale->notes.begin(),iter);
			float knote = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]-currentScale->notes[mode];
			
			keys.push_back(findNote(evalScaleNote(knote),knote));
							
		}
	}
	
}




