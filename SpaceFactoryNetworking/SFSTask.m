//
//  SFSTask.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSTask.h"
#import "SFSTaskMetadata.h"

@implementation SFSTask

- (void)cancelRequest
{
    [self.task cancel];
    self.task = nil;
}

- (void)ignoreResults
{
    self.metadata.completionBlock = nil;
}

@end
