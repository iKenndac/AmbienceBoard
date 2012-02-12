//
//  Track.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Environment;

@interface Track : NSManagedObject

@property (nonatomic, retain) NSString * spotifyUri;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) Environment *environment;

@end
