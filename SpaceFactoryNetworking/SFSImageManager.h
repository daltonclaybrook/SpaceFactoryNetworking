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

- (void)fetchImageAtURL:(NSURL *)url withCompletion:(SFSImageManagerCompletion)block;
- (void)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSImageManagerCompletion)block;
- (void)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSImageManagerCompletion)block;
- (void)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block;
- (void)fetchImageForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block;

- (UIImage *)existingImageForIdentifier:(NSString *)identifier;
- (UIImage *)existingImageForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup;

@end
