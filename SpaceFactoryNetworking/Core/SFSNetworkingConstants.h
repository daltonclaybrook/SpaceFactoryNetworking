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

// Errors
extern NSString * const SFSDataManagerErrorDomain;