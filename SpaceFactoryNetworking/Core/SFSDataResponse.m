//
//  SFSDataResponse.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSDataResponse.h"

@interface SFSDataResponse()

@property (nonatomic, assign, readwrite) SFSDataManagerHTTPStatus httpStatus;
@property (nonatomic, assign, readwrite) SFSDataManagerHTTPDetailStatus httpDetailStatus;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation SFSDataResponse

+ (instancetype)responseWithStatus:(SFSDataManagerHTTPStatus)status detail:(SFSDataManagerHTTPDetailStatus)detail responseObject:(id)object error:(NSError *)error
{
    SFSDataResponse *response = [[self alloc] init];
    response.httpStatus = status;
    response.httpDetailStatus = detail;
    response.responseObject = object;
    response.error = error;
    return response;
}

@end
