//
//  SATrack.h
//  spotify-artist-viewer
//
//  Created by Randall Spence on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SATrack : NSObject
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* imageURL;
@property (nonatomic,strong) NSString* uri;

-(instancetype)initWithTitle:(NSString*)trackName andImage:(NSString*)image andID:(NSString*)identifier;
@end
