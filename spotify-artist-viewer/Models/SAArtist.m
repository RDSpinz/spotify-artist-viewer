//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist
-(instancetype)initWithName:(NSString*)name image:(NSString*)image andBio:(NSString*)bio{
    self = [super init];
    if (self){
        self.name = name;
        self.imageURL = image;
        self.bio = bio;
    }
    return self;
}

-(NSString*)description{
    return self.name;
}

-(NSComparisonResult)compare:(SAArtist*)otherObject{
    return [self.name compare:otherObject.name];
}
@end
