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
    UIImage *image;
}

@end

@implementation emailSubject

//Objects
@synthesize _subject_field;
@synthesize _indicator;
@synthesize _attach_bar;
@synthesize _status;

//Passed in variables
@synthesize assembled_groups;
@synthesize index_selected;

@synthesize poc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _subject_field.delegate     = self;
    [_subject_field becomeFirstResponder];
    _subject_field.frame = CGRectMake(_subject_field.frame.origin.x, _subject_field.frame.origin.y, _subject_field.frame.size.width, 44);
    
    _indicator.hidesWhenStopped = YES;
    [_indicator stopAnimating];
    
     _status.tintColor = [UIColor redColor];
}
- (void) viewWillDisappear:(BOOL)animated
{
    if ([poc isPopoverVisible]) [poc dismissPopoverAnimated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([poc isPopoverVisible]) [poc dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
        [textField resignFirstResponder];
        [self prepareEmail];
        return YES;
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    if ([poc isPopoverVisible]) [poc dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)prepareEmail
{
    if(![_indicator isAnimating]){
        [_indicator startAnimating];
        NSLog(@"starting to animate");
    }
    
    NSMutableArray *people = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        NSString *email_addr = [[[assembled_groups objectAt:index_selected] PersonAt:i] displayEmail];
        if (![email_addr isEqual: @"N/A"]) {
            [people addObject:email_addr];
        }
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate          = self;
        [mailViewController setToRecipients :people];
        [mailViewController setMessageBody:@"Created by Faction iOS\n------------\n" isHTML:NO];
        [mailViewController setSubject      :_subject_field.text];
            
        if (image) {
            NSData *image_data = UIImageJPEGRepresentation(image, 1);
            [mailViewController addAttachmentData:image_data  mimeType:@"image/jpeg" fileName:@"attached_image"];
            
        }
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
    else {
        NSLog(@"Could not open email");
    }
    [_indicator stopAnimating];

}

- (IBAction)attachFile:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
    }else if(![poc isPopoverVisible]){
        
        self.poc = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        [poc presentPopoverFromBarButtonItem:_attach_bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
}

- (IBAction)takePic:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:NULL];
        //_status.tintColor = [UIColor greenColor];

        
    }else {
        NSLog(@"No camera found on device");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle     :@"Warning"
                              message           :@"Camera not found on device!"
                              delegate          :nil
                              cancelButtonTitle :@"OK"
                              otherButtonTitles :nil];
        [alert show];
    }
}

- (IBAction)compose:(id)sender {
    [self prepareEmail];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    if ([poc isPopoverVisible]) [poc dismissPopoverAnimated:YES];
    
    image               = [info objectForKey:UIImagePickerControllerOriginalImage];
    _status.tintColor   = [UIColor greenColor];
    

}

@end
