//
//  SFSTaskMetadata.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSFileManager.h"

@interface SFSTaskMetadata : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger taskIdentifier;
@property (nonatomic, copy) NSString *fileIdentifier;
@property (nonatomic, copy) NSString *fileGroup;
@property (nonatomic, assign) BOOL encrypted;
@property (nonatomic, copy) SFSFileManagerCompletion completionBlock;

+ (instancetype)metadataForTaskIdentifier:(NSUInteger)identifier fileIdentifier:(NSString *)fileIdentifier fileGroup:(NSString *)fileGroup encrypted:(BOOL)encrypted completion:(SFSFileManagerCompletion)block;

@end
