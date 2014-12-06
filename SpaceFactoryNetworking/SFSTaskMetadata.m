//
//  SFSTaskMetadata.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSTaskMetadata.h"

static NSString * const kTaskIdentifierKey = @"kTaskIdentifierKey";
static NSString * const kFileIdentifierKey = @"kFileIdentifierKey";
static NSString * const kFileGroupKey = @"kFileGroupKey";
static NSString * const kEncryptedKey = @"kEncryptedKey";

@implementation SFSTaskMetadata

#pragma mark - Initializers

+ (instancetype)metadataForTaskIdentifier:(NSUInteger)identifier task:(NSURLSessionTask *)task fileIdentifier:(NSString *)fileIdentifier fileGroup:(NSString *)fileGroup encrypted:(BOOL)encrypted completion:(SFSFileManagerCompletion)block
{
    SFSTaskMetadata *metadata = [[self alloc] init];
    metadata.taskIdentifier = identifier;
    metadata.task = task;
    metadata.fileIdentifier = fileIdentifier;
    metadata.fileGroup = fileGroup;
    metadata.encrypted = encrypted;
    metadata.completionBlock = block;
    return metadata;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _taskIdentifier = [aDecoder decodeIntegerForKey:kTaskIdentifierKey];
        _fileIdentifier = [aDecoder decodeObjectForKey:kFileIdentifierKey];
        _fileGroup = [aDecoder decodeObjectForKey:kFileGroupKey];
        _encrypted = [aDecoder decodeBoolForKey:kEncryptedKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.taskIdentifier forKey:kTaskIdentifierKey];
    [aCoder encodeObject:self.fileIdentifier forKey:kFileIdentifierKey];
    [aCoder encodeObject:self.fileGroup forKey:kFileGroupKey];
    [aCoder encodeBool:self.encrypted forKey:kEncryptedKey];
}

#pragma mark - SFSTask

- (void)cancelRequest
{
    [self.task cancel];
    self.task = nil;
}

- (void)ignoreResults
{
    self.completionBlock = nil;
}

@end
