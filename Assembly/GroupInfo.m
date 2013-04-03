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
    int color_id;
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

/*~~~~~~~~~~File Saving~~~~~~~~~~~*/

-(void) encodeWithCoder:(NSCoder*) encoder
{
    [encoder encodeObject:group_members_info forKey:@"group_members_info"];
    [encoder encodeObject:group_name forKey:@"group_name"];
    [encoder encodeInt:color_id forKey:@"color_id"];
}

-(id) initWithCoder:(NSCoder*) decoder
{
    if ((self = [super init])) {
        group_members_info = [decoder decodeObjectForKey:@"group_members_info"];
        group_name = [decoder decodeObjectForKey:@"group_name"];
        color_id = [decoder decodeIntForKey:@"color_id"];
    }
    return self;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(NSUInteger) count
{
    return group_members_info.count;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(void) updateGroupName:(NSString *)groupName
{
    group_name = groupName;
}

-(void) updateColorID:(int)color
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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
-(NSString*) displayGroupName
{
    return group_name;
}

-(int) displayColorID
{
    return color_id;
}

-(NSString*) displayPicture
{
    NSLog(@"color is: %i", color_id);
    switch (color_id) {
        case 0:
            return @"BlueIcon.png";
        case 1:
            return @"GreenIcon.png";
        case 2:
            return @"Red Icon.png";
        case 3:
            return @"YellowIcon.png";
        default:
            return @"Images.jpeg";
    }
}

-(NSMutableArray*) returnGroupMembersInfo
{
    return group_members_info;
}
@end
