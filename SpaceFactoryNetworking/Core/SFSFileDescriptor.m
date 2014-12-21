//
//  SFSFileDescriptor.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSFileDescriptor.h"

NSString * const SFSFileManagerUnprotectedFileGroup = @"SFSFileManagerUnprotectedFileGroup";

static NSString * const kIdentifierKey = @"kIdentifierKey";
static NSString * const kFileGroupKey = @"kFileGroupKey";
static NSString * const kFileURLComponentKey = @"kFileURLComponentKey";
static NSString * const kFileSizeKey = @"kFileSizeKey";
static NSString * const kEncryptedKey = @"kEncryptedKey";
static NSString * const kAwaitingEncryptionKey = @"kAwaitingEncryptionKey";
static NSString * const kLastAccessDateKey = @"kLastAccessDateKey";

@implementation SFSFileDescriptor

#pragma mark - Public

- (NSString *)currentFileGroup
{
    return (self.awaitingEncryption) ? SFSFileManagerUnprotectedFileGroup : self.fileGroup;
}

- (NSURL *)fileURLWithBaseComponent:(NSString *)base
{
    return [self fileURLWithBaseComponent:base fileGroup:[self currentFileGroup]];
}

- (NSURL *)fileURLWithBaseComponent:(NSString *)base fileGroup:(NSString *)group
{
    if (!base.length || !group.length)
    {
        NSAssert(NO, @"Must use a non-empty base string and a non-empty file group: %@", NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSString *componentString = [NSString stringWithFormat:@"%li", (long)self.fileURLComponent];
    return [NSURL fileURLWithPathComponents:@[base, group, componentString]];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _identifier = [aDecoder decodeObjectForKey:kIdentifierKey];
        _fileGroup = [aDecoder decodeObjectForKey:kFileGroupKey];
        _fileURLComponent = [aDecoder decodeIntegerForKey:kFileURLComponentKey];
        _fileSize = [aDecoder decodeIntegerForKey:kFileSizeKey];
        _encrypted = [aDecoder decodeBoolForKey:kEncryptedKey];
        _awaitingEncryption = [aDecoder decodeBoolForKey:kAwaitingEncryptionKey];
        _lastAccessDate = [aDecoder decodeObjectForKey:kLastAccessDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kIdentifierKey];
    [aCoder encodeObject:self.fileGroup forKey:kFileGroupKey];
    [aCoder encodeInteger:self.fileURLComponent forKey:kFileURLComponentKey];
    [aCoder encodeInteger:self.fileSize forKey:kFileSizeKey];
    [aCoder encodeBool:self.encrypted forKey:kEncryptedKey];
    [aCoder encodeBool:self.awaitingEncryption forKey:kAwaitingEncryptionKey];
    [aCoder encodeObject:self.lastAccessDate forKey:kLastAccessDateKey];
}

@end
