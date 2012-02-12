//
//  Track.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "Track.h"
#import "Environment.h"
#import "AppDelegate.h"

@implementation Track

@dynamic spotifyUri;
@dynamic startTime;
@dynamic endTime;
@dynamic environment;
@dynamic artist;
@dynamic name;

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[aCoder encodeObject:self.spotifyUri forKey:@"spotifyUri"];
	[aCoder encodeObject:self.startTime forKey:@"startTime"];
	[aCoder encodeObject:self.endTime forKey:@"endTime"];
	[aCoder encodeObject:self.artist forKey:@"artist"];
	[aCoder encodeObject:self.name forKey:@"name"];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	NSEntityDescription *desc = [NSEntityDescription entityForName:@"Environment" inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
	if(!(self = [super initWithEntity:desc insertIntoManagedObjectContext:nil]))
		return nil;
	
	self.spotifyUri = [aDecoder decodeObjectForKey:@"name"];
	self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
	self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
	self.artist = [aDecoder decodeObjectForKey:@"artist"];
	self.name = [aDecoder decodeObjectForKey:@"name"];

	
	return self;
}


@end
