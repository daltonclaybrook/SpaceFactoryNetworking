//
//  SFSTask.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSTask <NSObject>

- (void)cancelRequest;
- (void)ignoreResults;

@end

@class SFSTaskMetadata;

@interface SFSTask : NSObject <SFSTask>

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) SFSTaskMetadata *metadata;

@end
