//
//  SFSDataErrorFactory.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 2/15/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSDataErrorFactory : NSObject

- (NSError *)errorForTask:(NSURLSessionTask *)task;

@end
