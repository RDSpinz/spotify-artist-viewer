//
//  SATrack.m
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATrack.h"

@implementation SATrack

-(instancetype)initWithTitle:(NSString*)trackName andImage:(NSString*)image andID:(NSString*)identifier {
    self = [super init];
    if (self) {
        self.title = trackName;
        self.imageURL = image;
        self.uri = identifier;
    }
    return self;
}

-(NSString*)description {
    NSString* descriptionString = [NSString stringWithFormat:@"Title: %@, Image: %@, URI: %@",self.title,self.imageURL, self.uri];
    return descriptionString;
}

-(NSComparisonResult)compare:(SATrack*)otherObject {
    return [self.title compare:otherObject.title];
}

@end
