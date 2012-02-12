//
//  DetailViewController.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "AQGridViewController.h"
#import "Board.h"

@interface DetailViewController : AQGridViewController <UISplitViewControllerDelegate, AQGridViewDataSource, AQGridViewDelegate>

@property (strong, nonatomic) Board *board;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) UIPopoverController *popover;

@end
