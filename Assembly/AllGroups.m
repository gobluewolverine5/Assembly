//
//  AllGroups.m
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "AllGroups.h"
#import "PersonalInfo.h"
#import "GroupInfo.h"

@implementation AllGroups
{
    NSMutableArray *Groups;
}

-(id) init
{
    if(self = [super init]){
        Groups = [[NSMutableArray alloc] init];
    }
	return self;
}

-(NSUInteger) count
{
    return [Groups count];
}

-(void) pushGroup:(GroupInfo *)newGroup
{
    [Groups addObject:newGroup];
}

-(void) removeGroup:(NSUInteger)at
{
    [Groups removeObjectAtIndex:at];
}

-(void) updateGroupName:(NSString *)newName at:(NSUInteger)index
{
    GroupInfo *tempGroupInfo = [[GroupInfo alloc]init];
    [tempGroupInfo updateGroupName:newName];
    [Groups removeObjectAtIndex:index];
    [Groups insertObject:tempGroupInfo atIndex:index];
}

-(void) updateColorID:(int)color at:(NSUInteger)index
{
    GroupInfo *tempGroupsInfo = [[GroupInfo alloc]init];
    [tempGroupsInfo updateColorID:color];
    [Groups removeObjectAtIndex:index];
    [Groups insertObject:tempGroupsInfo atIndex:index];
}

-(GroupInfo*) objectAt:(NSUInteger)index
{
    return [Groups objectAtIndex:index];
}
@end
