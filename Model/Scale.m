//
//  Scale.m
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Scale.h"


@implementation Scale

@synthesize system;
@synthesize divisions;
@synthesize subsystem;
@synthesize name;
@synthesize type;
@synthesize mode;
@synthesize note;
@synthesize filename;
@synthesize bAscending;
@synthesize bDescending;

+ (id)scaleWithSystem:(NSString *)system divisions:(NSUInteger)divisions subsystem:(NSString *)subsystem name:(NSString *)name type:(NSUInteger)type mode:(NSUInteger)mode note:(float)note filename:(NSString *)filename ascending:(BOOL)bAscending descending:(BOOL)bDescending {
	Scale *newScale = [[[self alloc] init] autorelease];
	
	newScale.system = system;
	newScale.divisions = divisions;
	newScale.subsystem = subsystem;
	newScale.name = name;
	newScale.type = type;
	newScale.mode = mode;
	newScale.note = note;
	newScale.filename = filename;
	newScale.bAscending = bAscending;
	newScale.bDescending = bDescending;
	
	return newScale;
}




@end
