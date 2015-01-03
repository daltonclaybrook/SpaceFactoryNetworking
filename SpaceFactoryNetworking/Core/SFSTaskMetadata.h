//
//  SFSTaskMetadata.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"
#import "SFSTask.h"

@interface SFSTaskMetadata : NSObject <NSCoding, SFSTask>

@property (nonatomic, assign) NSUInteger taskIdentifier;
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, copy) NSString *fileIdentifier;
@property (nonatomic, copy) NSString *fileGroup;
@property (nonatomic, assign) BOOL encrypted;
@property (nonatomic, strong) NSMutableArray *completionBlocks;

+ (instancetype)metadataForTaskIdentifier:(NSUInteger)identifier task:(NSURLSessionTask *)task fileIdentifier:(NSString *)fileIdentifier fileGroup:(NSString *)fileGroup encrypted:(BOOL)encrypted completion:(SFSFileManagerCompletion)block;

@end
