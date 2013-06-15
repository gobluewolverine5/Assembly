//
//  PersonView.h
//  Assembly
//
//  Created by Evan Hsu on 3/24/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGroups.h"

@interface PersonView : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) AllGroups *assembled_groups;
@property (nonatomic) int       group_index;
@property (nonatomic) int       person_index;

@property (strong, nonatomic) IBOutlet UIImageView  *PersonImage;
@property (strong, nonatomic) IBOutlet UILabel      *FirstName;
@property (strong, nonatomic) IBOutlet UILabel      *LastName;
@property (strong, nonatomic) IBOutlet UILabel      *iMessageAddr;
@property (strong, nonatomic) IBOutlet UITableView  *iMessageTable;
@property (strong, nonatomic) IBOutlet UILabel      *emailAddr;
@property (strong, nonatomic) IBOutlet UITableView  *emailTable;
@property (strong, nonatomic) IBOutlet UIImageView  *BackgroundIMG;


@end
