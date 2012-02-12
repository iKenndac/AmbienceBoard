//
//  Board.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "Board.h"
#import "Environment.h"
#import "AppDelegate.h"

@implementation Board

@dynamic spotifyUserName;
@dynamic name;
@dynamic environments;

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[aCoder encodeObject:self.spotifyUserName forKey:@"spotifyUserName"];
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.environments forKey:@"environments"];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
    NSManagedObjectContext *moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *desc = [NSEntityDescription entityForName:@"Board" inManagedObjectContext:moc];
	if(!(self = [super initWithEntity:desc insertIntoManagedObjectContext:moc]))
		return nil;
	
	self.spotifyUserName = [aDecoder decodeObjectForKey:@"spotifyUserName"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.environments = [aDecoder decodeObjectForKey:@"environments"];
	
	return self;
}

@end
