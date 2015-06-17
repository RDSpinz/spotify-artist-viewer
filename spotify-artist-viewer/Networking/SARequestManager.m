//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"
#import "SATrack.h"
#import "SARequestManager.h"

@implementation SARequestManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SARequestManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [SARequestManager new];
    });
    return sharedManager;
}

- (void)getObjectsWithQuery:(NSString *)query forItemEnum:(SASearchModeOption)artistTrackEnum
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    
    if (![query isEqualToString:@""]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:[self searchURLForOption:artistTrackEnum],query]]];
        if (data) {
        NSError *jsonError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&jsonError];
            NSArray* returnArray;
            switch (artistTrackEnum) {
                case SASearchModeArtist:
                    returnArray = [self artistsFromJSON:jsonResult];
                    break;
                case SASearchModeTrack:
                    returnArray = [self tracksFromJSON:jsonResult];
                    break;
            }
            if (success) {
                success(returnArray);
            }
        }
    }
}

- (NSString *)searchURLForOption:(SASearchModeOption)option {
    switch (option) {
        case SASearchModeArtist:
            return @"https://api.spotify.com/v1/search?q=%@&type=artist&market=US";
            break;
        case SASearchModeTrack:
            return @"https://api.spotify.com/v1/search?q=%@&type=track&market=US";
            break;
    }
}

-(NSArray*)artistsFromJSON:(NSDictionary*)jsonResult {
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
    
   
        return returnArtistsArray;
}

-(NSArray*)tracksFromJSON:(NSDictionary*)jsonResult {
    NSArray* tracksResult = [jsonResult valueForKeyPath:@"tracks.items"];
    NSArray* names = [tracksResult valueForKey:@"name"];
    NSArray* uriList = [tracksResult valueForKey:@"uri"];
    
    NSMutableArray* returnTracksArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < names.count; i++) {
        SATrack* track = [[SATrack alloc] initWithTitle:names[i] andImage:nil andID:uriList[i]];
        [returnTracksArray addObject:track];
    }
    
    return returnTracksArray;
                        
}

@end
