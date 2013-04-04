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
}

-(void) viewWillAppear:(BOOL)animated
{
    [GroupMembers reloadData];
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


/*~~~~~~~~~~~~Group Message Sending~~~~~~~~~~~~~*/

-(IBAction)sendMsg:(id)sender
{
    /*
    NSString *addresses = @"";
    NSLog(@"%@", addresses);
    
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        addresses = [addresses stringByAppendingString:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayImessage]];
        NSLog(@"in the loop: %@", addresses);
        addresses = [addresses stringByAppendingString:@";"];
        NSLog(@"I'm in the loop!");
    }
    //addresses = [addresses stringByAppendingString:[[[assembled_groups objectAt:index_selected] PersonAt:0] displayImessage]];
    
    NSLog(@"FIRST IMSG: %@", [[[assembled_groups objectAt:index_selected] PersonAt:0] displayImessage]);
    NSLog(@"ADDRESSES: %@", addresses);
    
    NSString *stringURL = [NSString stringWithFormat: @"sms:%@", addresses];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
     */
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(IBAction)sendMail:(id)sender
{
    /*
    NSString *addresses = @"";
    for (int i = 0; i < [[assembled_groups objectAt:index_selected] count]; i++) {
        addresses = [addresses stringByAppendingString:[[[assembled_groups objectAt:index_selected] PersonAt:i] displayEmail]];
        addresses = [addresses stringByAppendingString:@"; "];
    }
    
    NSLog(@"ADDRESSES %@", addresses);
    
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", addresses];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
     */
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
    
    //Fill the cells...
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",
                           [[[assembled_groups objectAt:index_selected]
                                                PersonAt: indexPath.row] displayName]];
    
    //yourMutableArray is Array
    return cell;
}

@end
