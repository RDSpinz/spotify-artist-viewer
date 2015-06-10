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
    NSMutableDictionary* artists;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTop;
@property (strong, nonatomic) NSArray *searchResults;
@property UITableViewController* tableViewController;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self retrieveSearchResult];
    self.searchBarTop = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBarTop;
    self.searchBarTop.delegate = self;
    
    self.tableViewController = [[UITableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.tableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableViewController.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SAArtist *artist = [self.searchResults objectAtIndex:indexPath.row];
    SAArtistViewController *detailViewController = [[SAArtistViewController alloc] initWithArtist:artist];
    
    detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"artistView"];
    [self presentViewController:detailViewController animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSSet* set = [[NSSet alloc] initWithArray:self.searchResults];
    self.searchResults = [set allObjects];
    NSLog(@"COUNT: %lu",(unsigned long)self.searchResults.count);
        return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSDictionary* artist = [[NSDictionary alloc] init];
        // Configure the cell...
        cell = [[ArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        artist = [self.searchResults objectAtIndex:indexPath.row];
        NSLog(@"ARTIST: %@",artist);
        
        //cell.textLabel.text = [artist objectForKey:@"Artist"];
        cell.textLabel.text = self.searchResults[indexPath.row];
    }
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [[SARequestManager sharedManager] getArtistsWithQuery:searchController.searchBar.text success:^(NSArray *blockArtists)
     
    {
        self.searchResults = blockArtists;
        [self.tableView reloadData];

    } failure:^(NSError *error) {

    }];
}

@end
