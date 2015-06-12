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
@interface SAArtistViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
    
    [self textViewDidChange:self.artistBioTextView];
    [self.artistBioTextView setText:self.artist.bio];
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.scrollView.subviews)
    {
        scrollViewHeight += CGRectGetHeight(view.frame);
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    [self.scrollView setContentSize:(CGSizeMake(screenWidth, scrollViewHeight + 50))];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.artist.bio = [self retrieveBio];
    self.artistBioTextView.text = self.artist.bio;
    
    self.scrollView.delegate = self;
    
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

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

#pragma mark - retrieve bio

-(NSString*)retrieveBio
{
    NSLog(@"THE URI IS: %@",self.artist.uri);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:SAArtistsSearchUrl,self.artist.uri]]];
        
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
        
    NSArray *artistsResult = [jsonResult valueForKeyPath:@"response.biographies"];
    for (NSDictionary* obj in artistsResult) {
        if ([[obj valueForKey:@"site"] isEqualToString:@"last.fm"]) {
            self.artist.bio = [obj valueForKey:@"text"];
        }
    }
    return self.artist.bio;
}

#pragma mark - UScrollViewDelegate


@end
