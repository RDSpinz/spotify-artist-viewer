//
//  SAArtist.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAArtist : NSObject
@property NSString* name;
@property NSString* imageURL;
@property NSString* bio;

-(instancetype)initWithName:(NSString*)name image:(NSString*)image andBio:(NSString*)bio;
@end
