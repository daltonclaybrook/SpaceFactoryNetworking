//
//  SFSImageManager.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSImageManager.h"

NSString * const SFSImageManagerErrorDomain = @"SFSImageManagerErrorDomain";

@implementation SFSImageManager

#pragma mark - Public

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchFileDataAtURL:url withCompletion:[self completionBlockWithImageBlock:block]];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchFileDataAtURL:url usingIdentifier:identifier withCompletion:[self completionBlockWithImageBlock:block]];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchFileDataAtURL:url usingIdentifier:identifier fileGroup:group withCompletion:[self completionBlockWithImageBlock:block]];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchFileDataAtURL:url usingIdentifier:identifier fileGroup:group usingDiskEncryption:encrypt withCompletion:[self completionBlockWithImageBlock:block]];
}

- (id<SFSTask>)fetchImageForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchFileDataForRequest:request usingIdentifier:identifier fileGroup:group usingDiskEncryption:encrypt withCompletion:[self completionBlockWithImageBlock:block]];
}

- (UIImage *)existingImageForIdentifier:(NSString *)identifier
{
    NSURL *url = [self existingFileURLForIdentifier:identifier];
    return [self imageFromFileURL:url error:nil];
}

- (UIImage *)existingImageForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    NSURL *url = [self existingFileURLForIdentifier:identifier inGroup:fileGroup];
    return [self imageFromFileURL:url error:nil];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier
{
    [self storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    [self storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier inGroup:fileGroup];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt
{
    [self storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier inGroup:fileGroup usingDiskEncryption:encrypt];
}

#pragma mark - Private

- (SFSFileManagerCompletion)completionBlockWithImageBlock:(SFSImageManagerCompletion)block
{
    __typeof__(self) __weak weakSelf = self;
    return ^(NSURL *fileURL, NSError *error) {
        
        UIImage *image = nil;
        if (!error)
        {
            image = [weakSelf imageFromFileURL:fileURL error:&error];
        }
        
        if (block)
        {
            block(image, error);
        }
    };
}

- (UIImage *)imageFromFileURL:(NSURL *)url error:(out NSError *__autoreleasing*)error
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[url path]];
    if (!image && error)
    {
        *error = [self invalidImageDataError];
    }
    return image;
}

- (NSError *)invalidImageDataError
{
    return [NSError errorWithDomain:SFSImageManagerErrorDomain code:0 userInfo:@{ NSUnderlyingErrorKey : @"Image could not be created from the data at the specified file or endpoint" }];
}

@end
