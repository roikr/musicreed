#include "testApp.h"
#include "ofMainExt.h"
#include "ofSoundStream.h"
#include "ofxXmlSettings.h"
#include "notationUtils.h"
#include "easing.h"


#define VERTICAL_KEYS_NUMBER 16
#define HORIZONTAL_KEYS_NUMBER 8
#define STRUM_DELAY 50

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
	 
//	ofBackground(255,255,255);
	
	ofxXmlSettings xml;
	bool bLoaded = xml.loadFile("creed.xml");
	assert(bLoaded);
	ttf.loadFont(ofToDataPath("MAIAN.TTF"),12); 
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
		s.layerName = xml.getAttribute("scale", "layer", "", i);
		s.texture = new ofxiTexture();
		//printf("scale: %i, leaf: %i, first:%.2f, notes: %i, last: %.2f\n",i,s.leaf,s.firstNote,(int)s.notes.size(),note);
		scales.push_back(s);
		
	}
	
	xml.popTag();
	
	xml.pushTag("chords");
	for (int i=0;i<xml.getNumTags("chord");i++) {
		chord c;
		c.name = xml.getAttribute("chord", "name", "", i);
		c.layerName = xml.getAttribute("chord", "layer", "", i);
		c.texture = new ofxiTexture();
		xml.pushTag("chord", i);
		for (int j=0;j<xml.getNumTags("interval");j++) {
			c.intervals.push_back(xml.getAttribute("interval", "value", 0.0f, j));
		}
		printf("chord: %i, name: %s, firstInterval: %.2f\n",i,c.name.c_str(),c.intervals.front());
		xml.popTag();
		chords.push_back(c);
	}
	xml.popTag();							  
	
	
	xml.popTag();
	
	
	
	bufferSize = 256;
	
	
	instrument.setup(256,2);
	limiter.setup(10, 500, 44100, 0.3);
	
//	for (int i=48; i<=72; i++) {
//		string filename = ofToDataPath("samples/Littlevoice_"+ofToString(i)+".caf");
//		instrument.loadSample(filename,i);
//	}
	
	for (int i=38; i<=72; i++) {
		string filename = ofToDataPath("oud_"+ofToString(i)+".caf");
		instrument.loadSample(filename,i);
	}
	
	inner.setup(/*ofToDataPath("inner.pvr"),ofToDataPath("innerBg.pvr"),*/ofToDataPath("click.caf"), bufferSize);
	inner.setRadii(100, 200);
	outer.setup(/*ofToDataPath("outer.pvr"),ofToDataPath("outerBg.pvr"),*/ofToDataPath("click.caf"), bufferSize);
	outer.setRadii(200,500);
	
	bDown = false;
	bAltKeyDown = false;
	
	
	
	ofSoundStreamSetup(2, 0, this, 44100, bufferSize, 2);
	
	resume();
	bRefreshDisplay = false;
	
	setState( MUSICREED_STATE_SCALES,0);
	
	int colorsArray[] = {0x111e14,0x26362b,0x0f1f1d,0x030f19,0x253738,0x1e2b2f,0x414740,0x505956,0x7e7b6a};
	vector<ofColor> colors;
	for (int i=0; i< sizeof(colorsArray)/sizeof(int); i++) {
		ofColor color;
		color.r=colorsArray[i]>>16;
		color.g=(colorsArray[i]>>8) & 0xFF;
		color.b=colorsArray[i] & 0xFF;
		color.a=255;
		
		colors.push_back(color);
	}
	
	/*
	ofColor color;
	color.r=150;
	color.g=40;
	color.b=60;
	color.a=255;
	*/
	
	int height = ofGetHeight()/VERTICAL_KEYS_NUMBER;
	int width = ofGetWidth()/4;
	
	
	
	for (int i=0; i<VERTICAL_KEYS_NUMBER; i++) {
		noteButtons.push_back(ofxButton(ofRectangle(0, ofGetHeight()-(i+1)* height,ofGetWidth(), height),colors[i % colors.size()]));
	}
		
	
	height = ofGetWidth()/HORIZONTAL_KEYS_NUMBER;
	width = ofGetHeight()/5;
	
	for (int i=0; i<HORIZONTAL_KEYS_NUMBER; i++) {
		chordButtons.push_back(ofxButton(ofRectangle(0, ofGetWidth()-(i+1)* height,ofGetHeight(), height),colors[i % colors.size()]));
	}
	
	
	bAnim = false;
	bLock = false;
	bPlayTaqsim = false;
}



