//
//  SFSDataError.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 3/29/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSDataError.h"

@implementation SFSDataError

- (instancetype)initWithStatus:(SFSDataManagerHTTPStatus)status detail:(SFSDataManagerHTTPDetailStatus)detail userInfo:(NSDictionary *)userInfo
{
    return [super initWithDomain:SFSDataManagerErrorDomain code:detail userInfo:userInfo];
}

@end
