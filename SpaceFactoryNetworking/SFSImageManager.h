//
//  SFSImageManager.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSFileManager.h"
#import <UIKit/UIKit.h>

extern NSString * const SFSImageManagerErrorDomain;

typedef void(^SFSImageManagerCompletion)(UIImage *image, NSError *error);

@interface SFSImageManager : SFSFileManager

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url withCompletion:(SFSImageManagerCompletion)block;
- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSImageManagerCompletion)block;
- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSImageManagerCompletion)block;
- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block;
- (id<SFSTask>)fetchImageForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block;

- (UIImage *)existingImageForIdentifier:(NSString *)identifier;
- (UIImage *)existingImageForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier;
- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;
- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt;

@end
