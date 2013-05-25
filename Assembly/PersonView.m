//
//  PersonView.m
//  Assembly
//
//  Created by Evan Hsu on 3/24/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "PersonView.h"

@interface PersonView ()

@end

@implementation PersonView

//Shared Variables
@synthesize assembled_groups;
@synthesize group_index;
@synthesize person_index;

//View Controller Objects
@synthesize PersonImage;
@synthesize FirstName;
@synthesize LastName;
@synthesize iMessageAddr;
@synthesize iMessageTable;
@synthesize emailAddr;
@synthesize emailTable;

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
    iMessageTable.delegate = self;
    iMessageTable.dataSource = self;
    
    [iMessageTable reloadData];
    
    emailTable.delegate = self;
    emailTable.dataSource = self;
    [emailTable reloadData];
    
    iMessageAddr.numberOfLines = 1;
    iMessageAddr.adjustsFontSizeToFitWidth = YES;
    iMessageAddr.adjustsLetterSpacingToFitWidth = YES;
    [iMessageAddr setText:[[[assembled_groups objectAt:group_index] PersonAt:person_index] displayImessage]];
    
    emailAddr.numberOfLines = 1;
    emailAddr.adjustsFontSizeToFitWidth = YES;
    emailAddr.adjustsLetterSpacingToFitWidth = YES;
    [emailAddr setText:[[[assembled_groups objectAt:group_index] PersonAt:person_index] displayEmail]];
    
    FirstName.numberOfLines = 1;
    FirstName.adjustsFontSizeToFitWidth = YES;
    FirstName.adjustsLetterSpacingToFitWidth = YES;
    FirstName.text = [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayFirst];
    
    LastName.numberOfLines = 1;
    LastName.adjustsFontSizeToFitWidth = YES;
    LastName.adjustsLetterSpacingToFitWidth = YES;
    LastName.text = [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayLast];
    
    if ([[[assembled_groups objectAt:group_index] PersonAt:person_index] displayAvail]) {
        PersonImage.image = [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayPic];
    }else{
        PersonImage.image = [UIImage imageNamed:[[assembled_groups objectAt:group_index] displayPicture]];
    }

    NSLog(@"person_index: %i", person_index);
    NSLog(@"group_index: %i", person_index);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*~~~~~~~~~~~~~~~~TableView Code~~~~~~~~~~~~~~~~~~~*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == iMessageTable){
        int myIndex = indexPath.row;
        if (indexPath.row < [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount]) {
            
            //updating default iMessage address
            [[[assembled_groups objectAt:group_index]
                                PersonAt:person_index] updatedefaultImessage:NO at:myIndex];
        }
        else{
            //Converting index for email array access
            myIndex = indexPath.row - [[[assembled_groups objectAt:group_index]
                                        PersonAt:person_index] phoneCount];
            
            //updating default iMessage address
            [[[assembled_groups objectAt:group_index]
                                PersonAt:person_index] updatedefaultImessage:YES at:myIndex];
        }
        //updating iMessage address display
        [iMessageAddr setText:[[[assembled_groups objectAt:group_index]
                                PersonAt:person_index] displayImessage]];
        
    }
    else if(tableView == emailTable){
        //Updating default email address
        [[[assembled_groups objectAt:group_index]
                            PersonAt:person_index] updateDefaultEmail:indexPath.row];
        
        //updating email address display
        [emailAddr setText:[[[assembled_groups objectAt:group_index]
                                PersonAt:person_index] displayEmail]];
        
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (table == iMessageTable) {
        return [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount] +
        [[[assembled_groups objectAt:group_index] PersonAt:person_index] emailCount];
    }
    else if (table == emailTable){
        return [[[assembled_groups objectAt:group_index] PersonAt:person_index] emailCount];
    }
    else{
        NSLog(@"returned size 0");
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    //here you check for PreCreated cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    if (tableView == iMessageTable) {
        
        //Fill the cells...
        if (indexPath.row < [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount]) {
            int myIndex = indexPath.row;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                      PersonAt:person_index] phoneArray]
                                                                    objectAtIndex:myIndex]];
        }
        else{
            int myIndex = indexPath.row - [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                      PersonAt:person_index] emailArray]
                                                                    objectAtIndex:myIndex]];
        }
    }
    else if (tableView == emailTable){
        
        //Fill the cells...
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                  PersonAt:person_index] emailArray]
                                                                objectAtIndex:indexPath.row]];
    }
    return cell;
}


@end
