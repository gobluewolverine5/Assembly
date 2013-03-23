//
//  PersonalInfo.m
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "PersonalInfo.h"

@implementation PersonalInfo
{
    NSString *first_name;
    NSString *last_name;
    NSString *email;
    NSString *phone_num;
}

-(id) init
{
    if(self = [super init]){}
	return self;
}

-(void) inputFirstName:(NSString *)firstName
{
    first_name = firstName;
}

-(void) inputLastName:(NSString *)lastName
{
    last_name = lastName;
}

-(void) inputEmail:(NSString *)e_mail
{
    email = e_mail;
}

-(void) inputPhoneNum:(NSString *)p_num
{
    phone_num = p_num;
}

-(NSString*) displayName
{
    return [NSString stringWithFormat:@"%@ %@",first_name, last_name];
}

-(NSString*) displayEmail
{
    return email;
}

-(NSString*) displayPhone
{
    return phone_num;
}

@end
