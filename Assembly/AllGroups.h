//
//  AllGroups.h
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupInfo.h"
#import "PersonalInfo.h"

@class GroupInfo;

@interface AllGroups : NSObject<NSCoding>
{
    NSMutableArray *Groups;
}

- (NSArray*)    allItems;
- (NSString*)   itemArchivePath;
- (BOOL)        saveChanges;

//Origin Functions
-(NSUInteger) count;

-(void) pushGroup:  (GroupInfo*) newGroup;
-(void) removeGroup:(NSUInteger) at;

-(void) updateGroupName:(NSString*) newName  at:(NSUInteger) index;
-(void) updateColorID:  (int) color          at:(NSUInteger) index;

-(GroupInfo*) objectAt: (NSUInteger) index;


//Encoding
-(void) encodeWithCoder:(NSCoder*) encoder;
-(id) initWithCoder:    (NSCoder*) decoder;


@end
