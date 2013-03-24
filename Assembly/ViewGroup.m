//
//  ViewGroup.m
//  Assembly
//
//  Created by Evan Hsu on 3/23/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "ViewGroup.h"

@interface ViewGroup ()

@end

@implementation ViewGroup

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


/*~~~~~~~~~~~~TableView Code~~~~~~~~~~~~~~*/
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
