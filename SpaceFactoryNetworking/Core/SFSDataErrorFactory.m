//
//  SFSDataErrorFactory.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 2/15/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSDataErrorFactory.h"
#import "SFSNetworkingConstants.h"

@implementation SFSDataErrorFactory

#pragma mark - Public

- (NSError *)errorForTask:(NSURLSessionTask *)task
{
    NSError *error = nil;
    NSHTTPURLResponse *response = (id)task.response;
    switch (response.statusCode)
    {
        case 200:
        {
            // no-op
            break;
        }
        case 401:
        {
            error = [self error401];
            break;
        }
        default:
        {
            error = [self unknownErrorWithCode:response.statusCode];
            break;
        }
    }
    return error;
}

#pragma mark - Private

- (NSError *)error401
{
    return [self errorWithCode:401 message:@"You are not authorized to make this request"];
}

- (NSError *)unknownErrorWithCode:(NSInteger)statusCode
{
    NSString *message = [NSString stringWithFormat:@"An unknown error occurred (%li)", statusCode];
    return [self errorWithCode:statusCode message:message];
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : message };
    return [NSError errorWithDomain:SFSDataManagerErrorDomain code:code userInfo:userInfo];
}

@end
