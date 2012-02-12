//
//  EnvironmentCellView.m
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import "EnvironmentCellView.h"

@implementation EnvironmentCellView

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    _title = [[UILabel alloc] initWithFrame: CGRectZero];
    _title.highlightedTextColor = [UIColor whiteColor];
    _title.font = [UIFont boldSystemFontOfSize: 12.0];
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumFontSize = 10.0;
    
    self.backgroundColor = [UIColor colorWithWhite: 0.95 alpha: 1.0];
    self.contentView.backgroundColor = self.backgroundColor;
    _imageView.backgroundColor = self.backgroundColor;
    _title.backgroundColor = self.backgroundColor;
    
    [self.contentView addSubview: _imageView];
    [self.contentView addSubview: _title];
    
    return ( self );
}


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
    
    CGSize imageSize = _imageView.image.size;
    CGRect bounds = CGRectInset( self.contentView.bounds, 10.0, 10.0 );
    
    [_title sizeToFit];
    CGRect frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _title.frame = frame;
    
    // adjust the frame down for the image layout calculation
    bounds.size.height = frame.origin.y - bounds.origin.y;
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MIN(hRatio, vRatio);
    
    [_imageView sizeToFit];
    frame = _imageView.frame;
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _imageView.frame = frame;
}


@end
