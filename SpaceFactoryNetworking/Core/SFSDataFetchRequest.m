//
//  SFSDataFetchRequest.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSDataFetchRequest.h"

@implementation SFSDataFetchRequest

#pragma mark - Initializers

+ (instancetype)GETRequestWithPath:(NSString *)path
{
    return [self requestWithMethod:SFSDataRequestMethodGET path:path object:nil];
}

+ (instancetype)POSTRequestWithPath:(NSString *)path object:(id)object
{
    return [self requestWithMethod:SFSDataRequestMethodPOST path:path object:object];
}

+ (instancetype)requestWithMethod:(SFSDataRequestMethod)method path:(NSString *)path object:(id)object
{
    if (!path.length)
    {
        NSAssert(NO, @"path cannot be empty");
        return nil;
    }
    
    SFSDataFetchRequest *request = [[self alloc] init];
    request.method = method;
    request.path = path;
    request.object = object;
    return request;
}

@end
