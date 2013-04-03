//
//  PersonalInfo.h
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfo : NSObject<NSCoding>

//Input Attributes Functions
-(void) inputFirstName:(NSString*) firstName;
-(void) inputLastName:(NSString*) lastName;
-(void) inputEmail:(NSString*) e_mail;
-(void) inputPhoneNum:(NSString*) p_num;

//Update Attributes Functions
-(void) updateDefaultEmail:(int) index;
-(void) updateDefaultPhone:(int) index;
-(void) updatedefaultImessage:(bool) mail at:(int) index;

//Return Attributes Functions
-(NSString*) displayName;
-(NSString*) displayEmail;
-(NSString*) displayPhone;
-(NSString*) displayImessage;
-(NSString*) displayFirst;
-(NSString*) displayLast;
-(int) emailCount;
-(int) phoneCount;
-(NSMutableArray*) emailArray;
-(NSMutableArray*) phoneArray;

//File Saving
- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)decoder;

@end
