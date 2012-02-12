//
//  Environment.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "Environment.h"
#import "AppDelegate.h"

@implementation Environment

@dynamic name;
@dynamic board;
@dynamic tracks;

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.tracks forKey:@"tracks"];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	NSEntityDescription *desc = [NSEntityDescription entityForName:@"Environment" inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
	if(!(self = [super initWithEntity:desc insertIntoManagedObjectContext:nil]))
		return nil;
	
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.tracks = [aDecoder decodeObjectForKey:@"tracks"];
	for(Track *track in self.tracks)
		track.environment = self;
	
	return self;
}


@end
