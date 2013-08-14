//
//  AddressBookAdd.m
//  Faction
//
//  Created by Evan Hsu on 8/11/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "AddressBookAdd.h"

@implementation AddressBookAdd

-(id) init
{
    if(self = [super init]){}
	return self;
}

-(PersonalInfo*) addMember: (ABRecordRef) person
{
    NSLog(@"Done Picking Person");
    
    PersonalInfo *tempPersonal = [[PersonalInfo alloc]init];
    NSString *first                 = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *last                  = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMutableMultiValueRef email    = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMutableMultiValueRef phone    = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //Storing Personal Info
    [tempPersonal inputFirstName    :first];
    [tempPersonal inputLastName     :last];
    if (first != Nil)   CFRelease((__bridge CFTypeRef)(first));
    if (last != Nil)    CFRelease((__bridge CFTypeRef)(last));
    
    if (ABPersonHasImageData(person)) {
        [tempPersonal inputPicAvail     :TRUE];
        NSData *tempData = (__bridge NSData*)ABPersonCopyImageData(person);
        [tempPersonal inputContactPic : [UIImage imageWithData:tempData]];
        CFRelease((__bridge CFTypeRef)(tempData));
    }
    
    //Storing Email address
    for (int i = 0; i < ABMultiValueGetCount(email); i++) {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(email, i);
        CFStringRef label    = ABMultiValueCopyLabelAtIndex(email, i);
        [tempPersonal inputEmail : (__bridge NSString*) emailRef];
        [tempPersonal inputEmailLabel: (__bridge NSString*) ABAddressBookCopyLocalizedLabel(label)];
        CFRelease(emailRef);
    }
    
    //Storing Phone Number
    for (int i = 0; i < ABMultiValueGetCount(phone); i++) {
        CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(phone, i);
        CFStringRef label    = ABMultiValueCopyLabelAtIndex(phone, i);
        [tempPersonal inputPhoneNum : (__bridge NSString*) phoneRef];
        [tempPersonal inputPhoneLabel: (__bridge NSString*) ABAddressBookCopyLocalizedLabel(label)];
        CFRelease(phoneRef);
        CFRelease(label);
    }
    
    
    //Initializing default email, phone and iMessage addresses
    if (ABMultiValueGetCount(email)) {
        [tempPersonal updateDefaultEmail:0];
    }
    if (ABMultiValueGetCount(phone) > 0) {
        [tempPersonal updateDefaultPhone    :0];        //Sets default phone # to first phone #
    }
    if (ABMultiValueGetCount(email) || ABMultiValueGetCount(phone)) {
        [tempPersonal updatedefaultImessage :0];        //Sets default iMessage to first Phone #
    }
    CFRelease(phone);
    CFRelease(email);
    return tempPersonal;
}

@end
