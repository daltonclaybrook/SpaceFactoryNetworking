//
//  SFSDataErrorFactory.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 2/15/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSNetworkingConstants.h"

@class SFSDataError;

@interface SFSDataErrorFactory : NSObject

- (SFSDataError *)dataErrorForTask:(NSURLSessionTask *)task;
- (void)registerUnderlyingError:(NSString *)error forHTTPDetailStatus:(SFSDataManagerHTTPDetailStatus)status;

@end
