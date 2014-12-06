//
//  SFSFileManager.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSFileManager.h"
#import "SFSFileDescriptor.h"
#import "SFSTaskMetadata.h"

NSString * const SFSFileManagerDefaultFileGroup = @"SFSFileManagerDefaultFileGroup";
static NSString * const SFSFileManagerUnprotectedFileGroup = @"SFSFileManagerUnprotectedFileGroup";
static NSString * const SFSFileManagerRootDirectory = @"SFSFileManagerRootDirectory";

static NSString * const kBackgroundSessionIdentifier = @"kBackgroundSessionIdentifier";
static NSString * const kManifestFileName = @"manifest";
static NSString * const kTaskMetadataFileName = @"taskMetadata";

@interface SFSFileManager () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSMutableArray *fileManifest;
@property (nonatomic, strong) NSMutableArray *taskMetadata;

@end

@implementation SFSFileManager

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self SFSFileManagerCommonInit];
    }
    return self;
}

- (void)SFSFileManagerCommonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(protectedDataWillBecomeUnavailableNotification:) name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(protectedDataDidBecomeAvailableNotification:) name:UIApplicationProtectedDataDidBecomeAvailable object:nil];
    
    [self unarchiveManifestAndMetadata];
    if ([self isProtectedDataAvailable])
    {
        [self encryptUnprotectedFilesIfNecessary];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionIdentifier];
    _urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    [self cleanupTaskMetadata];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Fetching

- (void)fetchFileDataAtURL:(NSURL *)url withCompletion:(SFSFileManagerCompletion)block
{
    [self fetchFileDataAtURL:url usingIdentifier:[url absoluteString] withCompletion:block];
}

- (void)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier withCompletion:(SFSFileManagerCompletion)block
{
    [self fetchFileDataAtURL:url usingIdentifier:identifier fileGroup:SFSFileManagerDefaultFileGroup withCompletion:block];
}

- (void)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group withCompletion:(SFSFileManagerCompletion)block
{
    [self fetchFileDataAtURL:url usingIdentifier:identifier fileGroup:group usingDiskEncryption:self.usesEncryptionByDefault withCompletion:block];
}

- (void)fetchFileDataAtURL:(NSURL *)url usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSFileManagerCompletion)block
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self fetchFileDataForRequest:urlRequest usingIdentifier:identifier fileGroup:group usingDiskEncryption:encrypt withCompletion:block];
}

- (void)fetchFileDataForRequest:(NSURLRequest *)request usingIdentifier:(NSString *)identifier fileGroup:(NSString *)group usingDiskEncryption:(BOOL)encrypt withCompletion:(SFSFileManagerCompletion)block
{
    if (!request || !identifier.length || !group.length)
    {
        NSAssert(NO, @"One or more parameters are invalid: %@", NSStringFromSelector(_cmd));
        return;
    }
    
    NSURL *existingFile = [self urlForIdentifier:identifier group:group fileDescriptor:nil];
    if (existingFile)
    {
        if (block)
        {
            block(existingFile, nil);
        }
    }
    else
    {
        NSURLSessionDownloadTask *task = [self.urlSession downloadTaskWithRequest:request];
        
        SFSTaskMetadata *metadata = [SFSTaskMetadata metadataForTaskIdentifier:task.taskIdentifier fileIdentifier:identifier fileGroup:group encrypted:encrypt completion:block];
        [self.taskMetadata addObject:metadata];
        [self saveTaskMetadata];
        
        [task resume];
    }
}

#pragma mark - File Retrieval

- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier
{
    return [self existingFileURLForIdentifier:identifier inGroup:SFSFileManagerDefaultFileGroup];
}

- (NSURL *)existingFileURLForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    if (!identifier.length || !fileGroup.length)
    {
        NSAssert(NO, @"One or more parameters are invalid: %@", NSStringFromSelector(_cmd));
        return nil;
    }
    return [self urlForIdentifier:identifier group:fileGroup fileDescriptor:nil];
}

#pragma mark - Eviction

- (void)evictFileForIdentifier:(NSString *)identifier
{
    [self evictFileForIdentifier:identifier inGroup:SFSFileManagerDefaultFileGroup];
}

- (void)evictFileForIdentifier:(NSString *)identifier inGroup:(NSString *)fileGroup
{
    SFSFileDescriptor *descriptor = nil;
    NSURL *url = [self urlForIdentifier:identifier group:fileGroup fileDescriptor:&descriptor];
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    [self.fileManifest removeObject:descriptor];
    [self saveManifest];
}

