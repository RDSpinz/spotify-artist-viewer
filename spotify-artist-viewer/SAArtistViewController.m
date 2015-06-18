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
#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SAArtistViewController

static NSString* const SAArtistsSearchUrl = @"http://developer.echonest.com/api/v4/artist/biographies?api_key=KUAKSGNM0ERIJ3ZO8&id=spotify:artist:%@";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artist.bio = [self retrieveBio];
    self.artistBioTextView.text = self.artist.bio;
    
    self.scrollView.delegate = self;
    
    self.artistBioTextView.text = self.artist.bio;
    [self textViewDidChange:self.artistBioTextView];
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.scrollView.subviews)
    {
        scrollViewHeight += CGRectGetHeight(view.frame);
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenRect);
    
    [self.scrollView setContentSize:(CGSizeMake(screenWidth, scrollViewHeight + 75))];
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.artistNameLabel.text = self.artist.name;
    
    [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageURL]];
    self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.height / 2;
    self.artistImageView.layer.masksToBounds = YES;
    self.artistImageView.layer.borderWidth = 1;
}

- (IBAction)backButtonPressed:(id)sender {
    SASearchViewController *detailViewController = [[SASearchViewController alloc] init];
    [self dismissViewControllerAnimated:YES completion:nil];
    detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

-(NSString*)retrieveBio {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:SAArtistsSearchUrl,self.artist.uri]]];
        
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
        
    NSArray *artistsResult = [jsonResult valueForKeyPath:@"response.biographies"];
    NSString* returnString = [[NSString alloc] init];
    for (NSDictionary* obj in artistsResult) {
        if ([[obj valueForKey:@"site"] isEqualToString:@"last.fm"]) {
            returnString = [obj valueForKey:@"text"];
            break;
        } else if ([[obj valueForKey:@"text"] length] > self.artist.bio.length){
            returnString = [obj valueForKey:@"text"];
        }
    }
    return returnString;
}


@end
