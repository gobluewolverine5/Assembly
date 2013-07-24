//
//  ChangeGroup.m
//  Assembly
//
//  Created by Evan Hsu on 7/14/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "ChangeGroup.h"
#import "PersonalInfo.h"
#import "GroupInfo.h"

@interface ChangeGroup ()

@end

@implementation ChangeGroup{
    GroupInfo   *tempGroupInfo;
}

@synthesize assembled_groups;
@synthesize group_index;

//View Controller Objects
@synthesize PeopleTable;
@synthesize ColorSegment;
@synthesize GroupNameTextField;

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

    tempGroupInfo               = [assembled_groups objectAt:group_index];
    PeopleTable.delegate        = self;
    PeopleTable.dataSource      = self;
    GroupNameTextField.delegate = self;
    
    GroupNameTextField.text             = [tempGroupInfo displayGroupName];
    ColorSegment.selectedSegmentIndex   = [tempGroupInfo displayColorID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BrowserAndAssemble"]) {
        NSLog(@"This is RIGHT!");
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*~~~~~~~~~~~~File Saving~~~~~~~~~~~~~~~*/
- (void)saveCustomObject:(AllGroups *)obj {
    NSLog(@"saved custom object");
    NSData *myEncodedObject     = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:@"myEncodedObjectKey"];
}

- (AllGroups *)loadCustomObjectWithKey:(NSString *)key {
    NSLog(@"load custom object");
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject     = [defaults objectForKey:key];
    AllGroups *obj              = (AllGroups *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

-(IBAction)SaveButton:(id)sender
{
    //No Group Name has been entered
    if ([GroupNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle     :@"Warning!"
                              message           :@"Invaild Group Name"
                              delegate          :nil
                              cancelButtonTitle :@"OK"
                              otherButtonTitles :nil];
        [alert show];
    }else{
        [tempGroupInfo      updateGroupName     :GroupNameTextField.text];              //Saving the Group Name
        [tempGroupInfo      updateColorID       :[ColorSegment selectedSegmentIndex]];  //Saving Color ID information
        
        if(![assembled_groups saveChanges]) NSLog(@"Saving Failed!");
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

/*~~~~~~~~~~~~~~Address Book Code~~~~~~~~~~~~~~~*/

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
    NSLog(@"Done Picking Person");
    PersonalInfo *tempPersonal = [[PersonalInfo alloc]init];
    
    NSString *first                 = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *last                  = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMutableMultiValueRef email    = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMutableMultiValueRef phone    = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //Storing Personal Info
    [tempPersonal inputFirstName    :first];
    [tempPersonal inputLastName     :last];
    if (first != Nil)   CFRelease((__bridge CFTypeRef)(first));
    if (last != Nil)    CFRelease((__bridge CFTypeRef)(last));
    
    if (ABPersonHasImageData(person)) {
        [tempPersonal inputPicAvail     :TRUE];
        NSData *tempData = (__bridge NSData*)ABPersonCopyImageData(person);
        [tempPersonal inputContactPic : [UIImage imageWithData:tempData]];
        CFRelease((__bridge CFTypeRef)(tempData));
    }
    
    //Storing Email address
    for (int i = 0; i < ABMultiValueGetCount(email); i++) {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(email, i);
        [tempPersonal inputEmail : (__bridge NSString*) emailRef];
        CFRelease(emailRef);
    }
    
    //Storing Phone Number
    for (int i = 0; i < ABMultiValueGetCount(phone); i++) {
        CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(phone, i);
        [tempPersonal inputPhoneNum : (__bridge NSString*) phoneRef];
        CFRelease(phoneRef);
    }
    
    //Initializing default email, phone and iMessage addresses
    if (ABMultiValueGetCount(email)) {
        [tempPersonal updateDefaultEmail:0];
    }
    if (ABMultiValueGetCount(phone) > 0) {
        [tempPersonal updateDefaultPhone    :0];        //Sets default phone # to first phone #
    }
    if (ABMultiValueGetCount(email) || ABMultiValueGetCount(phone)) {
        [tempPersonal updatedefaultImessage :0];        //Sets default iMessage to first Phone #
    }
    
    [tempGroupInfo pushInfo:tempPersonal];              //Appending Personal Info to Group Info
    [PeopleTable reloadData];                           //Updating Table Contents
    CFRelease(phone);
    CFRelease(email);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    return NO;
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
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
    
    static NSString *CellIdentifier     = @"Cell";
    UITableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle   :UITableViewCellStyleDefault
                reuseIdentifier :CellIdentifier];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tempGroupInfo PersonAt: indexPath.row] displayName]];
    [[cell imageView] setImage:[[tempGroupInfo PersonAt: indexPath.row]displayPic]];
    
    //yourMutableArray is Array
    return cell;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row      = (NSUInteger)[indexPath row];
    NSUInteger count    = [tempGroupInfo count];
    
    if (row < count)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row      = (NSUInteger)[indexPath row];
    NSUInteger count    = [tempGroupInfo count];
    
    if (row < count) [tempGroupInfo deleteInfo:row];
}

-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PeopleTable reloadData];
}

@end
