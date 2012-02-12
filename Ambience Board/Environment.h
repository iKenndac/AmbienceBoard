//
//  Environment.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Environment : NSManagedObject <NSCoding>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *board;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface Environment (CoreDataGeneratedAccessors)

- (void)addTracksObject:(NSManagedObject *)value;
- (void)removeTracksObject:(NSManagedObject *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
