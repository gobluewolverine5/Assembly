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
    BOOL editing;
}

@synthesize GroupCollection;
@synthesize NavigationBar;
@synthesize EditGroups;

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
    NSLog(@"loaded the browser");
    
    GroupCollection.backgroundColor = [UIColor clearColor];
    
    [[self GroupCollection] setDelegate:self];
    [[self GroupCollection] setDataSource:self];
    
    NavigationBar.title = [NSString stringWithFormat:@"%i Group(s)", [assembled_groups count]];
    
    editing = false;
    
    [GroupCollection reloadData];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    
    assembled_groups = [[AllGroups alloc] init];
    //NSLog(@"INSIDE ASSEMBLED GROUPS: %@", [[assembled_groups objectAt:0] displayGroupName]);
   
    [GroupCollection reloadData];//refreshing collection view
    
     NavigationBar.title = [NSString stringWithFormat:@"%i Group(s)", [assembled_groups count]];
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

-(IBAction)editGroups:(id)sender
{
    if (editing){
       editing = false; 
    }
    else{
       editing = true; 
    }
    [GroupCollection reloadData];
}

/*~~~~~~~~~~~~File Saving~~~~~~~~~~~~~~~*/
- (void)saveCustomObject:(AllGroups *)obj {
    NSLog(@"saved custom object");
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:@"myEncodedObjectKey"];
}

- (AllGroups *)loadCustomObjectWithKey:(NSString *)key {
    NSLog(@"loaded custom object");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    AllGroups *obj = (AllGroups *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
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
    collectionView.backgroundColor = [UIColor clearColor];
    GroupCell *group_cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    
    [[group_cell GroupImage] setImage:[UIImage imageNamed:[[assembled_groups objectAt:indexPath.item] displayPicture]]];
    [[group_cell GroupName] setText:[[assembled_groups objectAt:indexPath.item] displayGroupName]];
    if (editing) {
        [[group_cell _delete_sign] setAlpha:1];
    }
    else{
        [[group_cell _delete_sign]setAlpha:0];
    }

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
    if (editing) {

        [assembled_groups removeGroup:indexPath.row];
        [assembled_groups saveChanges];
        [GroupCollection reloadData];
        NavigationBar.title = [NSString stringWithFormat:@"%i Group(s)", [assembled_groups count]];
        if ([assembled_groups count] == 0) {
            editing = false;
        }
    }
    else{
        [self performSegueWithIdentifier:@"toViewGroup" sender:indexPath];
    }
    
}

@end















