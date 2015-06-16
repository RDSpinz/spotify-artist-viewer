//
//  SASearchViewController.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtist.h"
#import "SATrack.h"
#import "SAArtistViewController.h"
#import "ArtistTableViewCell.h"
#import "SARequestManager.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SASearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating> {
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *trackSearchResults;
@property UITableViewController* tableViewController;
@property (nonatomic,assign) SASearchModeOption searchModeOption;
@end

@implementation SASearchViewController

static NSString *CellIdentifier = @"Artist_Cell_ID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Spotify Artist Search";
    
    self.tableViewController = [[UITableViewController alloc] init];
    [self.tableViewController.tableView registerClass:[ArtistTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[ArtistTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableViewController.tableView registerNib:[UINib nibWithNibName:@"ArtistTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtistTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.tableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setPlaceholder:@"Search for Artist, Track, or Both"];
    self.searchController.searchBar.scopeButtonTitles = @[@"Artist",@"Track",@"Both"];
    self.searchModeOption = self.searchController.searchBar.selectedScopeButtonIndex;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.tableView.delegate = self;
    self.tableViewController.tableView.delegate = self;
    self.tableViewController.tableView.dataSource = self;
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.tableView.frame = screenRect;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAArtist *artist = [self.searchResults objectAtIndex:indexPath.row];
    
    SAArtistViewController * detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"artistView"];
    detailViewController.artist = artist;
    [self presentViewController:detailViewController animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.searchModeOption) {
        case SASearchModeArtist:
            return [self.searchResults count];
            break;
        case SASearchModeTrack:
            return [self.trackSearchResults count];
            break;
        case SASearchModeBoth:
            NSLog(@"oops");
            return 10;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArtistTableViewCell *cell = (ArtistTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    switch (self.searchModeOption) {
        case SASearchModeArtist:
        {
            SAArtist* artist = [self.searchResults objectAtIndex:indexPath.row];
            cell.artistNameLabel.text = artist.name;
            [cell.artistImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageURL]];
            break;
        }
        case SASearchModeTrack:
        {
            SATrack* track = [self.trackSearchResults objectAtIndex:indexPath.row];
            cell.artistNameLabel.text = track.title;
            cell.userInteractionEnabled = NO;
            break;
        }
        case SASearchModeBoth:
        {
            NSLog(@"Both");
        }
        break;
    }
    
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    switch (self.searchModeOption) {
        case SASearchModeArtist:
        {
            [[SARequestManager sharedManager] getObjectsWithQuery:searchController.searchBar.text forItemEnum:self.searchModeOption success:^(NSArray *blockArtists) {
                self.searchResults = blockArtists;
                [self.tableViewController.tableView reloadData];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
            break;
        }
        case SASearchModeTrack:
        {
            [[SARequestManager sharedManager] getObjectsWithQuery:searchController.searchBar.text forItemEnum:self.searchModeOption success:^(NSArray *blockTracks) {
                self.trackSearchResults = blockTracks;
                [self.tableViewController.tableView reloadData];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
            break;
        }
        case SASearchModeBoth:
            //
            break;
    }

    

}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.searchModeOption = self.searchController.searchBar.selectedScopeButtonIndex;
    self.searchResults = @[];
    self.trackSearchResults = @[];
    [self.tableViewController.tableView reloadData];
    [self.tableView reloadData];
}

@end
