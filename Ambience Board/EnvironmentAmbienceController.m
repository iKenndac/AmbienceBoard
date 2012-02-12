//
//  EnvironmentAmbienceController.m
//  Ambience Board
//
//  Created by Daniel Kennett on 12/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "EnvironmentAmbienceController.h"
#import "Track.h"

static void * const kEACPlayTrackWhenLoadedKVOContext = @"kEACPlayTrackWhenLoadedKVOContext";

@interface EnvironmentAmbienceController ()

@property (nonatomic, strong, readwrite) Environment *environment;
@property (nonatomic, strong, readwrite) SPCoreAudioController *outgoingAudioController;
@property (nonatomic, strong, readwrite) SPCoreAudioController *audioController;
@property (nonatomic, strong, readwrite) SPTrack *currentSPTrack;
@property (nonatomic, strong, readwrite) Track *currentTrack;

@property (nonatomic, strong, readwrite) NSTimer *fadeOutTimer;
@property (nonatomic, strong, readwrite) NSTimer *fadeInTimer;
@property (nonatomic, strong, readwrite) NSMutableSet *remainingTrackPool;
@property (nonatomic, readwrite) NSTimeInterval position;

-(void)fadeOutgoingAudioController;
-(void)switchToNewTrack:(Track *)track;
-(void)startPlaybackOfLoadedTrack:(SPTrack *)track;
-(Track *)getNextTrackInEnvironment;

@end

@implementation EnvironmentAmbienceController

-(id)init {
	self = [super init];

	if (self) {
		[SPSession sharedSession].audioDeliveryDelegate = self;
	}
	
	return self;
}

-(void)beginGeneratingAmbienceForEnvironment:(Environment *)env {
	
	self.remainingTrackPool = nil;
	self.environment = env;
	[self switchToNewTrack:[self getNextTrackInEnvironment]];
}

-(void)switchToNewTrack:(Track *)track {
	
	[SPSession sharedSession].playing = NO;
	
	SPTrack *spTrack = [SPTrack trackForTrackURL:[NSURL URLWithString:track.spotifyUri]
									   inSession:[SPSession sharedSession]];
	
	if (self.audioController != nil) {
		if (!self.audioController.audioOutputEnabled) {
			self.outgoingAudioController = self.audioController;
			[self.fadeOutTimer invalidate];
			self.fadeOutTimer = nil;
			[self fadeOutgoingAudioController];
		}
		self.audioController = nil;
	}
	
	NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Invalidating");
	[self.fadeInTimer invalidate];
	self.fadeInTimer = nil;
	
	self.audioController = [[SPCoreAudioController alloc] init];
	self.audioController.delegate = self;
	self.audioController.audioOutputEnabled = NO;
	self.audioController.volume = 0.0;
	self.currentTrack = track;
	
	if (spTrack.isLoaded)
		[self startPlaybackOfLoadedTrack:spTrack];
	else
		[spTrack addObserver:self
				  forKeyPath:@"loaded"
					 options:0
					 context:kEACPlayTrackWhenLoadedKVOContext];
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kEACPlayTrackWhenLoadedKVOContext) {
		
		[self startPlaybackOfLoadedTrack:object];
		[object removeObserver:self forKeyPath:keyPath context:kEACPlayTrackWhenLoadedKVOContext];
	
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)startPlaybackOfLoadedTrack:(SPTrack *)track {
	
	self.position = 0;
	
	NSError *error = nil;
	[[SPSession sharedSession] playTrack:track error:&error];
	if (error) {
		NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
		[self switchToNewTrack:[self getNextTrackInEnvironment]];
	} else { 
		self.currentSPTrack = track;
		[[SPSession sharedSession] seekPlaybackToOffset:[self.currentTrack.startTime doubleValue]];
		self.position = [self.currentTrack.startTime doubleValue];
	}
}

-(Track *)getNextTrackInEnvironment {
	
	if (self.remainingTrackPool.count == 0)
		self.remainingTrackPool = [NSMutableSet setWithSet:self.environment.tracks];
	
	Track *track = [self.remainingTrackPool anyObject];
	[self.remainingTrackPool removeObject:track];
	
	return track;
}

#pragma mark -
#pragma mark Audio Control

static const NSTimeInterval kFadeOutDuration = 3.0;
static const NSTimeInterval kFadeInDuration = 3.0;

-(void)fadeOutgoingAudioController {
	self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
														 target:self
													   selector:@selector(fadeOutTimerDidTick:)
													   userInfo:nil
														repeats:YES];
}

-(void)fadeOutTimerDidTick:(NSTimer *)timer {
	self.outgoingAudioController.volume -= (1.0 / kFadeOutDuration) * timer.timeInterval;
	if (self.outgoingAudioController.volume <= 0.0) {
		[self.fadeOutTimer invalidate];
		self.fadeOutTimer = nil;
		self.outgoingAudioController.audioOutputEnabled = NO;
		self.outgoingAudioController = nil;
	}
}

-(void)fadeIncomingAudioController {
	self.fadeInTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
														target:self
													  selector:@selector(fadeInTimerDidTick:)
													  userInfo:nil
													   repeats:YES];
}

-(void)fadeInTimerDidTick:(NSTimer *)timer {
	self.audioController.volume += (1.0 / kFadeInDuration) * timer.timeInterval;
	if (self.audioController.volume >= 1.0) {
		[self.fadeInTimer invalidate];
		self.fadeInTimer = nil;
	}
}

@synthesize environment;
@synthesize outgoingAudioController;
@synthesize audioController;
@synthesize fadeOutTimer;
@synthesize fadeInTimer;
@synthesize currentSPTrack;
@synthesize remainingTrackPool;
@synthesize position;
@synthesize currentTrack;

#pragma mark -
#pragma mark Audio Delivery

-(NSInteger)session:(id<SPSessionPlaybackProvider>)aSession shouldDeliverAudioFrames:(const void *)audioFrames ofCount:(NSInteger)frameCount streamDescription:(AudioStreamBasicDescription)audioDescription {
	
	if (!(self.audioController == nil) && self.audioController.audioOutputEnabled == NO) {
		self.audioController.audioOutputEnabled = YES;
	}
	
	return [self.audioController session:aSession shouldDeliverAudioFrames:audioFrames ofCount:frameCount streamDescription:audioDescription];
}

-(void)coreAudioController:(SPCoreAudioController *)controller didOutputAudioOfDuration:(NSTimeInterval)audioDuration {
	
	if (controller == self.audioController) {
		
		if (self.audioController.volume == 0.0) {
			self.audioController.volume = 0.001;
			[self fadeIncomingAudioController];
			NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Fading in");
		}
		
		NSTimeInterval currentLocation = self.position;
		NSTimeInterval timeToStop = [self.currentTrack.endTime doubleValue];
		if (timeToStop == 0.0) timeToStop = self.currentSPTrack.duration;
		
		if (currentLocation >= timeToStop - kFadeOutDuration)
			[self switchToNewTrack:[self getNextTrackInEnvironment]];
	}
}



@end
