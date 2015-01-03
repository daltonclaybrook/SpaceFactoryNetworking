//
//  SFSFileManager.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"
#import "SFSFileFetchRequest.h"
#import "SFSTask.h"

@interface SFSFileManager : NSObject

/**
 *  If you perform a fetch that does not override this setting, the value at the time of the call is the value used. i.e. if you call 'fetch...' then immediately change this property, the fetch will use the former value.
 */
@property (nonatomic, assign) BOOL usesEncryptionByDefault;

/**
 *  default is SFSFileManagerNoDiskSizeLimit. e.g there is not limit on the disk cache for files.
 */
@property (nonatomic, assign) NSInteger diskSizeLimit;

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

/*
 *
 *  Data Fetch Methods
 *
 */

/**
 *  url absolute string is used as the identifier
 */
- (id<SFSTask>)fetchFileDataAtURL:(NSURL *)url withCompletion:(SFSFileManagerCompletion)block;
- (id<SFSTask>)fetchFileDataUsingFetchRequest:(SFSFileFetchRequest *)request withCompletion:(SFSFileManagerCompletion)block;

/*
 *
 *  Existing Data
 *
 */

- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier;
- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;

/*
 *
 *  Data Injection
 *
 */

- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier;
- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;
- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt;

/*
 *
 *  Data Eviction
 *
 */

- (void)evictFileForIdentifier:(NSString *)identifier;  // assumes default file group
- (void)evictFileForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup save:(BOOL)save;
- (void)evictAllFilesInGroup:(NSString *)fileGroup;
- (void)evictAllFiles;

@end
