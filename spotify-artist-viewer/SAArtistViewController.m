//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SAArtist.h"
@interface SAArtistViewController ()
@property SAArtist* artist;
@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(instancetype)initWithArtist:(SAArtist*)artist{
    self = [super init];
    if(self){
        self.artist = artist;
    }
    return self;
}

@end
