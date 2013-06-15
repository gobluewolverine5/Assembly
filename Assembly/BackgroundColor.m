//
//  BackgroundColor.m
//  Assembly
//
//  Created by Evan Hsu on 5/27/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "BackgroundColor.h"

@implementation BackgroundColor

-(id) init
{
    if(self = [super init]){}
	return self;
}

-(UIImage*) BGchooser:(int)selection
{
    switch (selection) {
            //Blue Metal
        case 0:
            return [UIImage imageNamed:@"Background(4).png"];
            break;
            //Green Metal
        case 1:
            return [UIImage imageNamed:@"Background(6).png"];
            break;
            //Red Metal
        case 2:
            return [UIImage imageNamed:@"Background(5).png"];
            break;
            //Yellow Metal
        case 3:
            return [UIImage imageNamed:@"Background(7).png"];
            break;
            //Basic Metal
        case 4:
            return [UIImage imageNamed:@"Background(3).png"];
            break;
        default:
            return [UIImage imageNamed:@"Background(3).png"];
            break;
    }
}
@end
