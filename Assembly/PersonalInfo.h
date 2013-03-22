//
//  PersonalInfo.h
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfo : NSObject

-(void) inputFirstName:(NSString*) firstName;
-(void) inputLastName:(NSString*) lastName;
-(void) inputEmail:(NSString*) e_mail;
-(void) inputPhoneNum:(NSString*) p_num;
-(NSString*) displayName;

@end
