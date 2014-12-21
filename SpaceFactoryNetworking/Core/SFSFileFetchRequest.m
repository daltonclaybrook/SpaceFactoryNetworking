//
//  SFSFileFetchRequest.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/7/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSFileFetchRequest.h"
#import "SFSFileManagerConstants.h"

@implementation SFSFileFetchRequest

+ (instancetype)request
{
    return [self defaultRequestWithURLRequest:nil];
}

+ (instancetype)defaultRequestWithURL:(NSURL *)url
{
    return [self defaultRequestWithURLRequest:[NSURLRequest requestWithURL:url]];
}

+ (instancetype)defaultRequestWithURLRequest:(NSURLRequest *)request
{
    SFSFileFetchRequest *fetchRequest = [[self alloc] init];
    fetchRequest.urlRequest = request;
    fetchRequest.identifier = [request.URL absoluteString];
    fetchRequest.fileGroup = SFSFileManagerDefaultFileGroup;
    fetchRequest.encryptionPolicy = SFSFileFetchRequestEncryptionPolicyDefault;
    fetchRequest.taskPriority = SFSFileFetchRequestTaskPriorityDefault;
    return fetchRequest;
}

@end