- (void)evictAllFilesInGroup:(NSString *)fileGroup
{
    NSString *path = [NSString pathWithComponents:@[[self rootDirectory], fileGroup]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileGroup == %@", fileGroup];
    NSArray *filteredArray = [self.fileManifest filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count)
    {
        [self.fileManifest removeObjectsInArray:filteredArray];
        [self saveManifest];
    }
}

- (void)evictAllFiles
{
    [[NSFileManager defaultManager] removeItemAtPath:[self rootDirectory] error:nil];
    
    [self.fileManifest removeAllObjects];
    [self saveManifest];
}

#pragma mark - Private

- (void)unarchiveManifestAndMetadata
{
    _fileManifest = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self manifestFilePath]] mutableCopy];
    if (!_fileManifest)
    {
        _fileManifest = [NSMutableArray array];
    }
    
    _taskMetadata = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self taskMetadataFilePath]] mutableCopy];
    if (!_taskMetadata)
    {
        _taskMetadata = [NSMutableArray array];
    }
}

- (void)cleanupTaskMetadata
{
    __typeof__(self) __weak weakSelf = self;
    [self.urlSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        NSMutableArray *metadataToRemove = [NSMutableArray array];
        for (SFSTaskMetadata *metadata in weakSelf.taskMetadata)
        {
            NSUInteger index = [downloadTasks indexOfObjectPassingTest:^BOOL(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
                return (task.taskIdentifier == metadata.taskIdentifier);
            }];
            
            if (index == NSNotFound)
            {
                [metadataToRemove addObject:metadata];
            }
        }
        
        if (metadataToRemove.count)
        {
            [weakSelf.taskMetadata removeObjectsInArray:metadataToRemove];
            [weakSelf saveTaskMetadata];
        }
    }];
}

- (void)encryptUnprotectedFilesIfNecessary
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"awaitingEncryption == TRUE"];
    NSArray *filteredArray = [self.fileManifest filteredArrayUsingPredicate:predicate];
    BOOL madeChanges = NO;
    
    for (SFSFileDescriptor *descriptor in filteredArray)
    {
        NSURL *existingURL = [descriptor fileURLWithBaseComponent:[self rootDirectory] fileGroup:SFSFileManagerUnprotectedFileGroup];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[existingURL path]])
        {
            NSUInteger component;
            NSURL *fileURL = [self createAvailableFileURLInFileGroup:descriptor.fileGroup withComponent:&component];
            [self createDirectoryForGroupIfNecessary:descriptor.fileGroup];
            [self deleteExistingFileAtURLIfNecessary:fileURL];
            
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtURL:existingURL toURL:fileURL error:&error];
            if (!error)
            {
                NSString *protectionValue = NSFileProtectionComplete;
                NSDictionary *protectionAttributes = @{NSFileProtectionKey : protectionValue};
                [[NSFileManager defaultManager] setAttributes:protectionAttributes ofItemAtPath:[fileURL path] error:&error];
                if (error)
                {
                    // move the file back
                    [[NSFileManager defaultManager] moveItemAtURL:fileURL toURL:existingURL error:nil];
                }
                else
                {
                    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:nil];
                    
                    descriptor.awaitingEncryption = NO;
                    descriptor.fileURLComponent = component;
                    descriptor.fileSize = attributes.fileSize;
                    madeChanges = YES;
                }
            }
        }
    }
    
    if (madeChanges)
    {
        [self saveManifest];
    }
}

- (void)moveFileURL:(NSURL *)url usingMetadata:(SFSTaskMetadata *)metadata
{
    BOOL awaitingEncryption = (metadata.encrypted && ![self isProtectedDataAvailable]);
    NSString *fileGroup = (awaitingEncryption) ? SFSFileManagerUnprotectedFileGroup : metadata.fileGroup;
    
    NSUInteger component;
    NSURL *newURL = [self createAvailableFileURLInFileGroup:fileGroup withComponent:&component];
    [self createDirectoryForGroupIfNecessary:fileGroup];
    [self deleteExistingFileAtURLIfNecessary:newURL];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:url toURL:newURL error:&error];
    
    if (!error)
    {
        NSString *protectionValue = (metadata.encrypted && !awaitingEncryption) ? NSFileProtectionComplete : NSFileProtectionNone;
        NSDictionary *protectionAttributes = @{NSFileProtectionKey : protectionValue};
        [[NSFileManager defaultManager] setAttributes:protectionAttributes ofItemAtPath:[newURL path] error:&error];
        
        if (error)
        {
            [[NSFileManager defaultManager] removeItemAtURL:newURL error:nil];
        }
        else
        {
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[newURL path] error:nil];
            
            SFSFileDescriptor *descriptor = [[SFSFileDescriptor alloc] init];
            descriptor.identifier = metadata.fileIdentifier;
            descriptor.fileGroup = metadata.fileGroup;
            descriptor.fileURLComponent = component;
            descriptor.fileSize = attributes.fileSize;
            descriptor.encrypted = metadata.encrypted;
            descriptor.awaitingEncryption = awaitingEncryption;
            descriptor.lastAccessDate = [NSDate date];
            
            [self.fileManifest addObject:descriptor];
            [self saveManifest];
        }
    }
    
    [self completeWithBlock:metadata.completionBlock fileURL:((!error) ? newURL : nil) error:error];
}

- (void)completeWithBlock:(SFSFileManagerCompletion)block fileURL:(NSURL *)url error:(NSError *)error
{
    if (block)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(url, error);
        });
    }
}

