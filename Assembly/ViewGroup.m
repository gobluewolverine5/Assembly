//
//  ViewGroup.m
//  Assembly
//
//  Created by Evan Hsu on 3/23/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "ViewGroup.h"
#import "PersonView.h"
#import "BackgroundColor.h"

@interface ViewGroup ()

@end

@implementation ViewGroup{
    int     person_index;
    bool    modified;
}

//Shared Variables
@synthesize assembled_groups;
@synthesize index_selected;

//View Controller Objects
@synthesize GroupMembers;
@synthesize NavigationBar;
@synthesize GroupImage;
@synthesize iMessage;
@synthesize email;
@synthesize editButton;
@synthesize BackgroundIMG;

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
    person_index                    = 0;
    modified                        = FALSE;
    BackgroundColor *bg_chooser     = [[BackgroundColor alloc] init];
    BackgroundIMG.image             = [bg_chooser BGchooser:[[assembled_groups objectAt:index_selected] displayColorID]];

    //Initializing Members Table
    GroupMembers.delegate           = self;
    GroupMembers.dataSource         = self;
    [GroupMembers reloadData];

    NavigationBar.title             = [[assembled_groups objectAt:index_selected] displayGroupName];
    
    [GroupImage setImage:[UIImage imageNamed:[[assembled_groups objectAt:index_selected]displayPicture]]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [GroupMembers reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if (modified) {
        [assembled_groups saveChanges];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPersonView"]) {
        PersonView *tempPersonViewVC        = (PersonView*) segue.destinationViewController;
        tempPersonViewVC.group_index        = index_selected;
        tempPersonViewVC.person_index       = person_index;
        tempPersonViewVC.assembled_groups   = assembled_groups;
    }
}

/*~~~~~~~~~~~~Address Book Code~~~~~~~~~~~~~~~~~*/
-(IBAction)readAddressBook:(id)sender
{
    ABPeoplePickerNavigationController *picker  = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate                 = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    PersonalInfo *tempPersonal = [[PersonalInfo alloc]init];
    
    NSString *first                 = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *last                  = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMutableMultiValueRef tempmail = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMutableMultiValueRef phone    = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //Storing Personal Info
    [tempPersonal inputFirstName    :first];
    [tempPersonal inputLastName     :last];
    CFRelease((__bridge CFTypeRef)(first));
    CFRelease((__bridge CFTypeRef)(last));
    
    if (ABPersonHasImageData(person)) {
        [tempPersonal inputPicAvail:TRUE];
        NSData *tempData = (__bridge NSData*)ABPersonCopyImageData(person);
        [tempPersonal inputContactPic:[UIImage imageWithData:tempData]];
        CFRelease((__bridge CFTypeRef)(tempData));
    }
    
    //Storing Email address
    for (int i = 0; i < ABMultiValueGetCount(tempmail); i++) {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(tempmail, i);
        [tempPersonal inputEmail:(__bridge NSString*) emailRef];
        CFRelease(emailRef);
    }
    
    //Storing Phone Number
    for (int i = 0; i < ABMultiValueGetCount(phone); i++) {
        CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(phone, i);
        [tempPersonal inputPhoneNum:(__bridge NSString*) phoneRef];
        CFRelease(phoneRef);
    }
    
    //Initializing default email, phone and iMessage addresses
    if (ABMultiValueGetCount(tempmail)) {
        [tempPersonal updateDefaultEmail    :0];
    }
    if (ABMultiValueGetCount(phone) > 0) {
        [tempPersonal updateDefaultPhone    :0];                            //Sets default phone # to first phone #
    }
    if (ABMultiValueGetCount(tempmail) || ABMultiValueGetCount(phone)) {
        [tempPersonal updatedefaultImessage :0];                            //Sets default iMessage to first Phone #
    }
    
    [[assembled_groups objectAt:index_selected ] pushInfo:tempPersonal];    //Appending Personal Info to Group Info
    
    [GroupMembers reloadData];                                              //Updating Table Contents
    modified = TRUE;
    CFRelease(tempmail);
    CFRelease(phone);
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    return NO;
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

/*~~~~~~~~~~~~Group Message Sending~~~~~~~~~~~~~*/

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message Failed");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message Sent");
            break;
        default:
            break;
    }
}

-(IBAction)sendMsg:(id)sender
{
    
    NSMutableArray *recipients = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        [recipients addObject:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayImessage]];
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        controller.recipients               = recipients;
        controller.messageComposeDelegate   = self;
        controller.body                     = @"Sent by Assembly for iPhone and iPad";
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)sendMail:(id)sender
{
    NSMutableArray *people = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        [people addObject:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayEmail]];
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate          = self;
        [mailViewController setSubject      :@""];
        [mailViewController setToRecipients :people];
        [mailViewController setMessageBody:@"Sent by Assembly for iPhone and iPad" isHTML:NO];
        
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
    else{
        NSLog(@"Could not open email");
    }
}

/*~~~~~~~~~~~~TableView Code~~~~~~~~~~~~~~*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    person_index = indexPath.row;
    [self performSegueWithIdentifier:@"toPersonView" sender:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Group Members Count: %i", [[[assembled_groups objectAt:index_selected] returnGroupMembersInfo] count]);
    return [[[assembled_groups objectAt:index_selected] returnGroupMembersInfo] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier     = @"Cell";
    UITableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //Assigning contact name to table cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[assembled_groups objectAt:index_selected] PersonAt: indexPath.row] displayName]];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    //Assigning contact image to table cell
    [[cell imageView] setImage:[[[assembled_groups objectAt:index_selected] PersonAt:indexPath.row] displayPic]];

    return cell;
}

//Editing Table
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row      = (NSUInteger)[indexPath row];
    NSUInteger count    = [[assembled_groups objectAt:index_selected] count];
    
    if (row < count)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
    
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row      = (NSUInteger)[indexPath row];
    NSUInteger count    = [[assembled_groups objectAt:index_selected] count];
    
    if (row < count) {
        [[assembled_groups objectAt:index_selected] deleteInfo:row];
        modified = TRUE;
    }
}

-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [GroupMembers reloadData];
}

@end
