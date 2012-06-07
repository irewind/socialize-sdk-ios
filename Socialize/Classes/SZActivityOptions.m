//
//  SZActivityOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActivityOptions.h"

@implementation SZActivityOptions
@synthesize dontShareLocation = dontShareLocation_;
@synthesize willPostToSocialNetworkBlock = willPostToSocialNetworkBlock_;
@synthesize didPostToSocialNetworkBlock = didPostToSocialNetworkBlock_;

+ (SZActivityOptions*)defaultOptions {
    return [[[self alloc] init] autorelease];
}

@end