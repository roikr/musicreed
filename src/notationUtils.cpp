/*
 *  notationUtils.cpp
 *  Musicreed
 *
 *  Created by Roee Kremer on 6/14/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "notationUtils.h"

int evalScaleNote(float note) {
	vector<float> notes;
	float notesInit[] = {0,1,2,2.5,3.5,4.5,5.5};
	notes = vector<float>(notesInit,notesInit+7);
	vector<float>::iterator iter,citer;
	citer = notes.begin();
	for (iter=notes.begin(); iter!=notes.end(); iter++) {
		if (fabs(fmod(*citer-note,6))>fabs(fmod(*iter-note,6))) {
			citer=iter;
		}
	}
	
	return distance(notes.begin(), citer);
}

string findNote(int scaleNote,float note) {
	
	// U+1D12A
	//string hsharp="\xf0\x9d\x84\xb2"; // half sharp U+1D132
	//string hflat="\xf0\x9d\x84\xb3"; // half flat U+1D133
	
	string scaleNotes="CDEFGAB";
	/*
	string sharp="\xe2\x99\xaf";
	string dsharp="\xf0\x9d\x84\xaa";
	string flat="\xe2\x99\xad";
	string dflat="\xf0\x9d\x84\xab";
	*/
	string sharp="#";
	string dsharp="x";
	string flat="b";
	string dflat="bb";
	
	
	vector<float> notes;
	float notesInit[] = {0,1,2,2.5,3.5,4.5,5.5};
	notes = vector<float>(notesInit,notesInit+7);
	
	
	int mod = (scaleNote+scaleNotes.size()) % scaleNotes.size();
	float diff = fmod(note-notes[mod],6);
	diff+= (fabs(diff)<=3) ? 0 : diff < 0 ? 6 : -6;  
	
	while (fabs(diff)>1.00) {
		//cout << "(" <<scaleNotes[mod] << ", " << diff << ")\t"; 
		scaleNote+= diff>0 ? 1 : -1;
		
		mod = (scaleNote+scaleNotes.size()) % scaleNotes.size();
		diff = fmod(note-notes[mod],6);
		diff+= (fabs(diff)<=3) ? 0 : diff < 0 ? 6 : -6;  
		
	}
	
	//cout << endl;
	
	
	stringstream ss;
	
	float intpart;
	
	if (modf (diff*2 , &intpart)==0) {
		ss<<scaleNotes[mod];
		
		switch (int(intpart)) {
			case -2:
				ss<<dflat;
				break;
			case -1:
				ss<<flat;
				break;
			case 1:
				ss<<sharp;
				break;
			case 2:
				ss<<dsharp;
				break;
		}
		
	}
	
	else {
		while (fabs(diff)>0.5) {
			//cout << "(" <<scaleNotes[mod] << ", " << diff << ")\t";  
			scaleNote+= diff>0 ? 1 : -1;
			mod = (scaleNote+scaleNotes.size()) % scaleNotes.size();
			diff = fmod(note-notes[mod],6);
			diff+= (fabs(diff)<=3) ? 0 : diff < 0 ? 6 : -6;  
			
		}
		
		ss<<scaleNotes[mod];
		modf (diff*8 , &intpart);
		
		switch (int(intpart)) {
			case -3:
			case -2:
			case 2:
			case 3:
				ss << "h";
				break;
		}
		
		switch (int(intpart)) {
			case -4:
			case -3:
			case -2:
				
				ss << flat;
				break;
			case 2:
			case 3:
			case 4:
				ss << sharp;
				break;
		}
		
		switch (int(intpart)) {
			case -3:
			case -1:
				ss << "-";
				break;
			case 1:
			case 3:
				ss << "+";
				break;
		}
		
	}
	
	return ss.str();
	
	
}

