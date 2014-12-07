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

#pragma mark - Initializers

- (instancetype)initWithFileManager:(SFSFileManager *)fileManager
{
    self = [super init];
    if (self)
    {
        _backingFileManager = fileManager;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _backingFileManager = [[SFSFileManager alloc] init];
    }
    return self;
}

#pragma mark - Public

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchImageAtURL:url usingIdentifier:[url absoluteString] withCompletion:block];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchImageAtURL:url usingIdentifier:identifier fileGroup:SFSFileManagerDefaultFileGroup withCompletion:block];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSImageManagerCompletion)block
{
    return [self fetchImageAtURL:url usingIdentifier:identifier fileGroup:group usingDiskEncryption:self.backingFileManager.usesEncryptionByDefault withCompletion:block];
}

- (id<SFSTask>)fetchImageAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [self fetchImageForRequest:request usingIdentifier:identifier fileGroup:group usingDiskEncryption:encrypt withCompletion:block];
}

- (id<SFSTask>)fetchImageForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSImageManagerCompletion)block
{
    SFSFileManagerCompletion fileBlock = [self completionBlockWithImageBlock:block identifier:identifier group:group];
    
    return [self.backingFileManager fetchFileDataForRequest:request usingIdentifier:identifier fileGroup:group usingDiskEncryption:encrypt withCompletion:fileBlock];
}

- (UIImage *)existingImageForIdentifier:(NSString *)identifier
{
    NSURL *url = [self.backingFileManager existingFileURLForIdentifier:identifier];
    return [self imageFromFileURL:url error:nil];
}

- (UIImage *)existingImageForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    NSURL *url = [self.backingFileManager existingFileURLForIdentifier:identifier inGroup:fileGroup];
    return [self imageFromFileURL:url error:nil];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier
{
    [self.backingFileManager storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    [self.backingFileManager storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier inGroup:fileGroup];
}

- (void)storeImage:(UIImage *)image usingIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup usingDiskEncryption:(BOOL)encrypt
{
    [self.backingFileManager storeData:UIImagePNGRepresentation(image) usingIdentifier:identifier inGroup:fileGroup usingDiskEncryption:encrypt];
}

#pragma mark - Private

- (SFSFileManagerCompletion)completionBlockWithImageBlock:(SFSImageManagerCompletion)block identifier:(NSString *)identifier group:(NSString *)group
{
    __typeof__(self) __weak weakSelf = self;
    return ^(NSURL *fileURL, NSError *error) {
        
        UIImage *image = nil;
        if (!error)
        {
            image = [weakSelf imageFromFileURL:fileURL error:&error];
            if (error)
            {
                [weakSelf.backingFileManager evictFileForIdentifier:identifier inGroup:group save:YES];
            }
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
