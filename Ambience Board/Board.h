//
//  Board.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Environment;

@interface Board : NSManagedObject <NSCoding>

@property (nonatomic, retain) NSString * spotifyUserName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *environments;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addEnvironmentsObject:(Environment *)value;
- (void)removeEnvironmentsObject:(Environment *)value;
- (void)addEnvironments:(NSSet *)values;
- (void)removeEnvironments:(NSSet *)values;

@end
