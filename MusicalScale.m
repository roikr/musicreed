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

- (id)initWithScaleName:(NSString *)scaleName  {
	
	if (self = [super init]) {
		name = [scaleName retain];
	}
	return self;
}


@end
