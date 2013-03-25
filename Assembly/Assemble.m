//
//  Assemble.m
//  Assembly
//
//  Created by Evan Hsu on 3/21/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "Assemble.h"
#import "PersonalInfo.h"
#import "GroupInfo.h"

@interface Assemble ()

@end

@implementation Assemble
{
    GroupInfo *tempGroupInfo;
    NSUInteger *index;
}

//Shared Variables
@synthesize assembled_groups;

//View Controller Objects
@synthesize PeopleTable;
@synthesize ColorSegment;
@synthesize GroupNameTextField;

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
    tempGroupInfo = [[GroupInfo alloc]init];
    PeopleTable.delegate = self;
    PeopleTable.dataSource = self;
    GroupNameTextField.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    NSLog(@"testing");
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
    }
    [super viewWillDisappear:animated];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"This is also the correct logic");
    if ([segue.identifier isEqualToString:@"BrowserAndAssemble"]) {
        NSLog(@"This is RIGHT!");
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)SaveButton:(id)sender
{
    //Saving the Group Name
    [tempGroupInfo updateGroupName:GroupNameTextField.text];
    
    //Saving Color ID information
    [tempGroupInfo updateColorID:[ColorSegment selectedSegmentIndex]];
    
    //Pusing Group object into assembled_groups array
    [assembled_groups pushGroup:tempGroupInfo];
    
    [[self navigationController]popViewControllerAnimated:YES];
}

/*~~~~~~~~~~~~~~Address Book Code~~~~~~~~~~~~~~~*/

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
    ABMutableMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMutableMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //Storing Personal Info
    [tempPersonal inputFirstName:first];
    [tempPersonal inputLastName:last];
    
    //Storing Email address

    for (int i = 0; i < ABMultiValueGetCount(email); i++) {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(email, i);
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
    if (ABMultiValueGetCount(email)) {
        [tempPersonal updateDefaultEmail:0];
    }
    if (ABMultiValueGetCount(phone) > 0) {
        [tempPersonal updateDefaultPhone:0]; //Sets default phone # to first phone #
        [tempPersonal updatedefaultImessage:NO at:0]; //Sets default iMessage to first Phone #
    }
    
    //Appending Personal Info to Group Info
    [tempGroupInfo pushInfo:tempPersonal];
    
    //*index = [assembled_groups count]; //saving index of GroupInfo in Groups Array
    //[assembled_groups pushGroup:tempGroupInfo];
    
    [PeopleTable reloadData];//Updating Table Contents
    NSLog(@"got to this point");
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    return NO;
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //AudioServicesPlaySystemSound(1104);
    /*
    NSLog(@"Index %@ selected", [history_queue index:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [myCalculator resultHistoryPress:[history_queue index:indexPath.row]];
    [self displayCurrent];
     */
    //grab indexPath of the array
}

/*~~~~~~~~~~~~~~~~TableView Code~~~~~~~~~~~~~~~~~~~*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [tempGroupInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    //here you check for PreCreated cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Fill the cells...
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tempGroupInfo PersonAt: indexPath.row] displayName]];
    NSLog(@"%@", [[tempGroupInfo PersonAt:indexPath.row] displayPhone]);
    
    //yourMutableArray is Array
    return cell;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = (NSUInteger)[indexPath row];
    NSUInteger count = [tempGroupInfo count];
    
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
    NSUInteger count = [tempGroupInfo count];
    
    if (row < count) {
        [tempGroupInfo deleteInfo:row];
    }
}

-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PeopleTable reloadData];
}

@end
