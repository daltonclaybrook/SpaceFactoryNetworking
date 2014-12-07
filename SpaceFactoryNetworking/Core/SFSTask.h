//
//  SFSTask.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/6/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSTask <NSObject>

@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

- (void)cancelRequest;
- (void)ignoreResults;

@end
