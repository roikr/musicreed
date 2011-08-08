//
//  Scale.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Scale : NSObject {
	NSString *system;
	NSUInteger divisions;
	NSString *subsystem;
	NSString *name;
	NSUInteger type;
	NSUInteger mode;
	float	   note;
	NSString *filename;
	BOOL bAscending;
	BOOL bDescending;
}

@property (nonatomic,copy) NSString *system;
@property NSUInteger divisions;
@property (nonatomic,copy) NSString *subsystem;
@property (nonatomic,copy) NSString *name;
@property NSUInteger type;
@property NSUInteger mode;
@property float note;
@property (nonatomic,copy) NSString *filename;
@property BOOL bAscending;
@property BOOL bDescending;

+ (id)scaleWithSystem:(NSString *)system divisions:(NSUInteger)divisions subsystem:(NSString *)subsystem name:(NSString *)name type:(NSUInteger)type mode:(NSUInteger)mode note:(float)note filename:(NSString *)filename ascending:(BOOL)bAscending descending:(BOOL)bDescending;

@end
