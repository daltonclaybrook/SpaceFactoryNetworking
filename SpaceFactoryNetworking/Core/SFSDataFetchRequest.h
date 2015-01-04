//
//  SFSDataFetchRequest.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SFSDataRequestMethod)
{
    SFSDataRequestMethodGET,
    SFSDataRequestMethodPOST,
    SFSDataRequestMethodPUT,
    SFSDataRequestMethodPATCH,
    SFSDataRequestMethodDELETE,
    SFSDataRequestMethodHEAD
};

typedef NS_ENUM(NSInteger, SFSDataCachePolicy)
{
    SFSDataCachePolicyProtocol, // uses the cache policy defined in the protocol implementation
    SFSDataCachePolicyIgnoreCache,
    SFSDataCachePolicyUseCache  // attemts to use the cache, else loads
};

// TODO: Consider using a base class or protocol of SFSFileFetchRequest
@interface SFSDataFetchRequest : NSObject

@property (nonatomic, assign) SFSDataRequestMethod method;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) id object;

/**
 *  keys/values to use as HTTP headers for this request only
 */
@property (nonatomic, copy) NSDictionary *httpHeaderDictionary;
@property (nonatomic, assign) SFSDataCachePolicy cachePolicy;

/**
 *  path is relative to the base URL on
 */
+ (instancetype)GETRequestWithPath:(NSString *)path;
/**
 *  Includes the object to POST. object is serialized by the request serializer on the data manager.
 */
+ (instancetype)POSTRequestWithPath:(NSString *)path object:(id)object;
+ (instancetype)requestWithMethod:(SFSDataRequestMethod)method path:(NSString *)path object:(id)object;

@end
