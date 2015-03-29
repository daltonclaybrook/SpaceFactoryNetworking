//
//  SFSDataResponseFactory.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSDataResponseFactory.h"

@interface SFSDataResponseFactory()

@property (nonatomic, strong) NSMutableDictionary *registeredErrors;

@end

@implementation SFSDataResponseFactory

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _registeredErrors = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public

- (SFSDataResponse *)dataResponseForTask:(NSURLSessionTask *)task object:(id)object error:(NSError *)error
{
    NSHTTPURLResponse *response = (id)task.response;
    
    SFSDataManagerHTTPStatus status = [self httpStatusFromCode:response.statusCode];
    SFSDataManagerHTTPDetailStatus detailStatus = [self httpDetailStatusFromCode:response.statusCode];
    NSString *errorString = self.registeredErrors[@(detailStatus)];
    
    NSError *finalError = error;
    if (errorString.length)
    {
        finalError = [NSError errorWithDomain:SFSDataManagerErrorDomain code:detailStatus userInfo:@{NSLocalizedDescriptionKey : errorString}];
    }
    return [SFSDataResponse responseWithStatus:status detail:detailStatus responseObject:object error:error];
}

- (void)registerUnderlyingError:(NSString *)error forHTTPDetailStatus:(SFSDataManagerHTTPDetailStatus)status
{
    if (!error.length)
    {
        NSAssert(NO, @"Attempted to register a blank string: %@", NSStringFromSelector(_cmd));
        return;
    }
    
    self.registeredErrors[@(status)] = [error copy];
}

#pragma mark - Private

- (SFSDataManagerHTTPStatus)httpStatusFromCode:(NSInteger)statusCode
{
    NSString *statusString = [NSString stringWithFormat:@"%li", (long)statusCode];
    NSInteger trimmedCode = [[statusString substringToIndex:1] integerValue];
    SFSDataManagerHTTPStatus status;
    
    switch (trimmedCode)
    {
        case 2:
        {
            status = SFSDataManagerHTTPStatusSuccess;
            break;
        }
        case 3:
        {
            status = SFSDataManagerHTTPStatusRedirection;
            break;
        }
        case 4:
        {
            status = SFSDataManagerHTTPStatusClientError;
            break;
        }
        case 5:
        {
            status = SFSDataManagerHTTPStatusServerError;
            break;
        }
        default:
        {
            status = SFSDataManagerHTTPStatusUnknown;
            break;
        }
    }
    return status;
}

- (SFSDataManagerHTTPDetailStatus)httpDetailStatusFromCode:(NSInteger)statusCode
{
    SFSDataManagerHTTPDetailStatus status;
    switch (statusCode)
    {
        case SFSDataManagerHTTPDetailStatusOK:
        case SFSDataManagerHTTPDetailStatusCreated:
        case SFSDataManagerHTTPDetailStatusAccepted:
        case SFSDataManagerHTTPDetailStatusNoContent:
        case SFSDataManagerHTTPDetailStatusResetContent:
        case SFSDataManagerHTTPDetailStatusPartialContent:
        case SFSDataManagerHTTPDetailStatusMultipleChoices:
        case SFSDataManagerHTTPDetailStatusMovedPermanently:
        case SFSDataManagerHTTPDetailStatusNotModified:
        case SFSDataManagerHTTPDetailStatusBadRequest:
        case SFSDataManagerHTTPDetailStatusUnauthorized:
        case SFSDataManagerHTTPDetailStatusForbidden:
        case SFSDataManagerHTTPDetailStatusNotFound:
        case SFSDataManagerHTTPDetailStatusNotAcceptable:
        case SFSDataManagerHTTPDetailStatusGone:
        case SFSDataManagerHTTPDetailStatusLengthRequired:
        case SFSDataManagerHTTPDetailStatusInternalServerError:
        case SFSDataManagerHTTPDetailStatusNotImplemented:
        case SFSDataManagerHTTPDetailStatusBadGateway:
        case SFSDataManagerHTTPDetailStatusServiceUnavailable:
        case SFSDataManagerHTTPDetailStatusGatewayTimeout:
        {
            status = statusCode;
            break;
        }
        default:
        {
            status = SFSDataManagerHTTPDetailStatusUnknown;
            break;
        }
    }
    return status;
}

@end
