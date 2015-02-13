//
//  SFSDataFetchTask.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"
#import "SFSTask.h"

@interface SFSDataFetchTask : NSObject <SFSTask>

@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, copy) SFSDataManagerCompletion completionBlock;

+ (instancetype)taskWithSessionTask:(NSURLSessionTask *)task completion:(SFSDataManagerCompletion)block;

@end
