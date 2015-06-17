//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SARequestManager : NSObject

typedef NS_ENUM(NSUInteger, SASearchModeOption) {
    SASearchModeArtist = 0,
    SASearchModeTrack,
} NS_ENUM_AVAILABLE_IOS(8_0);

+ (instancetype)sharedManager;

- (void)getObjectsWithQuery:(NSString *)query forItemEnum:(SASearchModeOption)artistTrackEnum
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure;


@end
