//
//  TrackChooserViewController.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@class TrackChooserViewController;

@protocol TrackChooserViewControllerDelegate <NSObject>

-(void)trackChooser:(TrackChooserViewController *)choose didChooseTracks:(NSArray *)tracks;

@end

@interface TrackChooserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) SPSearch *search;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (strong, readwrite, nonatomic) NSMutableArray *remainingSearchResults;

@property (weak, nonatomic, readwrite) id <TrackChooserViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
