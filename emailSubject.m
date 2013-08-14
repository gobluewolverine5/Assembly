//
//  emailSubject.m
//  Faction
//
//  Created by Evan Hsu on 8/13/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "emailSubject.h"

@interface emailSubject ()
@end

@implementation emailSubject
@synthesize _email_btn;
@synthesize _subject_field;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
