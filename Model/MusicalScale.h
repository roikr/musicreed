//
//  MusicalScale.h
//  Musicreed
//
//  Created by Roee Kremer on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MusicalScale : NSObject {
	NSString *name;
	NSUInteger type;
	NSUInteger mode;
	float	   firstNote;
	NSString *filename;
}

@property (nonatomic,retain) NSString *name;
@property NSUInteger type;
@property NSUInteger mode;
@property float firstNote;
@property (nonatomic,retain) NSString *filename;

- (id)initWithScaleName:(NSString *)scaleName withType:(NSUInteger)theType withMode:(NSUInteger)theMode withFirstNote:(float)note withFilename:(NSString *)theFilename;
@end
