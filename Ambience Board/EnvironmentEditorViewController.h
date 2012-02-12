//
//  EnvironmentEditorViewController.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Environment.h"
#import "TrackChooserViewController.h"

@interface EnvironmentEditorViewController : UITableViewController <TrackChooserViewControllerDelegate>

@property (nonatomic, strong, readwrite) Environment *environment;

@end
