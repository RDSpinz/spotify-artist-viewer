//
//  SASearchViewController.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtist.h"
#import "SAArtistViewController.h"
#import "ArtistTableViewCell.h"
#import "SARequestManager.h"


@interface SASearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating> {
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchResults;
@property UITableViewController* tableViewController;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Spotify Artist Search";
    
    self.tableViewController = [[UITableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.tableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    
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
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell = [[ArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    SAArtist* artist = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.name;
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [[SARequestManager sharedManager] getArtistsWithQuery:searchController.searchBar.text success:^(NSArray *blockArtists) {
        self.searchResults = blockArtists;
        [self.tableViewController.tableView reloadData];
        [self.tableView reloadData];

} failure:^(NSError *error) {
    
    }];
}

@end
