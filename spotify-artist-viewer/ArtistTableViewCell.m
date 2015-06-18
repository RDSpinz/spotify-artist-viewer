//
//  ArtistTableViewCell.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ArtistTableViewCell.h"
#import "SAArtist.h"

@implementation ArtistTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        
        // Initialize Properties
        self.artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
        self.artistImageView = [[UIImageView alloc] init];
        
        // Configure Main Label
        [self.artistNameLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
        [self.artistNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.artistNameLabel setTextColor:[UIColor blackColor]];
        [self.artistNameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        //Configure Artist Image
        self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.height / 2;
        self.artistImageView.layer.masksToBounds = YES;
        self.artistImageView.layer.borderWidth = 0;
        
        // Add Main Label to Content View
        [self.contentView addSubview:self.artistNameLabel];
    }
    
    return self;
}

@end
