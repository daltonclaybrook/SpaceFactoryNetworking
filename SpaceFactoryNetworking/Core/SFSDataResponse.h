//
//  SFSDataResponse.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"

@interface SFSDataResponse : NSObject

@property (nonatomic, assign, readonly) SFSDataManagerHTTPStatus httpStatus;
@property (nonatomic, assign, readonly) SFSDataManagerHTTPDetailStatus httpDetailStatus;
@property (nonatomic, strong, readonly) id responseObject;

@property (nonatomic, strong, readonly) NSError *error;

+ (instancetype)responseWithStatus:(SFSDataManagerHTTPStatus)status detail:(SFSDataManagerHTTPDetailStatus)detail responseObject:(id)object error:(NSError *)error;

@end
