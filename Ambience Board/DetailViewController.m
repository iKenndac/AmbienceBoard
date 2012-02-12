//
//  DetailViewController.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "DetailViewController.h"
#import "EnvironmentCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "Environment.h"
#import "EnvironmentEditorViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize board = _board;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize popover;

#pragma mark - Managing the detail item

- (void)setBoard:(Board *)newBoard
{
    if (_board != newBoard) {
        _board = newBoard;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
	[self.gridView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark AQGridView

-(NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
	return self.board.environments.count;
}

-(AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	EnvironmentCellView *cell = (EnvironmentCellView *)[gridView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil)
		cell = [[EnvironmentCellView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 150.0) reuseIdentifier:@"cell"];
	
	
	Environment *environment = [[self.board.environments allObjects] objectAtIndex:index];
	
	cell.image = [environment.name caseInsensitiveCompare:@"ruddy mysterious"] == NSOrderedSame ? 
			[UIImage imageNamed:@"moss.jpg"] : [UIImage imageNamed:@"background.png"];
	cell.selectionGlowColor = [UIColor blueColor];
	cell.selectionGlowShadowRadius = 5.0;
	cell.title = environment.name;
	return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView {
    return CGSizeMake(224.0, 168.0);
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	
	EnvironmentEditorViewController *editorController = [[EnvironmentEditorViewController alloc] init];
	editorController.environment = [[[self.board environments] allObjects] objectAtIndex:index];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editorController];
	self.popover = [[UIPopoverController alloc] initWithContentViewController:navController];
	
	[self.popover presentPopoverFromRect:[gridView rectForItemAtIndex:index]
								  inView:gridView
				permittedArrowDirections:UIPopoverArrowDirectionAny
								animated:YES];
}

-(void)gridView:(AQGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index {
	if (self.popover) {
		[self.popover dismissPopoverAnimated:YES];
		self.popover = nil;
	}
}

#pragma mark -
#pragma mark Model

-(void)insertNewObject {
	
	// Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.board managedObjectContext];
    Environment *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Environment"
																  inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    newManagedObject.name = @"New Environment";
    
	[self.board addEnvironmentsObject:newManagedObject];
	
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
	
	[self.gridView reloadData];
	
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.gridView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Boards", @"Boards");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
