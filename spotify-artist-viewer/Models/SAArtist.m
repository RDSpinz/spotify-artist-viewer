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
    NSString* descriptionString = [NSString stringWithFormat:@"Artist: %@, Image: %@",self.name,self.imageURL];
    return descriptionString;
}

-(NSComparisonResult)compare:(SAArtist*)otherObject{
    return [self.name compare:otherObject.name];
}
@end
