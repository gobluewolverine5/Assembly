//
//  GroupInfo.h
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalInfo.h"

@interface GroupInfo : NSObject<NSCoding>

-(NSUInteger) count;

//Setting the Group Name and Color ID
-(void) updateGroupName:(NSString*) groupName;
-(void) updateColorID:(int) color;

//Adding & Deleting Personal Info objects in GroupInfo
-(void) pushInfo: (PersonalInfo*) p_info;
-(void) deleteInfo: (NSUInteger) at;
-(PersonalInfo*) PersonAt:(NSUInteger)index;

//Modifying Personal info in Group Info
-(void) changeFirstName:(NSString*)newFirst index:(NSUInteger) at;
-(void) changeLastName:(NSString*)newLast index:(NSUInteger) at;
-(void) changeEmail:(NSString*)newEmail index:(NSUInteger) at;
-(void) changePhoneNum:(NSString*) newPhone index:(NSUInteger) at;

//Return Data
-(NSString*) displayGroupName;
-(int) displayColorID;
-(NSString*) displayPicture;
-(NSMutableArray*) returnGroupMembersInfo;

//File Saving
- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)decoder;

@end
