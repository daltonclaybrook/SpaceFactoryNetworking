//
//  SFSDataResponseFactory.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSDataResponse.h"

@interface SFSDataResponseFactory : NSObject

- (SFSDataResponse *)dataResponseForTask:(NSURLSessionTask *)task object:(id)object error:(NSError *)error;
- (void)registerUnderlyingError:(NSString *)error forHTTPDetailStatus:(SFSDataManagerHTTPDetailStatus)status;

@end
