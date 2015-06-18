//
//  SAArtistViewController.h
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAArtist;

@interface SAArtistViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artistImageView;
@property (strong, nonatomic) IBOutlet UITextView *artistBioTextView;
@property (strong, nonatomic) SAArtist* artist;
@end
