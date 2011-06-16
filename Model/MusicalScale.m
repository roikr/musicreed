//
//  MusicalScale.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicalScale.h"


@implementation MusicalScale

@synthesize name;
@synthesize type;
@synthesize mode;
@synthesize firstNote;
@synthesize filename;

- (id)initWithScaleName:(NSString *)scaleName withType:(NSUInteger)theType withMode:(NSUInteger)theMode withFirstNote:(float)note withFilename:(NSString *)theFilename {
	
	if (self = [super init]) {
		name = [scaleName retain];
		type = theType;
		mode = theMode;
		firstNote = note;
		filename = [theFilename retain];
	}
	return self;
}


@end
