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
-(void) inputFirstName: (NSString*) firstName;
-(void) inputLastName:  (NSString*) lastName;
-(void) inputEmail:     (NSString*) e_mail;
-(void) inputPhoneNum:  (NSString*) p_num;
-(void) inputContactPic:(UIImage*)  picture;
-(void) inputPicAvail:  (BOOL)      avail;

//Update Attributes Functions
-(void) updateDefaultEmail:     (int) index;
-(void) updateDefaultPhone:     (int) index;
-(void) updatedefaultImessage:  (int) index;

//Return Attributes Functions
-(NSString*)        displayName;
-(NSString*)        displayEmail;
-(NSString*)        displayPhone;
-(NSString*)        displayImessage;
-(NSString*)        displayFirst;
-(NSString*)        displayLast;
-(UIImage*)         displayPic;
-(int)              displayEmailInd;
-(int)              displayMsgInd;
-(BOOL)             displayAvail;
-(int)              emailCount;
-(int)              phoneCount;
-(NSMutableArray*)  emailArray;
-(NSMutableArray*)  phoneArray;

//File Saving
- (void) encodeWithCoder:(NSCoder*) encoder;
- (id) initWithCoder:    (NSCoder*) decoder;

@end
