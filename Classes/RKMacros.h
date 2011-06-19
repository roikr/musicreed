/*
 *  RKMacros.h
 *  Musicreed
 *
 *  Created by Roee Kremer on 6/19/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifdef _Debug
#define RKLog( s, ... ) \
do { \
NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ); \
} \
while (0)
#else
#define RKLog( s, ... ) do {} while (0)
#endif