//
//  SFSFileManagerConstants.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const SFSFileManagerNoDiskSizeLimit;
extern NSString * const SFSFileManagerDefaultFileGroup;

typedef void(^SFSFileManagerCompletion)(NSURL *fileURL, NSError *error);
typedef void(^SFSDataManagerCompletion)(id response, NSError *error);

typedef NS_ENUM(NSInteger, SFSDataManagerHTTPStatus)
{
    SFSDataManagerHTTPStatusUnknown = 0,
    SFSDataManagerHTTPStatusSuccess = 200,
    SFSDataManagerHTTPStatusRedirection = 300,
    SFSDataManagerHTTPStatusClientError = 400,
    SFSDataManagerHTTPStatusServerError = 500
};

/** Many HTTP response condes that are not required are not supported here. These codes will be SFSDataManagerHTTPDetailStatusUnknown
 *
 */
typedef NS_ENUM(NSInteger, SFSDataManagerHTTPDetailStatus)
{
    SFSDataManagerHTTPDetailStatusUnknown = 0,
    
    //  Success
    
    SFSDataManagerHTTPDetailStatusOK = 200,
    SFSDataManagerHTTPDetailStatusCreated = 201,
    SFSDataManagerHTTPDetailStatusAccepted = 202,
    SFSDataManagerHTTPDetailStatusNoContent = 204,
    SFSDataManagerHTTPDetailStatusResetContent = 205,
    SFSDataManagerHTTPDetailStatusPartialContent = 206,
    
    // Redirect
    
    SFSDataManagerHTTPDetailStatusMultipleChoices = 300,
    SFSDataManagerHTTPDetailStatusMovedPermanently = 301,
    SFSDataManagerHTTPDetailStatusNotModified = 304,
    
    // Client Error
    
    SFSDataManagerHTTPDetailStatusBadRequest = 400,
    SFSDataManagerHTTPDetailStatusUnauthorized = 401,
    SFSDataManagerHTTPDetailStatusForbidden = 403,
    SFSDataManagerHTTPDetailStatusNotFound = 404,
    SFSDataManagerHTTPDetailStatusNotAcceptable = 406,
    // I like 410. It's much more informative than 404.
    SFSDataManagerHTTPDetailStatusGone = 410,
    SFSDataManagerHTTPDetailStatusLengthRequired = 411,
    
    // Server Error
    
    SFSDataManagerHTTPDetailStatusInternalServerError = 500,
    SFSDataManagerHTTPDetailStatusNotImplemented = 501,
    SFSDataManagerHTTPDetailStatusBadGateway = 502,
    SFSDataManagerHTTPDetailStatusServiceUnavailable = 503,
    SFSDataManagerHTTPDetailStatusGatewayTimeout = 504
};

// Errors
extern NSString * const SFSDataManagerErrorDomain;