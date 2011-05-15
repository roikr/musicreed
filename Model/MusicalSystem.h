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
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSMutableArray *scales;

+ (MusicalSystem *)musicalSystemWithName:(NSString *)systemName;
- (void)addScaleWithName:(NSString *)scaleName;
@end
