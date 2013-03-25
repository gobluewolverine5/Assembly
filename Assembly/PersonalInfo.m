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
    NSMutableArray *email;
    NSMutableArray *phone_num;
    NSString *default_email;
    NSString *default_phone_num;
    NSString *default_imessage;
}

-(id) init
{
    if(self = [super init]){
        default_email = @"N/A";
        default_phone_num = @"N/A";
        default_imessage = @"N/A";
        phone_num = [[NSMutableArray alloc]init];
        email = [[NSMutableArray alloc] init];
    }
	return self;
}

/*~~~~~~~~~~~~~Input Attributes Functions~~~~~~~~~~~~~~~~*/

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
    [email addObject:e_mail];
    default_email = e_mail;
}

-(void) inputPhoneNum:(NSString *)p_num
{
    [phone_num addObject:p_num];
    default_phone_num = p_num;
}


/*~~~~~~~~~~~~~~Update Attributes Functions~~~~~~~~~~~~~~*/

-(void) updateDefaultEmail:(int) index
{
    default_email = [email objectAtIndex:index];
}

-(void) updateDefaultPhone:(int) index
{
    default_phone_num = [phone_num objectAtIndex:index];
}

-(void) updatedefaultImessage:(bool) mail at:(int) index
{
    if (mail) {
        default_imessage = [email objectAtIndex:index];
    }
    else{
        default_imessage = [phone_num objectAtIndex:index];
    }
}

/*~~~~~~~~~~~~~Return Attributes Functions~~~~~~~~~~~~*/
-(NSString*) displayName
{
    return [NSString stringWithFormat:@"%@ %@",first_name, last_name];
}

-(NSString*) displayEmail
{
    return default_email;
}

-(NSString*) displayPhone
{
    return default_phone_num;
}

-(NSString*) displayImessage
{
    return default_imessage;
}

-(NSString*) displayFirst
{
    return first_name;
}

-(NSString*) displayLast
{
    return last_name;
}

-(int) emailCount
{
    return [email count];
}

-(int) phoneCount
{
    return [phone_num count];
}

-(NSMutableArray*) emailArray;
{
    return email;
}

-(NSMutableArray*) phoneArray;
{
    return phone_num;
}


@end
