//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAArtist.h"

@implementation SARequestManager

static NSString * const SAArtistsSearchUrl = @"https://api.spotify.com/v1/search?q=%@&type=track,artist&market=US";

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SARequestManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [SARequestManager new];
    });
    return sharedManager;
}

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    
    
    // TODO: make network calls to spotify API
    if (![query isEqualToString:@""]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:SAArtistsSearchUrl,query]]];
        if (data) {
        NSError *jsonError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
        
        NSArray *artistsResult = [jsonResult valueForKeyPath:@"artists.items"];
       
        NSArray* imageArrays = [artistsResult valueForKeyPath:@"images.url"];
        NSArray* uriList = [artistsResult valueForKeyPath:@"uri"];

        NSMutableArray* individualImages = [[NSMutableArray alloc] init];
        for (NSArray* array in imageArrays) {
            if ([array count]) {
                [individualImages addObject:array[0]];
            } else {
                [individualImages addObject:@""];
            }
        }

        NSArray *names = [artistsResult valueForKey:@"name"];
        NSMutableArray* returnArtistsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < names.count; i++) {
            SAArtist* a = [[SAArtist alloc] initWithName:names[i] image:individualImages[i] andBio:nil andURI:uriList[i]];
            [returnArtistsArray addObject:a];
        }
        
        if (success) {
            success(returnArtistsArray);
        }
        }
    }
}

@end
