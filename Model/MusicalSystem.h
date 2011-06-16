//
//  MusicalSystem.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MusicalSystem : NSObject {
	NSString *name;
	NSMutableArray *scales;
	NSUInteger numDivisions;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSMutableArray *scales;
@property NSUInteger numDivisions;

+ (MusicalSystem *)musicalSystemWithName:(NSString *)systemName withNumDivisions:(NSUInteger)divisions;
- (void) addScaleWithName:(NSString *)scaleName withType:(NSUInteger)theType withMode:(NSUInteger)theMode withFirstNote:(float)note withFilename:(NSString *)theFilename;

@end
