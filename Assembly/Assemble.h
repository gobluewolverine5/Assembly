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

@interface Assemble : UIViewController<ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) AllGroups *assembled_groups;

@property (strong, nonatomic) IBOutlet UITableView          *PeopleTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl   *ColorSegment;
@property (strong, nonatomic) IBOutlet UITextField          *GroupNameTextField;

- (IBAction)SaveButton:(id)sender;
- (IBAction)readAddressBook:(id)sender;

@end
