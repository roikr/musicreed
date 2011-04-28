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
}

@property (nonatomic,retain) NSString *name;

- (id)initWithScaleName:(NSString *)scaleName;
@end
