//
//  AllGroups.m
//  Assembly
//
//  Created by Evan Hsu on 3/22/13.
//  Copyright (c) 2013 Evan Hsu. All rights reserved.
//

#import "AllGroups.h"
#import "PersonalInfo.h"
#import "GroupInfo.h"

@implementation AllGroups

-(id) init
{
    if(self = [super init]){
        NSString *path = [self itemArchivePath];
        Groups = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if(!Groups)
            Groups = [[NSMutableArray alloc] init];
    }
	return self;
}

/*~~~~~~~~~~File Saving~~~~~~~~~~~*/

-(void) encodeWithCoder:(NSCoder*) encoder
{
    [encoder encodeObject:Groups forKey:@"Groups"];
}

-(id) initWithCoder:(NSCoder*) decoder
{
    if ((self = [super init])) {
        Groups = [decoder decodeObjectForKey:@"Groups"];
    }
    return self;
}

/*
+ (AllGroups*) sharedStore
{
    static GroupInfo *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
*/
 
- (NSArray *)allItems
{
    return Groups;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    // returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:Groups
                                       toFile:path];
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-(NSUInteger) count
{
    return [Groups count];
}

-(void) pushGroup:(GroupInfo *)newGroup
{
    [Groups addObject:newGroup];
}

-(void) removeGroup:(NSUInteger)at
{
    [Groups removeObjectAtIndex:at];
}

-(void) updateGroupName:(NSString *)newName at:(NSUInteger)index
{
    GroupInfo *tempGroupInfo = [[GroupInfo alloc]init];
    [tempGroupInfo updateGroupName:newName];
    [Groups removeObjectAtIndex:index];
    [Groups insertObject:tempGroupInfo atIndex:index];
}

-(void) updateColorID:(int)color at:(NSUInteger)index
{
    GroupInfo *tempGroupsInfo = [[GroupInfo alloc]init];
    [tempGroupsInfo updateColorID:color];
    [Groups removeObjectAtIndex:index];
    [Groups insertObject:tempGroupsInfo atIndex:index];
}

-(GroupInfo*) objectAt:(NSUInteger)index
{
    return [Groups objectAtIndex:index];
}

@end
