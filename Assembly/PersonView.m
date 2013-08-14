//
//  PersonView.m
//  Assembly
//
//  Created by Evan Hsu on 3/24/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "PersonView.h"
#import "BackgroundColor.h"

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
    BackgroundColor *bg_chooser                 = [[BackgroundColor alloc] init];
    BackgroundIMG.image                         = [bg_chooser BGchooser:[[assembled_groups objectAt:group_index] displayColorID]];
    
    iMessageTable.delegate                      = self;
    iMessageTable.dataSource                    = self;
    [iMessageTable reloadData];
    
    emailTable.delegate                         = self;
    emailTable.dataSource                       = self;
    [emailTable reloadData];

    iMessageAddr.numberOfLines                  = 1;
    iMessageAddr.adjustsFontSizeToFitWidth      = YES;
    iMessageAddr.adjustsLetterSpacingToFitWidth = YES;
    emailAddr.numberOfLines                     = 1;
    emailAddr.adjustsFontSizeToFitWidth         = YES;
    emailAddr.adjustsLetterSpacingToFitWidth    = YES;
    FirstName.numberOfLines                     = 1;
    FirstName.adjustsFontSizeToFitWidth         = YES;
    FirstName.adjustsLetterSpacingToFitWidth    = YES;
    LastName.numberOfLines                      = 1;
    LastName.adjustsFontSizeToFitWidth          = YES;
    LastName.adjustsLetterSpacingToFitWidth     = YES;
    
    [iMessageAddr setText:  [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayImessage]];
    [emailAddr setText:     [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayEmail]];
    [FirstName setText:     [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayFirst]];
    [LastName setText:      [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayLast]];
    
    if ([[[assembled_groups objectAt:group_index] PersonAt:person_index] displayAvail]) {
        PersonImage.image = [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayPic];
    }else{
        PersonImage.image = [UIImage imageNamed:[[assembled_groups objectAt:group_index] displayPicture]];
    }
    
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
        
        [[[assembled_groups objectAt:group_index] PersonAt:person_index] updatedefaultImessage:indexPath.row];      //updating default iMessage address
        [iMessageAddr setText:[[[assembled_groups objectAt:group_index] PersonAt:person_index] displayImessage]];   //updating iMessage address display
        [iMessageTable reloadData];
    }
    else if(tableView == emailTable){
        
        [[[assembled_groups objectAt:group_index] PersonAt:person_index] updateDefaultEmail:indexPath.row];         //Updating default email address
        [emailAddr setText:[[[assembled_groups objectAt:group_index] PersonAt:person_index] displayEmail]];         //updating email address display
        [emailTable reloadData];                                                                                    //Saving Changes
    }
    [assembled_groups saveChanges];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (table == iMessageTable) {
        return [[[assembled_groups  objectAt:group_index] PersonAt:person_index] phoneCount] +
                [[[assembled_groups objectAt:group_index] PersonAt:person_index] emailCount];
    }
    else if (table == emailTable){
        return [[[assembled_groups  objectAt:group_index] PersonAt:person_index] emailCount];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.numberOfLines                    = 1;
    cell.textLabel.adjustsLetterSpacingToFitWidth   = YES;
    cell.textLabel.adjustsFontSizeToFitWidth        = YES;
    
    if (tableView == iMessageTable) {
        
        if(indexPath.row == [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayMsgInd]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = normal;
        }
        cell.textLabel.backgroundColor      = [UIColor clearColor];
        
        if (indexPath.row < [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount]) {
            int myIndex = indexPath.row;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                                        PersonAt:person_index] phoneArray]
                                                                                        objectAtIndex:myIndex]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[[[assembled_groups    objectAt:group_index]
                                                                PersonAt:person_index] phoneLabel]
                                                                objectAtIndex:myIndex] ];
        }
        else{
            int myIndex = indexPath.row - [[[assembled_groups objectAt:group_index] PersonAt:person_index] phoneCount];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                                        PersonAt:person_index] emailArray]
                                                                                        objectAtIndex:myIndex]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                            PersonAt:person_index] emailLabel]
                                                                          objectAtIndex:myIndex]];
        }
    }
    else if (tableView == emailTable){
        
        if(indexPath.row == [[[assembled_groups objectAt:group_index] PersonAt:person_index] displayEmailInd]){
            cell.accessoryType                  = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType                  = normal;
        }
        cell.textLabel.backgroundColor      = [UIColor clearColor];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                                    PersonAt:person_index] emailArray]
                                                                                    objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[[[assembled_groups objectAt:group_index]
                                                                        PersonAt:person_index] emailLabel]
                                                                      objectAtIndex:indexPath.row]];
    }
    return cell;
}


@end