void testApp::resume() {
//	inner.loadTextures();
//	outer.loadTextures();
	
	keysTexture.load(ofToDataPath("keys_texture.pvr"),OFX_TEXTURE_TYPE_PVR);
	scaleBackground.load(ofToDataPath("scale_background.pvr"),OFX_TEXTURE_TYPE_PVR);
	chordBackground.load(ofToDataPath("chord_background.pvr"),OFX_TEXTURE_TYPE_PVR);
	scaleHighlight.load(ofToDataPath("scale_highlight.pvr"),OFX_TEXTURE_TYPE_PVR);
	chordHighlight.load(ofToDataPath("chord_highlight.pvr"),OFX_TEXTURE_TYPE_PVR);
//	shadow.load(ofToDataPath("shadow.pvr"),OFX_TEXTURE_TYPE_PVR);
	
	scaleNeedle.load(ofToDataPath("scale_needle.pvr"),OFX_TEXTURE_TYPE_PVR);
	scaleInnerPattern.load(ofToDataPath("scale_inner_pattern.pvr"),OFX_TEXTURE_TYPE_PVR);
	scaleOuterPattern.load(ofToDataPath("scale_outer_pattern.pvr"),OFX_TEXTURE_TYPE_PVR);
	
	chordNeedle.load(ofToDataPath("chord_needle.pvr"),OFX_TEXTURE_TYPE_PVR);
	chordPattern.load(ofToDataPath("chord_pattern.pvr"),OFX_TEXTURE_TYPE_PVR);
	chordMask.load(ofToDataPath("chord_mask.pvr"),OFX_TEXTURE_TYPE_PVR);
	
	for(vector <scale>::iterator iter=scales.begin();iter!=scales.end();iter++) {
		iter->texture->load(ofToDataPath(""+iter->layerName+".pvr"),OFX_TEXTURE_TYPE_PVR);
	}
	
	for(vector <chord>::iterator iter=chords.begin();iter!=chords.end();iter++) {
		iter->texture->load(ofToDataPath(""+iter->layerName+".pvr"),OFX_TEXTURE_TYPE_PVR);
	}
	
	ofSoundStreamStart();
}

void testApp::suspend() {
//	inner.unloadTextures();
//	outer.unloadTextures();
	
	keysTexture.release();
	scaleBackground.release();
	chordBackground.release();
	scaleHighlight.release();
	chordHighlight.release();
	
	scaleNeedle.release();
	scaleInnerPattern.release();
	scaleOuterPattern.release();
	chordNeedle.release();
	chordPattern.release();
	chordMask.release();
	
	for(vector <scale>::iterator iter=scales.begin();iter!=scales.end();iter++) {
		iter->texture->release();
	}
	
	for(vector <chord>::iterator iter=chords.begin();iter!=chords.end();iter++) {
		iter->texture->release();
	}
	
	
}

void testApp::soundStreamStart() {
	ofSoundStreamStart();
}

void testApp::soundStreamStop() {
	ofSoundStreamStop();
}

