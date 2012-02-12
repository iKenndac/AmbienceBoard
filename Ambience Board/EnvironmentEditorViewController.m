//
//  EnvironmentEditorViewController.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "EnvironmentEditorViewController.h"
#import "Track.h"
#import "AppDelegate.h"

@interface EnvironmentEditorViewController ()

-(void)addTrackFromSpotifyTrack:(SPTrack *)track;

@end


@implementation EnvironmentEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@synthesize environment;

-(IBAction)playEnvironment:(id)sender {
	[[(AppDelegate *)[[UIApplication sharedApplication] delegate] ambienceController] beginGeneratingAmbienceForEnvironment:self.environment];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = self.environment.name;
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithTitle:@"Play"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(playEnvironment:)];
	self.navigationItem.leftBarButtonItem = playButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)insertNewObject {
	TrackChooserViewController *choose = [[TrackChooserViewController alloc] init];
	choose.delegate = self;
	[self presentModalViewController:choose animated:YES];
}

-(void)trackChooser:(TrackChooserViewController *)choose didChooseTracks:(NSArray *)tracks {
	
	for (SPTrack *track in tracks) {
		[self addTrackFromSpotifyTrack:track];
	}
}

-(void)addTrackFromSpotifyTrack:(SPTrack *)track {
	
	// Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.environment managedObjectContext];
    Track *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Track"
																  inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    newManagedObject.spotifyUri = track.spotifyURL.absoluteString;
	newManagedObject.artist = track.consolidatedArtists;
	newManagedObject.name = track.name;
    
	[self.environment addTracksObject:newManagedObject];
	
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	[self.tableView reloadData];

}

#pragma mark -
#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	
	Track *track = [[self.environment.tracks allObjects] objectAtIndex:indexPath.row];
	cell.textLabel.text = track.name;
	cell.detailTextLabel.text = track.artist;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.environment.tracks.count;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	Track *track = [[self.environment.tracks allObjects] objectAtIndex:indexPath.row];
	SPTrack *spTrack = [SPTrack trackForTrackURL:[NSURL URLWithString:track.spotifyUri]
									   inSession:[SPSession sharedSession]];
	
	NSError *error = nil;
	[[SPSession sharedSession] playTrack:spTrack error:&error];
	
	if (error)
		NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
}

@end
