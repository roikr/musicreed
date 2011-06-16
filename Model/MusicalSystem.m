//
//  MusicalSystem.m
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicalSystem.h"
#import "MusicalScale.h"

@implementation MusicalSystem

@synthesize name;
@synthesize scales;
@synthesize numDivisions;

+ (MusicalSystem *)musicalSystemWithName:(NSString *)systemName withNumDivisions:(NSUInteger)divisions {
	MusicalSystem *newSystem = [[MusicalSystem alloc] init];
	newSystem.name = systemName;
	newSystem.numDivisions = divisions;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	newSystem.scales = array;
	[array release];
	return newSystem;
}


- (void) addScaleWithName:(NSString *)scaleName withType:(NSUInteger)theType withMode:(NSUInteger)theMode withFirstNote:(float)note withFilename:(NSString *)theFilename {
	MusicalScale *scale = [[MusicalScale alloc] initWithScaleName:scaleName withType:theType withMode:theMode withFirstNote:note withFilename:theFilename];
	[scales addObject:scale];
	[scale release];
}

@end
