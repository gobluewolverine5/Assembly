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

@interface emailSubject : UIViewController<MFMailComposeViewControllerDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic) AllGroups *assembled_groups;
@property (nonatomic) int       index_selected;

@property (strong, nonatomic) IBOutlet UITextField *_subject_field;
@property (strong, nonatomic) IBOutlet UIButton *_email_btn;
@property (strong, nonatomic) IBOutlet UIButton *_attach_btn;
@property (strong, nonatomic) IBOutlet UIButton *_take_btn;
@property (strong, nonatomic) IBOutlet UIImageView *_preview;

- (IBAction)attachFile:(id)sender;
- (IBAction)takePic:(id)sender;

@end
