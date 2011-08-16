//
//  ScalesParser.h
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scale;
@protocol ScalesParserDelegate;

@interface ScalesParser : NSObject<NSXMLParserDelegate>{
	id <ScalesParserDelegate> delegate;
	NSMutableArray *parsedScales;
	Scale *currentScale;		
}

@property (nonatomic, assign) id <ScalesParserDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *parsedScales;
@property (nonatomic, retain) Scale *currentScale;

- (void)parse;

@end



@protocol ScalesParserDelegate <NSObject>
- (void)parserDidEndParsingData:(ScalesParser *)parser;
@end