//--------------------------------------------------------------
void testApp::update(){
	//ofBackground(20,100,20);
	
	outer.update();
	
	if (outer.getIsNewStop()) {
		mode = outer.getStop();
		cout << "stop - mode: " << mode << endl;
		setKeys();
		outer.resetIsNewStop();
		bRefreshDisplay = true;
		// = -note * 2.0f * M_PI / 6.0f;
	}
	
	if (bLock) {
		inner.setPhi(outer.getPhi());
	} else {
		inner.update();
		
		if (inner.getIsNewStop()) {
			firstNote = (float)inner.getStop()* 6.0f / numDivisions ;
			cout << "stop - first note: " << firstNote << endl;
			setKeys();
			inner.resetIsNewStop();
			// = -note * 2.0f * M_PI / 6.0f;
		}
	}
	
	if (!strumNotes.empty()) {
		if (ofGetElapsedTimeMillis()-lastStrum>STRUM_DELAY) {
			vector<float>::iterator iter = strumNotes.begin();
			int midi = floor(48+2.0f*(*iter));
			float intpart;
			float cents = floor(modf(2.0f*(*iter),&intpart)*100.0f);
			instrument.noteOn(midi, 64,cents);
			strumNotes.erase(strumNotes.begin());
			lastStrum = ofGetElapsedTimeMillis();
		}
	}
	
	if (bAnim) {
		if (ofGetElapsedTimeMillis()-animTime>=animDuration) {
			bAnim = false;
			center = targetCenter;
			scaleFactor = targetScaleFactor;
		} else {
			float t = (float)(ofGetElapsedTimeMillis() - animTime)/animDuration; // time to finish the animation
			center.x = easeInOutQuad(t,center.x,targetCenter.x);
			center.y = easeInOutQuad(t,center.y,targetCenter.y);
			scaleFactor = easeInOutQuad(t,scaleFactor,targetScaleFactor);
		}
		
	}
	
	if (bPlayTaqsim) {
		if (!taqsim.getNumPlaying()) {
			taqsim.exit();
			bPlayTaqsim = false;
			int bLoaded = taqsim.load(ofToDataPath(taqsimName), bufferSize);
			if (bLoaded) {
				taqsim.play();
			} else {
				printf("playTaqsim missing: %s",taqsimName.c_str());
			}
		}
				
	}
}

void testApp::drawKeys() {
	int height = ofGetHeight()/getNumKeys();
	int width = getKeyWidth();
	
	
	for (int i=0; i<getNumKeys(); i++) {
		
		ofFill();
		
		switch (state) {
			case MUSICREED_STATE_SCALES:
				noteButtons[i].draw();
				break;
			case MUSICREED_STATE_CHORDS:
				chordButtons[i].draw();
				break;
				
			default:
				break;
		}
		
	}
	
	ofSetColor(255, 255, 255,50);
	ofEnableAlphaBlending();
	keysTexture.draw();
	ofDisableAlphaBlending();
	
	
	for (int i=0; i<getNumKeys(); i++) {
		
		if (bDown) {
			if ( i==(int)((ofGetHeight()-lastPos.y)/(ofGetHeight()/getNumKeys()))) {
				ofSetColor(200,200,200,0.2);
				ofRect(ofGetWidth()-width, ofGetHeight()-(i+1)* height,width, height);
			}
		}	
		
		ofNoFill();
		ofSetColor(0xFFFFFF);
		
		//		char str[15];
		//		int octave = floor((i+mode) / currentScale->notes.size());
		//		float note = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
		//
		//		sprintf(str, "%s(%2.3f)",keys[i % keys.size()].c_str(),note);
		
		switch (state) {
			case MUSICREED_STATE_SCALES:
				ttf.drawString(keysNames[i % keysNames.size()], ofGetWidth()-width, ofGetHeight()-(i*height+ttf.getLineHeight()));
				break;
			case MUSICREED_STATE_CHORDS:
				if (chordsKeys[i % keysNames.size()] < chordsKeys.size()) {
					ttf.drawString(keysNames[i % keysNames.size()]+chords[chordsKeys[i % keysNames.size()]].name,ofGetWidth()-width, ofGetHeight()-(i*height+ttf.getLineHeight()));
				}
				
				break;
				
			default:
				break;
		}
	}
	
	
	if (!altChords.empty()) {
		for (vector<int>::iterator aiter=altChords.begin(); aiter!=altChords.end(); aiter++) {
			
			float y = distance(altChords.begin(), aiter)* height;
			
			if (bAltKeyDown && distance(altChords.begin(), aiter)==lastAltKey) {
				ofFill();
				ofSetColor(0xA0A0A0);
				
				ofRect(0, y,width, height);
			} 				
			
			
			ofNoFill();
			ofSetColor(0xFFFFFF);
			ttf.drawString(chordNoteName+chords[*aiter].name, 0, y+ttf.getLineHeight());
			
		}
	}
	
}

