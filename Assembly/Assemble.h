//
//  Assemble.h
//  Assembly
//
//  Created by Evan Hsu on 3/21/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Assemble : UIViewController<ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *PeopleTable;

-(IBAction)readAddressBook:(id)sender;

@end
