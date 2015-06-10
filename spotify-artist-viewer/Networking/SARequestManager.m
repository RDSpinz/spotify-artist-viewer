//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"

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
        
        NSError *jsonError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
        
        
        NSArray *artistsResult = [jsonResult valueForKeyPath:@"artists.items"];
        NSDictionary * images = [jsonResult valueForKey:@"images"];
        NSLog(@"URL: %@",images);
        NSArray *names = [artistsResult valueForKey:@"name"];
        
        if (success) {
            success(names);
        }

    }
    }

@end
