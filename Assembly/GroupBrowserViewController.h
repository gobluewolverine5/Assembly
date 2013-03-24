//
//  GroupBrowserViewController.h
//  Assembly
//
//  Created by Evan Hsu on 3/20/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGroups.h"

@interface GroupBrowserViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *GroupCollection;
@property (strong, nonatomic) IBOutlet UIToolbar *AssembleButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavigationBar;


@end