//--------------------------------------------------------------
void testApp::draw(){
	
	ofBackground(0,0,0);
	
	
	
	
	if (!bAnim && !bLock) {
		drawKeys();
	}
	
				
	//glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	ofPushMatrix();
	//ofEnableAlphaBlending(); // for png textures not for pvr
	
	
	ofTranslate(center.x,center.y);
	ofScale(scaleFactor, scaleFactor, 1);

//	ofPushMatrix();
//	ofTranslate(-(int)shadow._width/2, -(int)shadow._height/2);
//	shadow.draw();
//	ofPopMatrix();
	
	switch (state) {
		case MUSICREED_STATE_SCALES:
			ofPushMatrix();
			ofTranslate(-(int)scaleBackground._width/2, -(int)scaleBackground._height/2);
			scaleBackground.draw();
			ofPopMatrix();
			
			ofPushMatrix();
			ofRotate(180*inner.getPhi()/M_PI+90);
			ofTranslate(-(int)scaleInnerPattern._width/2, -(int)scaleInnerPattern._height/2);
			scaleInnerPattern.draw();
			ofPopMatrix();
			
			ofPushMatrix();
			ofRotate(180*outer.getPhi()/M_PI+90);
			ofTranslate(-(int)scaleOuterPattern._width/2, -(int)scaleOuterPattern._height/2);
			scaleOuterPattern.draw();
			ofPopMatrix();
			
			ofPushMatrix();
			ofTranslate(-(int)scaleHighlight._width/2, -(int)scaleHighlight._height/2);
			scaleHighlight.draw();
			ofPopMatrix();
			
			break;
		case MUSICREED_STATE_CHORDS: 
			ofPushMatrix();
			ofTranslate(-(int)chordBackground._width/2, -(int)chordBackground._height/2);
			chordBackground.draw();
			ofPopMatrix();
			
			ofPushMatrix();
			ofRotate(180*inner.getPhi()/M_PI+90);
			ofTranslate(-(int)chordPattern._width/2, -(int)chordPattern._height/2);
			chordPattern.draw();
			ofPopMatrix();
			
			ofPushMatrix();
			ofTranslate(-(int)chordHighlight._width/2, -(int)chordHighlight._height/2);
			chordHighlight.draw();
			ofPopMatrix();
			
			break;
		default:
			break;
	}
	
	
	
	switch (state) {
		case MUSICREED_STATE_SCALES:
			
			
			ofPushMatrix();
			ofRotate(180*outer.getPhi()/M_PI+90);
			ofTranslate(-(int)scaleOuterPattern._width/2, -(int)scaleOuterPattern._height/2);
					
			for(vector <scale>::iterator iter=scales.begin();iter!=scales.end();iter++) {
				glColor4f(1.0f, 1.0f, 1.0f,iter==currentScale ? 1.0f : 0.25f);
				iter->texture->draw();
			}
			ofPopMatrix();
			
		
			break;
		case MUSICREED_STATE_CHORDS: 
			
			
			if (bDown || bAltKeyDown) {
				
				float note = currentScale->notes[(lastKey.y+mode) % currentScale->notes.size()]-currentScale->notes[mode];
				
				
				ofPushMatrix();
				ofRotate(90+note*60);
				vector<chord>::iterator citer = chords.begin()+lastChordIndex;
				ofTranslate(-(int)citer->texture->_width/2, -(int)citer->texture->_height/2);
				citer->texture->draw();
				ofPopMatrix();
				
				
				vector<float> notes;
				notes.push_back(note);
				for (vector<float>::iterator iter = chords[lastChordIndex].intervals.begin(); iter!=chords[lastChordIndex].intervals.end(); iter++) {
					notes.push_back(note+*iter);
				}
				
				
				for (vector<float>::iterator iter = notes.begin(); iter!=notes.end();iter++) {
					ofPushMatrix();
					ofRotate(90+(*iter)*60);
					ofTranslate(-(int)chordMask._width/2, -(int)chordMask._height/2);
					chordMask.draw();
					ofPopMatrix();
				}
				
			}

			break;
		default:
			break;
	}
	
	glColor4f(1.0f, 1.0f, 1.0f,1.0f);
	
	if (!bAnim && !bLock) {
		
		switch (state) {
			case MUSICREED_STATE_SCALES:
				ofPushMatrix();
				ofTranslate(-(int)scaleNeedle._width/2, -(int)scaleNeedle._height/2);
				scaleNeedle.draw();
				ofPopMatrix();
				break;
			case MUSICREED_STATE_CHORDS:
				ofPushMatrix();
				ofTranslate(-(int)chordNeedle._width/2, -(int)chordNeedle._height/2);
				chordNeedle.draw();
				ofPopMatrix();
				break;
			default:
				break;
		}
	}
	
	
	
	ofPopMatrix();
	

	
}

