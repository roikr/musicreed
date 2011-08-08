//
//  ScalesParser
//  ScaleSelection
//
//  Created by Roee Kremer on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScalesParser.h"
#import "Scale.h"

@implementation ScalesParser

@synthesize delegate;
@synthesize parsedScales;
@synthesize currentScale;
@synthesize currentSystem;
@synthesize currentDivisions;

#pragma mark -
#pragma mark Parser

- (void)parse {
	
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"systems" ofType:@"xml"]]];
	self.parsedScales = [NSMutableArray array];
	
	[parser setDelegate:self];
	[parser parse];
	
}

- (void)dealloc {
    [parsedScales release];
    [currentSystem release];
    [currentScale release];
    [super dealloc];
}


#pragma mark -
#pragma mark Parser constants


// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kSystemsList = @"systems";
static NSString * const kSystemElementName = @"system";
static NSString * const kScaleElementName = @"scale";


#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:kSystemElementName]) {
		
		self.currentSystem = [attributeDict valueForKey:@"name"];
		NSNumber *value = [attributeDict valueForKey:@"divisions"];
		self.currentDivisions = value ? [value integerValue] : 12;
		
		
			//NSLog(@"system: %@",[attributeDict valueForKey:@"name"]);
    } else if ([elementName isEqualToString:kScaleElementName]) {
		self.currentScale = [Scale scaleWithSystem:currentSystem divisions:currentDivisions subsystem:@"test" name:[attributeDict valueForKey:@"name"] 
							type:[[attributeDict valueForKey:@"scale"] integerValue] mode:[[attributeDict valueForKey:@"mode"] integerValue] 
							note:[[attributeDict valueForKey:@"note"] floatValue] filename:[attributeDict valueForKey:@"filename"] 
							ascending:YES descending:YES];
		//NSLog(@"scale: %@",[attributeDict valueForKey:@"name"]);
	} 
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {     
    
	if ([elementName isEqualToString:kSystemsList]) {
		
		[delegate parserDidEndParsingData:self];
		
		
		//NSLog(@"system: %@",[attributeDict valueForKey:@"name"]);
    } else if ([elementName isEqualToString:kSystemElementName]) {
		self.currentSystem = nil;
    } else if ([elementName isEqualToString:kScaleElementName]) {
		[self.parsedScales addObject:currentScale];
	}
	
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"foundCharacters: %@",string);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseErrorOccurred: %@",[parseError description]);
}





@end
