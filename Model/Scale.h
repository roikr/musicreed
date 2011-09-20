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
	NSString *url;
	BOOL bAscending;
	BOOL bDescending;
	BOOL bTaqsim;
}

@property (nonatomic,copy) NSString *system;
@property NSUInteger divisions;
@property (nonatomic,copy) NSString *subsystem;
@property (nonatomic,copy) NSString *name;
@property NSUInteger type;
@property NSUInteger mode;
@property float note;
@property (nonatomic,copy) NSString *url;
@property BOOL bAscending;
@property BOOL bDescending;
@property BOOL bTaqsim;

+ (id)scaleWithSystem:(NSString *)system divisions:(NSUInteger)divisions subsystem:(NSString *)subsystem name:(NSString *)name type:(NSUInteger)type 
				 mode:(NSUInteger)mode note:(float)note url:(NSString *)url ascending:(BOOL)bAscending descending:(BOOL)bDescending taqsim:(BOOL)bTaqsim;

@end
