//
//  emailSubject.m
//  Faction
//
//  Created by Evan Hsu on 8/13/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "emailSubject.h"
#import "ViewGroup.h"
#import "PersonView.h"

@interface emailSubject (){
    NSData *image_data;
}

@end

@implementation emailSubject
@synthesize _email_btn;
@synthesize _subject_field;
@synthesize _preview;

@synthesize assembled_groups;
@synthesize index_selected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _subject_field.delegate = self;
    [_subject_field becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSMutableArray *people = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        [people addObject:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayEmail]];
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate          = self;
        [mailViewController setSubject      :_subject_field.text];
        [mailViewController setToRecipients :people];
        [mailViewController setMessageBody:@"Created by Faction iOS\n------------\n" isHTML:NO];
        
        if (image_data) {
            [mailViewController addAttachmentData:image_data  mimeType:@"image/png" fileName:@"attached_image"];
        }
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
    else{
        NSLog(@"Could not open email");
    }
    return YES;
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)attachFile:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:NULL];

}

- (IBAction)takePic:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
    }else {
        //Put error code here
        NSLog(@"No camera found on device");
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image_data = UIImagePNGRepresentation(image);
    
    [_preview setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
