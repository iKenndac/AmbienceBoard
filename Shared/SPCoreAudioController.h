//
//  SPCoreAudioController.h
//  Viva
//
//  Created by Daniel Kennett on 04/02/2012.
//  For license information, see LICENSE.markdown
//

// This class encapsulates a Core Audio graph that includes
// an audio format converter, a graphic EQ and a standard output.
// Clients just need to set the various properties and not worry about
// the details.

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import "CocoaLibSpotify.h"
#import <CoreAudio/CoreAudioTypes.h>
#else
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "EQPresetController.h"
#import <CoreAudio/CoreAudio.h>
#endif

@class SPCoreAudioController;

@protocol SPCoreAudioControllerDelegate <NSObject>

-(void)coreAudioController:(SPCoreAudioController *)controller didOutputAudioOfDuration:(NSTimeInterval)audioDuration;

@end

@interface SPCoreAudioController : NSObject <SPSessionAudioDeliveryDelegate>

@property (readwrite, nonatomic) double volume;
@property (readwrite, nonatomic) BOOL audioOutputEnabled;

@property (readwrite, weak, nonatomic) id <SPCoreAudioControllerDelegate> delegate;

#if !TARGET_OS_IPHONE
@property (readwrite, nonatomic) BOOL eqEnabled;
@property (readwrite, strong, nonatomic) EQPreset *eqPreset;
@property (readonly, strong, nonatomic) NSArray *leftLevels;
@property (readonly, strong, nonatomic) NSArray *rightLevels;
#endif

// -- Control --

-(void)clearAudioBuffers;

@end
