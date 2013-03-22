//
//  GroupInfo.m
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "GroupInfo.h"
#import "PersonalInfo.h"

@implementation GroupInfo
{
    NSMutableArray *group_members_info;
    NSString *group_name;
    NSUInteger *color_id;
}

-(id) init
{
    if(self = [super init])
	{
		group_members_info = [[NSMutableArray alloc] init];
        color_id = 0;
        group_name = @"NO NAME";
	}
	return self;
}

-(NSUInteger) count
{
    return group_members_info.count;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(void) updateGroupName:(NSString *)groupName
{
    group_name = groupName;
}

-(void) updateColorID:(NSUInteger*)color
{
    color_id = color;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(void) pushInfo:(PersonalInfo *)p_info
{
    [group_members_info addObject:p_info];
}

-(void) deleteInfo:(NSUInteger)at
{
    [group_members_info removeObjectAtIndex:at];
}

-(PersonalInfo*) PersonAt:(NSUInteger)index
{
    return [group_members_info objectAtIndex:index];
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(void) changeFirstName:(NSString*)newFirst index:(NSUInteger)at
{
    PersonalInfo *temp = [group_members_info objectAtIndex:at];
    [temp inputFirstName:newFirst];
    [group_members_info removeObjectAtIndex:at];
    [group_members_info insertObject:temp atIndex:at];
}

-(void) changeLastName:(NSString *)newLast index:(NSUInteger)at
{
    PersonalInfo *temp = [group_members_info objectAtIndex:at];
    [temp inputLastName:newLast];
    [group_members_info removeObjectAtIndex:at];
    [group_members_info insertObject:temp atIndex:at];
}

-(void) changeEmail:(NSString *)newEmail index:(NSUInteger)at
{
    PersonalInfo *temp = [group_members_info objectAtIndex:at];
    [temp inputEmail:newEmail];
    [group_members_info removeObjectAtIndex:at];
    [group_members_info insertObject:temp atIndex:at];
}

-(void) changePhoneNum:(NSString *)newPhone index:(NSUInteger)at
{
    PersonalInfo *temp = [group_members_info objectAtIndex:at];
    [temp inputPhoneNum:newPhone];
    [group_members_info removeObjectAtIndex:at];
    [group_members_info insertObject:temp atIndex:at];
}
@end