- (NSURL *)urlForIdentifier:(NSString *)identifier group:(NSString *)fileGroup fileDescriptor:(out SFSFileDescriptor *__autoreleasing*)outDescriptor
{
    NSURL *url = nil;
    NSUInteger index = [self.fileManifest indexOfObjectPassingTest:^BOOL(SFSFileDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        return ([descriptor.identifier isEqualToString:identifier] &&
                [descriptor.fileGroup isEqualToString:fileGroup]);
    }];
    
    if (index != NSNotFound)
    {
        SFSFileDescriptor *descriptor = self.fileManifest[index];
        if (outDescriptor)
        {
            *outDescriptor = descriptor;
        }
        url = [descriptor fileURLWithBaseComponent:[self rootDirectory]];
    }
    
    return url;
}

- (BOOL)saveManifest
{
    NSArray *copiedManifest = [self.fileManifest copy];
    return [NSKeyedArchiver archiveRootObject:copiedManifest toFile:[self manifestFilePath]];
}

- (BOOL)saveTaskMetadata
{
    NSArray *copiedMetadata = [self.taskMetadata copy];
    return [NSKeyedArchiver archiveRootObject:copiedMetadata toFile:[self taskMetadataFilePath]];
}

- (NSString *)manifestFilePath
{
    return [NSString pathWithComponents:@[[self rootDirectory], kManifestFileName]];
}

- (NSString *)taskMetadataFilePath
{
    return [NSString pathWithComponents:@[[self rootDirectory], kTaskMetadataFileName]];
}

- (NSString *)rootDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString pathWithComponents:@[[paths firstObject], SFSFileManagerRootDirectory]];
}

- (NSUInteger)firstAvailableFileURLComponentForFileGroup:(NSString *)group
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileGroup == %@", group];
    NSArray *filteredArray = [self.fileManifest filteredArrayUsingPredicate:predicate];
    NSArray *sortedArray = [filteredArray sortedArrayUsingComparator:^NSComparisonResult(SFSFileDescriptor *descriptor1, SFSFileDescriptor *descriptor2) {
        return [@(descriptor1.fileURLComponent) compare:@(descriptor2.fileURLComponent)];
    }];
    
    NSUInteger urlComponent = 0;
    for (SFSFileDescriptor *descriptor in sortedArray)
    {
        if (descriptor.fileURLComponent > urlComponent)
        {
            break;
        }
        urlComponent++;
    }
    return urlComponent;
}

#pragma mark - Notifications

- (void)protectedDataWillBecomeUnavailableNotification:(NSNotification *)notification
{
    // no-op
}

- (void)protectedDataDidBecomeAvailableNotification:(NSNotification *)notification
{
    [self encryptUnprotectedFilesIfNecessary];
}

#pragma mark - Helper Methods

- (SFSTaskMetadata *)metadataForTask:(NSURLSessionTask *)task
{
    SFSTaskMetadata *metadata = nil;
    NSUInteger index = [self.taskMetadata indexOfObjectPassingTest:^BOOL(SFSTaskMetadata *data, NSUInteger idx, BOOL *stop) {
        return (data.taskIdentifier == task.taskIdentifier);
    }];
    if (index != NSNotFound)
    {
        metadata = self.taskMetadata[index];
    }
    return metadata;
}

- (BOOL)isProtectedDataAvailable
{
    return [[UIApplication sharedApplication] isProtectedDataAvailable];
}

- (NSURL *)createAvailableFileURLInFileGroup:(NSString *)group withComponent:(out NSUInteger *)outComponent
{
    NSString *documentsDirectory = [self rootDirectory];
    NSUInteger component = [self firstAvailableFileURLComponentForFileGroup:group];
    NSString *componentString = [NSString stringWithFormat:@"%lu", (unsigned long)component];
    
    if (outComponent)
    {
        *outComponent = component;
    }
    return [NSURL fileURLWithPathComponents:@[documentsDirectory, group, componentString]];
}

- (void)createDirectoryForGroupIfNecessary:(NSString *)group
{
    void (^createDirectory)(NSString *path) = ^(NSString *path) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    };
    
    NSString *path = [NSString pathWithComponents:@[[self rootDirectory], group]];
    BOOL directory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory])
    {
        if (!directory)
        {
            createDirectory(path);
        }
    }
    else
    {
        createDirectory(path);
    }
}

- (void)deleteExistingFileAtURLIfNecessary:(NSURL *)url
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    SFSTaskMetadata *metadata = [self metadataForTask:task];
    if (metadata)
    {
        [self.taskMetadata removeObject:metadata];
        [self saveTaskMetadata];
        
        [self completeWithBlock:metadata.completionBlock fileURL:nil error:error];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    SFSTaskMetadata *metadata = [self metadataForTask:downloadTask];
    if (metadata)
    {
        [self.taskMetadata removeObject:metadata];
        [self saveTaskMetadata];
        
        [self moveFileURL:location usingMetadata:metadata];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // consider implementing callbacks for progress
}

@end