//--------------------------------------------------------------
void testApp::exit(){
	suspend();
	ofSoundStreamClose();
	instrument.exit();
	taqsim.exit();
	inner.exit();
	outer.exit();
	
	for(vector <scale>::iterator iter=scales.begin();iter!=scales.end();iter++) {
		delete iter->texture;
	}
	
	for(vector <chord>::iterator iter=chords.begin();iter!=chords.end();iter++) {
		delete iter->texture;
	}
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
	
	taqsim.mixChannel(output, 0, nChannels);	
	taqsim.mixChannel(output, 1, nChannels);	
	taqsim.postProcess();
		
	limiter.audioProcess(output,bufferSize,nChannels);
	
	
}

void testApp::playChord(int chordIndex,float base) {
	vector<float> notes;
	notes.push_back(base);
	for (vector<float>::iterator iter = chords[chordIndex].intervals.begin(); iter!=chords[chordIndex].intervals.end(); iter++) {
		notes.push_back(base+*iter);
	}
	
	instrument.noteOffAll();
	for (vector<float>::iterator iter = notes.begin(); iter!=notes.end();iter++) {
		int midi = floor(48+2.0f*(*iter));
		float intpart;
		float cents = floor(modf(2.0f*(*iter),&intpart)*100.0f);
		instrument.noteOn(midi, 64,cents);
	}
}

void testApp::strumChord(int chordIndex,float base) {
	strumNotes.push_back(base);
	for (vector<float>::iterator iter = chords[chordIndex].intervals.begin(); iter!=chords[chordIndex].intervals.end(); iter++) {
		strumNotes.push_back(base+*iter);
	}
	
	instrument.noteOffAll();
	lastStrum = ofGetElapsedTimeMillis();
	
		
}

key testApp::pointToKey(ofPoint pos) {
	key res;
	res.y = (int)((ofGetHeight()-pos.y)/(ofGetHeight()/getNumKeys())) ;
	res.x = (int)((ofGetWidth()-pos.x)/(ofGetWidth()/4));
	
	return res;
}


//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	
	//printf("touchDown\n");
	
	ofPoint pnt = ofPoint(touch.x,touch.y)-center;
	ofPoint pos = ofPoint(distance(pnt)/scaleFactor,atan2(pnt.y, pnt.x));
	
