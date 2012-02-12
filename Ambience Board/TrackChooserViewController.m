//
//  TrackChooserViewController.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "TrackChooserViewController.h"

@implementation TrackChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self addObserver:self forKeyPath:@"search.tracks" options:0 context:nil];
    }
    return self;
}

-(void)dealloc {
	[self removeObserver:self forKeyPath:@"search.tracks"];
}

@synthesize search;
@synthesize searchResultsTable;
@synthesize delegate;
@synthesize remainingSearchResults;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"search.tracks"]) {
		self.remainingSearchResults = [NSMutableArray arrayWithArray:self.search.tracks];
        [self.searchResultsTable reloadData];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	self.search = [SPSearch searchWithSearchQuery:textField.text
										inSession:[SPSession sharedSession]];
	
	return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setSearchResultsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -

- (IBAction)cancel:(id)sender {
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
	[self cancel:sender];
}

#pragma mark -
#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	
	SPTrack *track = [self.remainingSearchResults objectAtIndex:indexPath.row];
	cell.textLabel.text = track.name;
	cell.detailTextLabel.text = track.consolidatedArtists;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.remainingSearchResults.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SPTrack *track = [self.remainingSearchResults objectAtIndex:indexPath.row];
	[self.delegate trackChooser:self didChooseTracks:[NSArray arrayWithObject:track]];
	
	[self.remainingSearchResults removeObjectAtIndex:indexPath.row];
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationRight];
	
}

@end
