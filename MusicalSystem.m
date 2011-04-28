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

+ (MusicalSystem *)musicalSystemWithName:(NSString *)systemName {
	MusicalSystem *newSystem = [[MusicalSystem alloc] init];
	newSystem.name = systemName;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	newSystem.scales = array;
	[array release];
	return newSystem;
}


- (void)addScaleWithName:(NSString *)scaleName  {
	MusicalScale *scale = [[MusicalScale alloc] initWithScaleName:scaleName];
	[scales addObject:scale];
	[scale release];
}

@end
