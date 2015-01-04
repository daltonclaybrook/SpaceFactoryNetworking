//
//  SFSURLRequestFactory.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/2/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSURLRequestFactory.h"
#import "SFSDataFetchRequest.h"
#import "SFSRequestSerialization.h"

@implementation SFSURLRequestFactory

#pragma mark - Public

- (NSURLRequest *)urlRequestFromFetchRequest:(SFSDataFetchRequest *)request baseURL:(NSURL *)baseURL usingSerializer:(id<SFSRequestSerialization>)serializer
{
    NSString *fullPath = [baseURL.absoluteString stringByAppendingPathComponent:request.path];
    NSURL *url = [NSURL URLWithString:fullPath];
    NSMutableURLRequest *urlRequest = nil;
    
    if (url)
    {
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        urlRequest.HTTPMethod = [self HTTPMethodFromDataRequestMethod:request.method];
        urlRequest.HTTPBody = [self HTTPBodyDataFromObjectIfNecessary:request.object usingSerializer:serializer];
        urlRequest.cachePolicy = [self cachePolicyForDataCachePolicy:request.cachePolicy];
        
        [self applyHTTPHeaders:request.httpHeaderDictionary toRequest:urlRequest];
    }
    
    return [urlRequest copy];
}

#pragma mark - Private

- (NSString *)HTTPMethodFromDataRequestMethod:(SFSDataRequestMethod)method
{
    switch (method)
    {
        case SFSDataRequestMethodGET:
            return @"GET";
        case SFSDataRequestMethodPOST:
            return @"POST";
        case SFSDataRequestMethodDELETE:
            return @"DELETE";
        case SFSDataRequestMethodHEAD:
            return @"HEAD";
        case SFSDataRequestMethodPATCH:
            return @"PATCH";
        case SFSDataRequestMethodPUT:
            return @"PUT";
        default:
        {
            NSAssert(NO, @"%li is not a valid method", method);
            return nil;
        }
    }
}

- (NSURLRequestCachePolicy)cachePolicyForDataCachePolicy:(SFSDataCachePolicy)policy
{
    switch (policy)
    {
        case SFSDataCachePolicyProtocol:
            return NSURLRequestUseProtocolCachePolicy;
        case SFSDataCachePolicyUseCache:
            return NSURLRequestReturnCacheDataElseLoad;
        case SFSDataCachePolicyIgnoreCache:
            return NSURLRequestReloadIgnoringCacheData;
        default:
        {
            NSAssert(NO, @"%li is not a valid policy", policy);
            return 0;
        }
    }
}

- (NSData *)HTTPBodyDataFromObjectIfNecessary:(id)object usingSerializer:(id<SFSRequestSerialization>)serializer
{
    NSData *data = nil;
    if (object)
    {
        if (serializer)
        {
            if ([serializer canSerializeObject:object])
            {
                data = [serializer bodyDataFromObject:object];
            }
            else
            {
                NSAssert(NO, @"Serializer %@ cannot serialize object %@", serializer, object);
            }
        }
        else if ([object isKindOfClass:[NSData class]])
        {
            data = object;
        }
        else
        {
            NSAssert(NO, @"No request serializer exists and object %@ is not NSData", object);
        }
    }
    return data;
}

- (void)applyHTTPHeaders:(NSDictionary *)headers toRequest:(NSMutableURLRequest *)request
{
    for (NSString *key in [headers keyEnumerator])
    {
        NSString *value = headers[key];
        [request setValue:value forHTTPHeaderField:key];
    }
}

@end
