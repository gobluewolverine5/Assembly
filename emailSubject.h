//
//  emailSubject.h
//  Faction
//
//  Created by Evan Hsu on 8/13/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGroups.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface emailSubject : UIViewController<MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic) AllGroups *assembled_groups;
@property (nonatomic) int       index_selected;

@property (strong, nonatomic) IBOutlet UITextField              *_subject_field;
@property (strong, nonatomic) IBOutlet UIBarButtonItem          *_attach_bar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView  *_indicator;

@property (nonatomic, retain) IBOutlet UIPopoverController      *poc;
@property (strong, nonatomic) IBOutlet UIToolbar *secbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *_status;

- (IBAction)attachFile:(id)sender;
- (IBAction)takePic:(id)sender;
- (IBAction)compose:(id)sender;

@end
