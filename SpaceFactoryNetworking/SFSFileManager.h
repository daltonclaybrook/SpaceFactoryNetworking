//
//  SFSFileManager.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSTask.h"

NSInteger const SFSFileManagerNoDiskSizeLimit = -1;
extern NSString * const SFSFileManagerDefaultFileGroup;

typedef void(^SFSFileManagerCompletion)(NSURL *fileURL, NSError *error);

@interface SFSFileManager : NSObject

/**
 *  If you perform a fetch that does not override this setting, the value at the time of the call is the value used. i.e. if you call 'fetch...' then immediately change this property, the fetch will use the former value.
 */
@property (nonatomic, assign) BOOL usesEncryptionByDefault;

/**
 *  default is SFSFileManagerNoDiskSizeLimit. e.g there is not limit on the disk cache for files.
 */
@property (nonatomic, assign) NSInteger diskSizeLimit;

/**
 *  url absolute string is used as the identifier
 */
- (id<SFSTask>)fetchFileDataAtURL:(NSURL *)url withCompletion:(SFSFileManagerCompletion)block;
- (id<SFSTask>)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSFileManagerCompletion)block;
- (id<SFSTask>)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSFileManagerCompletion)block;
- (id<SFSTask>)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSFileManagerCompletion)block;
- (id<SFSTask>)fetchFileDataForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSFileManagerCompletion)block;

- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier;
- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;

- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier;
- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;
- (void)storeData:(NSData *)data usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt;

- (void)evictFileForIdentifier:(NSString *)identifier;  // assumes default file group
- (void)evictFileForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;
- (void)evictAllFilesInGroup:(NSString *)fileGroup;
- (void)evictAllFiles;

@end
