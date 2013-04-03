//
//  GroupCell.h
//  Assembly
//
//  Created by Evan Hsu on 3/20/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *GroupImage;
@property (strong, nonatomic) IBOutlet UILabel *GroupName;
@property (strong, nonatomic) IBOutlet UIButton *del;

@end
