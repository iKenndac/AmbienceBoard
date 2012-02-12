//
//  EnvironmentCellView.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"

@interface EnvironmentCellView : AQGridViewCell {
    UIImageView * _imageView;
    UILabel * _title;
}

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, copy) NSString * title;


@end
