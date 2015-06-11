//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SAArtist.h"
#import "SASearchViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SAArtistViewController ()

@end

@implementation SAArtistViewController

static NSString * const SAArtistsSearchUrl = @"http://developer.echonest.com/api/v4/artist/biographies?api_key=KUAKSGNM0ERIJ3ZO8&id=spotify:artist:%@";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.artistNameLabel.text = self.artist.name;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.artist.imageURL]];
    
    self.artistImageView.image = [UIImage imageWithData:imageData];
    
    self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.height / 2;
    self.artistImageView.layer.masksToBounds = YES;
    self.artistImageView.layer.borderWidth = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.artist.bio = [self retrieveBio];
    self.artistBioTextView.text = self.artist.bio;
}

-(instancetype)initWithArtist:(SAArtist*)artist{
    self = [super init];
    if(self){
        self.artist = artist;
        
    }
    return self;
}

- (IBAction)backButtonPressed:(id)sender {
    SASearchViewController *detailViewController = [[SASearchViewController alloc] init];
    [self dismissViewControllerAnimated:YES completion:nil];
    detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    [self presentViewController:detailViewController animated:YES completion:nil];
}

#pragma mark - retrieve bio

-(NSString*)retrieveBio{
    
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:SAArtistsSearchUrl,self.artist.uri]]];
        
        NSError *jsonError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
        
        NSArray *artistsResult = [jsonResult valueForKeyPath:@"response.biographies"];
    for (NSDictionary* obj in artistsResult) {
        if ([[obj valueForKey:@"site"] isEqualToString:@"last.fm"]) {
            NSLog(@"OBJECT: %@",obj);
            self.artist.bio = [obj valueForKey:@"text"];
        }
    }

return self.artist.bio;
}
@end
