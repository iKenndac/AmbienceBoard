//
//  EnvironmentCellView.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "EnvironmentCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EnvironmentCellView

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _title = [[UITextField alloc] initWithFrame:CGRectZero];
    //_title.highlightedTextColor = [UIColor whiteColor];
    _title.font = [UIFont systemFontOfSize:20.0];
	_title.textColor = [UIColor whiteColor];
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumFontSize = 20.0;
	_title.delegate = self;
	_title.textAlignment = UITextAlignmentCenter;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
    _imageView.backgroundColor = self.backgroundColor;
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.clipsToBounds = YES;
    _title.backgroundColor = [UIColor clearColor];
	
	_imageView.layer.cornerRadius = 10.0;
	_imageView.clipsToBounds = YES;
	_imageView.userInteractionEnabled = YES;
	
	_titleBackground = [[UIView alloc] initWithFrame:CGRectZero];
	_titleBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _titleBackground.userInteractionEnabled = YES;
	
    [self.contentView addSubview: _imageView];
	[_imageView addSubview:_titleBackground];
    [_titleBackground addSubview:_title];
    
    return ( self );
}

@synthesize environment;

- (UIImage *) image
{
    return ( _imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
    _imageView.image = anImage;
    [self setNeedsLayout];
}

- (NSString *) title
{
    return ( _title.text );
}

- (void) setTitle: (NSString *) title
{
    _title.text = title;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.contentView.bounds;
	
	[_title sizeToFit];
	
	CGRect titleBackgroundFrame = _imageView.bounds;
	titleBackgroundFrame.size.height = _title.frame.size.height * 1.5;
	titleBackgroundFrame.origin.y = _imageView.bounds.size.height - titleBackgroundFrame.size.height;
	
	_titleBackground.frame = titleBackgroundFrame;
	
    //CGRect bounds = CGRectInset( self.contentView.bounds, 10.0, 10.0 );
	
	CGRect frame = _titleBackground.bounds;
	frame.size.height = _title.bounds.size.height;
    frame.origin.y = (titleBackgroundFrame.size.height / 2) - (frame.size.height / 2);
    _title.frame = frame;
    
    
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	self.environment.name = textField.text;
	[self.environment.managedObjectContext save:nil];
	return YES;
}


@end
