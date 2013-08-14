//
//  AddressBookAdd.h
//  Faction
//
//  Created by Evan Hsu on 8/11/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonalInfo.h"

@interface AddressBookAdd : NSObject

-(PersonalInfo*) addMember: (ABRecordRef) person;


@end
