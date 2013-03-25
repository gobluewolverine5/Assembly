//
//  GroupBrowserViewController.m
//  Assembly
//
//  Created by Evan Hsu on 3/20/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//


#import "GroupBrowserViewController.h"
#import "GroupCell.h"
#import "AllGroups.h"
#import "PersonalInfo.h"
#import "GroupInfo.h"
#import "Assemble.h"
#import "ViewGroup.h"

@interface GroupBrowserViewController ()

@end

@implementation GroupBrowserViewController{
    NSString *firstName;
    AllGroups *assembled_groups;
    ViewGroup *tempViewGroup;
}

@synthesize GroupCollection;
@synthesize NavigationBar;

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
    
    assembled_groups = [[AllGroups alloc] init];
    
    [[self GroupCollection] setDelegate:self];
    [[self GroupCollection] setDataSource:self];
    
    NavigationBar.title = [NSString stringWithFormat:@"%i Group(s)", [assembled_groups count]];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [GroupCollection reloadData];
     NavigationBar.title = [NSString stringWithFormat:@"%i Group(s)", [assembled_groups count]];
    if (assembled_groups.count > 0) {
        NSLog(@"%@", [[[assembled_groups objectAt:0]PersonAt:0]displayName]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BrowserAndAssemble"]) {
        Assemble *assembleVC = (Assemble*) segue.destinationViewController;
        assembleVC.assembled_groups = assembled_groups;
    }
    else if([segue.identifier isEqualToString:@"toViewGroup"]){
        NSLog(@"preparing for segue to 'toViewGroup'");
        NSIndexPath *tempIndex = (NSIndexPath*)sender;
        ViewGroup *view_groupVC = (ViewGroup*) segue.destinationViewController;
        
        //Passing data to next view controller
        view_groupVC.assembled_groups = assembled_groups;
        view_groupVC.index_selected = [tempIndex row];
    }
}

/*~~~~~~~~~~~~~Collection View Code~~~~~~~~~~~~~~*/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assembled_groups count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"Group";
    GroupCell *group_cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    [[group_cell GroupImage] setImage:[UIImage imageNamed:[[assembled_groups objectAt:indexPath.item] displayPicture]]];
    [[group_cell GroupName] setText:[[assembled_groups objectAt:indexPath.item] displayGroupName]];
    return group_cell;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collection view was selected! %i", [indexPath row]);
    [self performSegueWithIdentifier:@"toViewGroup" sender:indexPath];
}

@end















