//
//  Assemble.h
//  Assembly
//
//  Created by Evan Hsu on 3/21/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "AllGroups.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Assemble : UIViewController<ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet AllGroups *assembled_groups;
@property (strong, nonatomic) IBOutlet UITableView *PeopleTable;

-(IBAction)readAddressBook:(id)sender;

@end
