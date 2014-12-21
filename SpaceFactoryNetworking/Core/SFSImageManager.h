//
//  SFSImageManager.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSFileManager.h"

extern NSString * const SFSImageManagerErrorDomain;

typedef void(^SFSImageManagerCompletion)(UIImage *image, NSError *error);

@interface SFSImageManager : NSObject

@property (nonatomic, strong, readonly) SFSFileManager *backingFileManager;

/**
 *  if 'fileManager' is nil, one will be created.
 */
- (instancetype)initWithFileManager:(SFSFileManager *)fileManager;

/*
 *
 *  Fetch
 *
 */

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url withCompletion:(SFSImageManagerCompletion)block;
- (id<SFSTask>)fetchImageUsingFetchRequest:(SFSFileFetchRequest *)request withCompletion:(SFSImageManagerCompletion)block;

/*
 *
 *  Data
 *
 */

- (UIImage *)existingImageForURL:(NSURL *)url;
- (UIImage *)existingImageForIdentifier:(NSString *)identifier;
- (UIImage *)existingImageForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;

/*
 *
 *  Injection
 *
 */

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier;
- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;
- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt;

@end
