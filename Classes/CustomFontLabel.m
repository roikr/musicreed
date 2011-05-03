//
//  CustomFontLabel.m
//  MilgromInterface
//
//  Created by Roee Kremer on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomFontLabel.h"


@implementation CustomFontLabel

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder])
    {
        [self setFont: [UIFont fontWithName: @"Maiandra GD" size: self.font.pointSize]];
    }
    return self;
}

@end
