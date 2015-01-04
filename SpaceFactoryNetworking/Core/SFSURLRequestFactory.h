//
//  SFSURLRequestFactory.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/2/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFSDataFetchRequest;
@protocol SFSRequestSerialization;

@interface SFSURLRequestFactory : NSObject

- (NSURLRequest *)urlRequestFromFetchRequest:(SFSDataFetchRequest *)request baseURL:(NSURL *)baseURL usingSerializer:(id<SFSRequestSerialization>)serializer;

@end
