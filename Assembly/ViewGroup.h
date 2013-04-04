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

@interface ViewGroup : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic) AllGroups *assembled_groups;
@property (nonatomic) int index_selected;

@property (strong, nonatomic) IBOutlet UITableView *GroupMembers;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *GroupImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *iMessage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *email;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)sendMsg:(id)sender;
- (IBAction)sendMail:(id)sender;

@end