//	printf("touchDown (%.0f,%.0f) (%.1f,%.2f)\n",pnt.x,pnt.y,pos.x,pos.y);
//	printf("touchDown (%.2f,%.2f)\n",pos.x,pos.y);
	
	switch (state) {
			
		case MUSICREED_STATE_SCALES: {
			inner.touchDown(pos);
			outer.touchDown(pos);
			if (!inner.getIsDown() && !outer.getIsDown()) {
				
				bDown = true;
				downPos=lastPos=ofPoint(touch.x,touch.y);
				
				key currentKey = downKey = pointToKey(downPos);
				
				noteButtons[currentKey.y].setDown(true);
				
				
				int octave = floor((currentKey.y+mode) / currentScale->notes.size());
				float note = firstNote+currentScale->notes[(currentKey.y+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
				int midi = floor(48+2.0f*note);
				float intpart;
				int cents = floor(modf(2.0f*note,&intpart)*100.0f);
				
				printf("note: %s(%2.3f), midi: %i, cents: %i\n",keysNames[currentKey.y % keysNames.size()].c_str(),note,midi,cents);
				instrument.noteOffAll();
				instrument.noteOn(midi, 100,cents);
				
				//instrument.noteOn(lastKey+lastArp*4, 127);
				//instrument.noteOff(iter->note);
				
				lastKey = currentKey;
			}
		} break;
		case MUSICREED_STATE_CHORDS: {
			inner.touchDown(pos);
			if (!inner.getIsDown()) {
								
				if (touch.x>ofGetWidth()-getKeyWidth()) {
					bDown = true;

					downPos=lastPos=ofPoint(touch.x,touch.y);
					
					key currentKey = pointToKey(downPos);
					
					chordButtons[currentKey.y].setDown(true);
					
					int octave = floor((currentKey.y+mode) / currentScale->notes.size());
					int index = chordsKeys[currentKey.y % chordsKeys.size()];
					float base = firstNote+currentScale->notes[(currentKey.y+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
					strumChord(index, base);

					lastKey = currentKey;
					lastChordIndex = index;
					
					
					setAltChords();
				}
				
				if (touch.x<getKeyWidth() && touch.y/(ofGetHeight()/getNumKeys())<altChords.size()) {
					bAltKeyDown = true;
					
					
					int octave = floor((lastKey.y+mode) / currentScale->notes.size());
					
					float base = firstNote+currentScale->notes[(lastKey.y+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
					int key = (int)(touch.y/(ofGetHeight()/getNumKeys())) ;
					int index = altChords[key % altChords.size()];
					strumChord(index, base);
										
					lastChordIndex = index;
					
					lastAltKey = key;
				}
				
				
				
				
			}
		} break;
		default:
			break;
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
	
	if (bDown) {
		switch (state) {
			case MUSICREED_STATE_SCALES: {
				key currentKey = pointToKey(ofPoint(touch.x,touch.y));
				noteButtons[lastKey.y].setDown(false);

				noteButtons[currentKey.y].setDown(true);
				
				if (currentKey.y!=lastKey.y || currentKey.x!=lastKey.x) {
					
					int playKey;
					if (currentKey.x>0) {
						playKey = downKey.y + 2*(abs(currentKey.y-downKey.y)+currentKey.x);
					} else {
						playKey = currentKey.y;
					}

					
					
					
					int octave = floor((playKey+mode) / currentScale->notes.size());
					float note = firstNote+currentScale->notes[(playKey+mode) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
					int midi = floor(48+2.0f*note);
					float intpart;
					int cents = floor(modf(2.0f*note,&intpart)*100.0f);
					
					printf("note: %3.3f, midi: %i, cents: %i\n",note,midi,cents);
					instrument.noteOn(midi, 100,cents);
					
					lastKey = currentKey;
	
				}
			}	break;
				
			default:
				break;
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
	bDown = false;
	bAltKeyDown = false;
	noteButtons[lastKey.y].setDown(false);
	chordButtons[lastKey.y].setDown(false);
	
	if (state == MUSICREED_STATE_SCALES) {
		if (!bLock) {
			if (distance(pnt) < 100*0.55f ) {
				lock(true);
			}
		} else {
			if (distance(pnt) < 100*0.35f ) {
				lock(false);
			}
		}
	}
	

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	//setState(state == MUSICREED_STATE_SCALES ? MUSICREED_STATE_CHORDS : MUSICREED_STATE_SCALES);
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

void testApp::setState(int state,int rotDuration) {
	this->state = state;
	switch (state) {
		case MUSICREED_STATE_SCALES:
			targetScaleFactor = 0.55;
			targetCenter = ofPoint(-30,ofGetHeight()/2);
			break;
		case MUSICREED_STATE_CHORDS:
			bLock = false;
			outer.setRadii(200, 500);
			outer.setLock(false);
			targetScaleFactor = 0.8;
			targetCenter = ofPoint(ofGetWidth()/2,ofGetHeight()/2);
			break;
		default:
			break;
	}
	
	if (rotDuration) {
		bAnim = true;
		animDuration = rotDuration*2;
		animTime = ofGetElapsedTimeMillis();
	} else {
		center = targetCenter;
		scaleFactor = targetScaleFactor;
	}
}

// other place where I change bLock is when moving to chords view (in set state)
void testApp::lock(bool bLock) {
	if ( bLock == this->bLock || bAnim ) {
		return;
	}
	
	if (bLock) {
		targetScaleFactor = 0.35;
		targetCenter = ofPoint(ofGetWidth()/2,ofGetHeight()/2);
		outer.setRadii(100, 500);
		outer.setLock(true);
	} else {
		targetScaleFactor = 0.55;
		targetCenter = ofPoint(-30,ofGetHeight()/2);
		outer.setRadii(200, 500);
		outer.setLock(false);
	}  
		
	animDuration = 500;
	bAnim = true;
	animTime = ofGetElapsedTimeMillis();
	
	this->bLock = bLock;
}

int testApp::getState() {
	return state;	
}

int testApp::getKeyWidth() {
	
	return state==MUSICREED_STATE_SCALES ? ofGetWidth()/4 : ofGetWidth()/5;
}

int testApp::getNumKeys() {
	
	return state==MUSICREED_STATE_SCALES ? VERTICAL_KEYS_NUMBER : HORIZONTAL_KEYS_NUMBER;
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


void testApp::setAltChords() {
	altChords.clear();	
	
	int firstScaleNote = evalScaleNote(firstNote);
	float chordNote = firstNote+currentScale->notes[(lastKey.y+mode) % currentScale->notes.size()]+floor((lastKey.y+mode) / currentScale->notes.size())*6-currentScale->notes[mode];
	
	chordNoteName = findNote(firstScaleNote+lastKey.y,chordNote);
	
		
	for (vector<chord>::iterator citer=chords.begin(); citer!=chords.end(); citer++) {
		int i=1;
		vector<float>::iterator iiter=citer->intervals.begin();
		
		while (iiter!=citer->intervals.end() ) {
			
			float note = firstNote+currentScale->notes[(lastKey.y+mode+i) % currentScale->notes.size()]+floor((lastKey.y+mode+i) / currentScale->notes.size())*6-currentScale->notes[mode];
			
			if (note-chordNote<(*iiter)) {
				i++;
			} else if (note-chordNote==(*iiter)) {
				iiter++;
				i++;
				
			} else {
				break;
			}
		}
		
		if (iiter==citer->intervals.end()) {
			altChords.push_back(distance(chords.begin(),citer));
		}
			
			
			
	
	}
	
}

void testApp::setKeys() {
	keysNames.clear();
	
	
	if (currentScale->notes.size()==7) {
		int firstScaleNote = evalScaleNote(firstNote);
		for (vector<float>::iterator iter=currentScale->notes.begin(); iter!=currentScale->notes.end(); iter++) {
			int i = distance(currentScale->notes.begin(),iter);
			float knote = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]-currentScale->notes[mode];
			keysNames.push_back(findNote(firstScaleNote+i,knote));
			printf("note: %i, %f, %s\n",firstScaleNote+i,knote,keysNames.back().c_str());
					 
		}
	} else {
		for (vector<float>::iterator iter=currentScale->notes.begin(); iter!=currentScale->notes.end(); iter++) {
			int i = distance(currentScale->notes.begin(),iter);
			float knote = firstNote+currentScale->notes[(i+mode) % currentScale->notes.size()]-currentScale->notes[mode];
			
			keysNames.push_back(findNote(evalScaleNote(knote),knote));
							
		}
	}
	
	altChords.clear();
	chordsKeys.clear();
	//int firstScaleNote = evalScaleNote(firstNote);
	
	for (vector<float>::iterator iter=currentScale->notes.begin(); iter!=currentScale->notes.end(); iter++) {
		
		vector<float> notes;
		int base = distance(currentScale->notes.begin(),iter);
		
		printf("chord base: %i\t",base+mode);
		
		for (int i=0; i<3; i++) {
			
			int octave = floor((base+mode+2*i) / currentScale->notes.size());
			float note = currentScale->notes[(base+mode+2*i) % currentScale->notes.size()]+octave*6-currentScale->notes[mode];
			
			//printf("note: %s(%2.3f), midi: %i, cents: %i\n",keysNames[key % keysNames.size()].c_str(),note,midi,cents);
			notes.push_back(note);	
			printf("%.2f\t",note);
			
		}
		printf("\n");
		
		
		vector<chord>::iterator citer;
		for (citer=chords.begin(); citer!=chords.end(); citer++) {
			if (citer->intervals.size()==2 && citer->intervals[0]==notes[1]-notes[0] && citer->intervals[1]==notes[2]-notes[0]) {
				break;
			}
		}
		
		//assert(citer!=chords.end());
				
		//chordsNames.push_back(findNote(firstScaleNote+base,notes[0])+citer->name);
		chordsKeys.push_back(distance(chords.begin(),citer));
		
	}
}


void testApp::playTaqsim(string filename) {
	taqsimName = filename+".caf";
	bPlayTaqsim = true;
	stopTaqsim();
}

void testApp::stopTaqsim() {
	if (taqsim.getNumPlaying()) {
		taqsim.stop();
	}
}

