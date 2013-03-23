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

@interface GroupBrowserViewController ()

@end

@implementation GroupBrowserViewController{
    NSArray * image_array;
    NSArray * name_array;
    NSString *firstName;
    AllGroups *assembled_groups;
}

@synthesize testResult;
@synthesize GroupCollection;

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
    
	image_array = [[NSArray alloc] initWithObjects:@"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", nil];
    name_array = [[NSArray alloc] initWithObjects:@"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", nil];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [GroupCollection reloadData];
    if (assembled_groups.count > 0) {
        NSLog(@"%@", [[[assembled_groups objectAt:0]PersonAt:1]displayName]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"This is also the correct logic");
    if ([segue.identifier isEqualToString:@"BrowserAndAssemble"]) {
        NSLog(@"This is the correct logic");
        Assemble *assembleVC = (Assemble*) segue.destinationViewController;
        assembleVC.assembled_groups = assembled_groups;
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
    [[group_cell GroupImage] setImage:[UIImage imageNamed:[image_array objectAtIndex:indexPath.item]] ];
    [[group_cell GroupName] setText:[name_array objectAtIndex:indexPath.item]];
    return group_cell;
}


@end















