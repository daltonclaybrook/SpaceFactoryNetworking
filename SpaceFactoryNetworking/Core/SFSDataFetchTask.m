//
//  SFSDataFetchTask.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSDataFetchTask.h"

@implementation SFSDataFetchTask

#pragma mark - Initializers

+ (instancetype)taskWithSessionTask:(NSURLSessionTask *)task completion:(SFSDataManagerCompletion)block
{
    SFSDataFetchTask *fetchTask = [[self alloc] init];
    fetchTask.sessionTask = task;
    fetchTask.responseData = [NSMutableData data];
    fetchTask.completionBlock = block;
    
    return fetchTask;
}

#pragma mark - SFSTask

- (BOOL)isRunning
{
    return (self.sessionTask.state == NSURLSessionTaskStateRunning);
}

- (void)cancelRequest
{
    [self.sessionTask cancel];
}

- (void)ignoreResults
{
    self.completionBlock = nil;
}

@end
