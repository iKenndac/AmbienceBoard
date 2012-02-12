//
//  EnvironmentCellView.h
//  Ambience Board
//
//  Created by Daniel Kennett on 11/02/2012.
//  Copyright (c) 2012 KennettNet Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "Environment.h"

@interface EnvironmentCellView : AQGridViewCell <UITextFieldDelegate> {
    UIImageView * _imageView;
    UITextField * _title;
}

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, copy) NSString * title;

@property (nonatomic, readwrite, strong) Environment *environment;

@end
