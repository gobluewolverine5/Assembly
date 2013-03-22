//
//  AllGroups.h
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupInfo.h"
#import "PersonalInfo.h"

@interface AllGroups : NSObject

-(NSUInteger) count;

-(void) pushGroup:(GroupInfo*) newGroup;
-(void) removeGroup:(NSUInteger) at;

-(void) updateGroupName:(NSString*)newName at:(NSUInteger) index;
-(void) updateColorID:(NSUInteger*)color at:(NSUInteger) index;

-(GroupInfo*) objectAt:(NSUInteger) index;

@end
