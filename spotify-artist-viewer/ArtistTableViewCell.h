//
//  ArtistTableViewCell.h
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artistImageView;

@end
