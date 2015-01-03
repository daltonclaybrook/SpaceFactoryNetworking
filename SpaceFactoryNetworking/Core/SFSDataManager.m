//
//  SFSDataManager.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/21/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSDataManager.h"
#import "SFSDataFetchTask.h"

@interface SFSDataManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSMutableDictionary *requestMappings;

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
}

#pragma mark - Public

- (id<SFSTask>)fetchDataAtPath:(NSString *)path completion:(SFSDataManagerCompletion)block
{
    SFSDataFetchRequest *request = [SFSDataFetchRequest GETRequestWithPath:path];
    
    return [self fetchDataUsingFetchRequest:request completion:block];
}

- (id<SFSTask>)fetchDataUsingFetchRequest:(SFSDataFetchRequest *)request completion:(SFSDataManagerCompletion)block
{
    NSURLRequest *urlRequest = [self urlRequestFromFetchRequest:request];
    
    return [self fetchDataUsingURLRequest:urlRequest completion:block];
}

- (id<SFSTask>)fetchDataUsingURLRequest:(NSURLRequest *)request completion:(SFSDataManagerCompletion)block
{
    if (!request || !block)
    {
        NSAssert(NO, @"one or more parameters were invalid");
        return nil;
    }
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request];
    SFSDataFetchTask *fetchTask = [SFSDataFetchTask taskWithSessionTask:task completion:block];
    
    self.requestMappings[task] = fetchTask;
    [task resume];
    
    return fetchTask;
}

#pragma mark - Helper Methods

- (NSURLRequest *)urlRequestFromFetchRequest:(SFSDataFetchRequest *)request
{
    NSString *fullPath = [self.baseURL.absoluteString stringByAppendingPathComponent:request.path];
    NSURL *url = [NSURL URLWithString:fullPath];
    NSMutableURLRequest *urlRequest = nil;
    
    if (url)
    {
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        urlRequest.HTTPMethod = [self HTTPMethodFromDataRequestMethod:request.method];
        urlRequest.HTTPBody = [self HTTPBodyDataFromObjectIfNecessary:request.object];
    }
    
    return [urlRequest copy];
}

- (NSString *)HTTPMethodFromDataRequestMethod:(SFSDataRequestMethod)method
{
    switch (method)
    {
        case SFSDataRequestMethodGET:
            return @"GET";
        case SFSDataRequestMethodPOST:
            return @"POST";
        case SFSDataRequestMethodDELETE:
            return @"DELETE";
        case SFSDataRequestMethodHEAD:
            return @"HEAD";
        case SFSDataRequestMethodPATCH:
            return @"PATCH";
        case SFSDataRequestMethodPUT:
            return @"PUT";
        default:
        {
            NSAssert(NO, @"%li is not a valid method", method);
            return nil;
        }
    }
}

- (NSData *)HTTPBodyDataFromObjectIfNecessary:(id)object
{
    NSData *data = nil;
    if (object)
    {
        if (self.requestSerializer)
        {
            if ([self.requestSerializer canSerializeObject:object])
            {
                data = [self.requestSerializer bodyDataFromObject:object];
            }
            else
            {
                NSAssert(NO, @"Serializer %@ cannot serialize object %@", self.requestSerializer, object);
            }
        }
        else if ([object isKindOfClass:[NSData class]])
        {
            data = object;
        }
        else
        {
            NSAssert(NO, @"No request serializer exists and object %@ is not NSData", object);
        }
    }
    return data;
}

// Consider implementing method to upgrade data tasks to download tasks
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    SFSDataFetchTask *fetchTask = self.requestMappings[dataTask];
    self.requestMappings[dataTask] = nil;
    
    if (fetchTask.completionBlock)
    {
        id response = data;
        NSError *error = nil;
        if (self.responseSerializer)
        {
            response = [self.responseSerializer objectFromData:data error:&error];
        }
        fetchTask.completionBlock(response, error);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    SFSDataFetchTask *fetchTask = self.requestMappings[task];
    self.requestMappings[task] = nil;
    
    if (fetchTask.completionBlock)
    {
        fetchTask.completionBlock(nil, error);
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
