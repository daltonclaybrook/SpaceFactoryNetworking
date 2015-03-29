//
//  SFSDataError.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"

@interface SFSDataError : NSError

@property (nonatomic, assign, readonly) SFSDataManagerHTTPStatus httpStatus;
@property (nonatomic, assign, readonly) SFSDataManagerHTTPDetailStatus httpDetailStatus;

- (instancetype)initWithStatus:(SFSDataManagerHTTPStatus)status detail:(SFSDataManagerHTTPDetailStatus)detail userInfo:(NSDictionary *)userInfo;

@end
