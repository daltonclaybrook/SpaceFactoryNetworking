//
//  SFSDataManager.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/21/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSDataManager.h"
#import "SFSDataFetchTask.h"
#import "SFSURLRequestFactory.h"
#import "SFSDataErrorFactory.h"

static NSString * const kContentTypeKey = @"Content-Type";

@interface SFSDataManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSMutableDictionary *requestMappings;

@property (nonatomic, strong) SFSURLRequestFactory *urlRequestFactory;
@property (nonatomic, strong) SFSDataErrorFactory *errorFactory;

@end

@implementation SFSDataManager

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self SFSDataManagerCommonInit];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self)
    {
        _baseURL = baseURL;
        [self SFSDataManagerCommonInit];
    }
    return self;
}

- (void)SFSDataManagerCommonInit
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    _requestMappings = [NSMutableDictionary dictionary];
    
    _urlRequestFactory = [[SFSURLRequestFactory alloc] init];
    _errorFactory = [[SFSDataErrorFactory alloc] init];
}

#pragma mark - Public

- (id<SFSTask>)fetchDataAtPath:(NSString *)path completion:(SFSDataManagerCompletion)block
{
    SFSDataFetchRequest *request = [SFSDataFetchRequest GETRequestWithPath:path];
    
    return [self fetchDataUsingFetchRequest:request completion:block];
}

- (id<SFSTask>)fetchDataUsingFetchRequest:(SFSDataFetchRequest *)request completion:(SFSDataManagerCompletion)block
{
    NSURLRequest *urlRequest = [self.urlRequestFactory urlRequestFromFetchRequest:request baseURL:self.baseURL headers:self.defaultHeaders usingSerializer:self.requestSerializer];
    
    return [self fetchDataUsingURLRequest:urlRequest completion:block];
}

- (id<SFSTask>)fetchDataUsingURLRequest:(NSURLRequest *)urlRequest completion:(SFSDataManagerCompletion)block
{
    if (!urlRequest)
    {
        NSAssert(NO, @"one or more parameters were invalid");
        return nil;
    }
    
    NSURLRequest *newReqest = [self requestByAddingContentTypeToRequestIfNecessary:urlRequest];
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:newReqest];
    SFSDataFetchTask *fetchTask = [SFSDataFetchTask taskWithSessionTask:task completion:block];
    
    self.requestMappings[task] = fetchTask;
    [task resume];
    
    return fetchTask;
}

#pragma mark - Private

- (NSURLRequest *)requestByAddingContentTypeToRequestIfNecessary:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *value = [mutableRequest valueForHTTPHeaderField:kContentTypeKey];
    
    if (!value.length && self.requestSerializer)
    {
        NSString *contentType = [self.requestSerializer contentType];
        if (contentType.length)
        {
            [mutableRequest setValue:contentType forHTTPHeaderField:kContentTypeKey];
        }
    }
    
    return [mutableRequest copy];
}

// Consider implementing method to upgrade data tasks to download tasks
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    SFSDataFetchTask *fetchTask = self.requestMappings[dataTask];
    [fetchTask.responseData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSError *finalError = error;
    if (!finalError)
    {
        finalError = [self.errorFactory errorForTask:task];
    }
    
    SFSDataFetchTask *fetchTask = self.requestMappings[task];
    [self.requestMappings removeObjectForKey:task];
    
    if (fetchTask.completionBlock)
    {
        id response = nil;
        
        if (!finalError)
        {
            response = fetchTask.responseData;
            if (self.responseSerializer)
            {
                response = [self.responseSerializer objectFromData:response error:&finalError];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            fetchTask.completionBlock(response, finalError);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    // TODO: Consider reporting upload progress
}

@end
