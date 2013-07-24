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
    NSString        *first_name;
    NSString        *last_name;
    NSMutableArray  *email;
    NSMutableArray  *phone_num;
    NSString        *default_email;
    NSString        *default_phone_num;
    NSString        *default_imessage;
    NSNumber        *email_index;
    NSNumber        *imessage_index;
    UIImage         *contact_pic;
    BOOL            pic_avail;
}

-(id) init
{
    if(self = [super init]){
        default_email       = @"N/A";
        default_phone_num   = @"N/A";
        default_imessage    = @"N/A";
        phone_num           = [[NSMutableArray alloc]init];
        email               = [[NSMutableArray alloc] init];
        contact_pic         = [[UIImage alloc] init];
        pic_avail           = FALSE;
    }
	return self;
}

/*~~~~~~~~~~File Saving~~~~~~~~~~~*/

-(void) encodeWithCoder:(NSCoder*) encoder
{
    [encoder encodeObject:first_name         forKey:@"first_name"];
    [encoder encodeObject:last_name          forKey:@"last_name"];
    [encoder encodeObject:email              forKey:@"email"];
    [encoder encodeObject:phone_num          forKey:@"phone_num"];
    [encoder encodeObject:default_email      forKey:@"default_email"];
    [encoder encodeObject:default_phone_num  forKey:@"default_phone_num"];
    [encoder encodeObject:default_imessage   forKey:@"default_imessage"];
    [encoder encodeObject:email_index        forKey:@"email_index"];
    [encoder encodeObject:imessage_index     forKey:@"imessage_index"];
    [encoder encodeObject:contact_pic        forKey:@"contact_pic"];
    [encoder encodeBool:pic_avail            forKey:@"pic_avail"];
}

-(id) initWithCoder:(NSCoder*) decoder
{
    if ((self = [super init])) {
        first_name          = [decoder decodeObjectForKey:@"first_name"];
        last_name           = [decoder decodeObjectForKey:@"last_name"];
        email               = [decoder decodeObjectForKey:@"email"];
        phone_num           = [decoder decodeObjectForKey:@"phone_num"];
        default_email       = [decoder decodeObjectForKey:@"default_email"];
        default_phone_num   = [decoder decodeObjectForKey:@"default_phone_num"];
        default_imessage    = [decoder decodeObjectForKey:@"default_imessage"];
        email_index         = [decoder decodeObjectForKey:@"email_index"];
        imessage_index      = [decoder decodeObjectForKey:@"imessage_index"];
        contact_pic         = [decoder decodeObjectForKey:@"contact_pic"];
        pic_avail           = [decoder decodeBoolForKey:@"pic_avail"];
    }
    return self;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~Input Attributes Functions~~~~~~~~~~~~~~~~*/

-(void) inputFirstName:(NSString *)firstName
{
    if (firstName == Nil) {
        first_name = @"";
    }else{
        first_name = firstName;
    }
}

-(void) inputLastName:(NSString *)lastName
{
    if (lastName == Nil) {
        last_name = @"";
    }else{
        last_name = lastName;
    }
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
-(void) inputContactPic: (UIImage *) picture
{
    contact_pic = picture;
}
-(void) inputPicAvail:(BOOL)avail
{
    pic_avail = avail;
}
/*~~~~~~~~~~~~~~Update Attributes Functions~~~~~~~~~~~~~~*/

-(void) updateDefaultEmail:(int) index
{
    email_index     = [NSNumber numberWithInt:index];
    default_email   = [email objectAtIndex:index];
}

-(void) updateDefaultPhone:(int) index
{
    default_phone_num = [phone_num objectAtIndex:index];
}

-(void) updatedefaultImessage:(int) index
{
    imessage_index = [NSNumber numberWithInt:index];
    if (index < [phone_num count]) {
        default_imessage = [phone_num objectAtIndex:index];
    }
    else{
        default_imessage = [email objectAtIndex:index - [phone_num count]];
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

-(UIImage*) displayPic
{
    return contact_pic;
}

-(int) displayEmailInd
{
    return [email_index intValue];
}

-(int) displayMsgInd
{
    return [imessage_index intValue];
}

-(BOOL) displayAvail
{
    return pic_avail;
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
