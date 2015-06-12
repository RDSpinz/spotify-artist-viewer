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

-(void)configureCell:(UITableViewCell*)cell ForForm:(SAArtist *)cellArtist {
    ArtistTableViewCell* newCell = [[ArtistTableViewCell alloc] init];
    newCell.textLabel.text = cellArtist.name;
    cell = newCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
