//
//  GroupBrowserViewController.m
//  Assembly
//
//  Created by Evan Hsu on 3/20/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//


#import "GroupBrowserViewController.h"
#import "GroupCell.h"
@interface GroupBrowserViewController ()

@end

@implementation GroupBrowserViewController{
    NSArray * image_array;
    NSArray * name_array;
    NSString *firstName;
}

@synthesize testResult;

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
    [[self GroupCollection] setDelegate:self];
    [[self GroupCollection] setDataSource:self];
    
	image_array = [[NSArray alloc] initWithObjects:@"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", @"images.jpeg", nil];
    name_array = [[NSArray alloc] initWithObjects:@"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", @"first", @"second", @"third", @"fourth", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*~~~~~~~~~~~~~Collection View Code~~~~~~~~~~~~~~*/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [image_array count];
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















