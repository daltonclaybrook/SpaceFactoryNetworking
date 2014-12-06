//
//  SFSFileDescriptor.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SFSFileManagerUnprotectedFileGroup;

@interface SFSFileDescriptor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *fileGroup;
@property (nonatomic, assign) NSUInteger fileURLComponent;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) BOOL encrypted;
@property (nonatomic, assign) BOOL awaitingEncryption;
@property (nonatomic, strong) NSDate *lastAccessDate;

/**
 *  This property is not persisted to disk. It is used by the file manager when determining which items should be evicted under memory pressure.
 */
@property (nonatomic, assign) NSUInteger evictionRank;

/**
 *  Will either return 'fileGroup', or the unprotected file group if awaiting encryption
 */
- (NSString *)currentFileGroup;
- (NSURL *)fileURLWithBaseComponent:(NSString *)base;
- (NSURL *)fileURLWithBaseComponent:(NSString *)base fileGroup:(NSString *)group;

@end
