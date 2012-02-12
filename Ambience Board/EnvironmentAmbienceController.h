//
//  EnvironmentAmbienceController.h
//  Ambience Board
//
//  Created by Daniel Kennett on 12/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLibSpotify.h"
#import "SPCoreAudioController.h"
#import "Environment.h"
#import "Track.h"

@interface EnvironmentAmbienceController : NSObject <SPCoreAudioControllerDelegate, SPSessionAudioDeliveryDelegate>

-(void)beginGeneratingAmbienceForEnvironment:(Environment *)env;

@property (nonatomic, strong, readonly) Environment *environment;
@property (nonatomic, strong, readonly) SPTrack *currentSPTrack;
@property (nonatomic, strong, readonly) Track *currentTrack;

@end
