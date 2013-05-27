//
//  ViewGroup.m
//  Assembly
//
//  Created by Evan Hsu on 3/23/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "ViewGroup.h"
#import "PersonView.h"

@interface ViewGroup ()

@end

@implementation ViewGroup{
    int person_index;
    bool modified;
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

    //Initializing Members Table
    GroupMembers.delegate = self;
    GroupMembers.dataSource = self;
    [GroupMembers reloadData];

    NavigationBar.title = [[assembled_groups objectAt:index_selected] displayGroupName];
    
    [GroupImage setImage:[UIImage imageNamed:[[assembled_groups objectAt:index_selected]displayPicture]]];
    
    person_index = 0;
    modified = FALSE;
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
        PersonView *tempPersonViewVC = (PersonView*) segue.destinationViewController;
        tempPersonViewVC.group_index = index_selected;
        tempPersonViewVC.person_index = person_index;
        tempPersonViewVC.assembled_groups = assembled_groups;
    }
}

/*~~~~~~~~~~~~Address Book Code~~~~~~~~~~~~~~~~~*/
-(IBAction)readAddressBook:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"Done Picking Person");
    PersonalInfo *tempPersonal = [[PersonalInfo alloc]init];
    
    NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *last = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMutableMultiValueRef tempmail = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMutableMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //Storing Personal Info
    [tempPersonal inputFirstName:first];
    [tempPersonal inputLastName:last];
    
    if (ABPersonHasImageData(person)) {
        [tempPersonal inputPicAvail:TRUE];
        [tempPersonal inputContactPic:[UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)]];
        //[tempPersonal inputContactPic:(__bridge UIImage *)(picture)];
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
        [tempPersonal updateDefaultEmail:0];
    }
    if (ABMultiValueGetCount(phone) > 0) {
        [tempPersonal updateDefaultPhone:0]; //Sets default phone # to first phone #
        [tempPersonal updatedefaultImessage:NO at:0]; //Sets default iMessage to first Phone #
    }
    
    //Appending Personal Info to Group Info
    [[assembled_groups objectAt:index_selected ] pushInfo:tempPersonal];
    
    //*index = [assembled_groups count]; //saving index of GroupInfo in Groups Array
    //[assembled_groups pushGroup:tempGroupInfo];
    
    [GroupMembers reloadData];//Updating Table Contents
    NSLog(@"got to this point");
    modified = TRUE;
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
}

-(IBAction)sendMsg:(id)sender
{
    
    NSMutableArray *recipients = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        [recipients addObject:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayImessage]];
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        //controller.body = @"This is a test sent by Assembly";
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        
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
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@""];
        [mailViewController setToRecipients:people];
        
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
    
    static NSString *CellIdentifier = @"Cell";
    //here you check for PreCreated cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /*Fill the cells...*/
    //Assigning contact name to table cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@",
                           [[[assembled_groups objectAt:index_selected]
                                                PersonAt: indexPath.row] displayName]];
    //Assigning contact image to table cell
    [[cell imageView] setImage:[[[assembled_groups objectAt:index_selected] PersonAt:indexPath.row] displayPic]];
    
    //yourMutableArray is Array
    return cell;
}

//Editing Table
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = (NSUInteger)[indexPath row];
    NSUInteger count = [[assembled_groups objectAt:index_selected] count];
    
    if (row < count) {
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
    
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = (NSUInteger)[indexPath row];
    NSUInteger count = [[assembled_groups objectAt:index_selected] count];
    
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
