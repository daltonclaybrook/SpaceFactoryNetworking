//
//  SFSDataManager.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/21/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"
#import "SFSDataFetchRequest.h"
#import "SFSRequestSerialization.h"
#import "SFSResponseSerialization.h"
#import "SFSTask.h"

@interface SFSDataManager : NSObject

@property (nonatomic, strong) NSURL *baseURL;

/**
 *  requests/responses are not serialized if these properties are not set.
 */
@property (nonatomic, strong) id<SFSRequestSerialization> requestSerializer;
@property (nonatomic, strong) id<SFSResponseSerialization> responseSerializer;
@property (nonatomic, copy) NSDictionary *defaultHeaders;

// Initializers
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

// Fetch Methods

/**
 *  Creates a GET request
 */
- (id<SFSTask>)fetchDataAtPath:(NSString *)path completion:(SFSDataManagerCompletion)block;
- (id<SFSTask>)fetchDataUsingFetchRequest:(SFSDataFetchRequest *)request completion:(SFSDataManagerCompletion)block;

/**
 *  Use this method if you require more control over the URL request
 */
- (id<SFSTask>)fetchDataUsingURLRequest:(NSURLRequest *)urlRequest completion:(SFSDataManagerCompletion)block;

@end
