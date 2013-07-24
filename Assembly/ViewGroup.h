//
//  ViewGroup.h
//  Assembly
//
//  Created by Evan Hsu on 3/23/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGroups.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewGroup : UIViewController<ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic) AllGroups *assembled_groups;
@property (nonatomic) int       index_selected;

@property (strong, nonatomic) IBOutlet UITableView      *GroupMembers;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavigationBar;
@property (strong, nonatomic) IBOutlet UIButton         *GroupImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *iMessage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *email;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *editButton;
@property (strong, nonatomic) IBOutlet UIImageView      *BackgroundIMG;

- (IBAction) sendMsg        :(id)sender;
- (IBAction) sendMail       :(id)sender;
- (IBAction) readAddressBook:(id)sender;

@end
