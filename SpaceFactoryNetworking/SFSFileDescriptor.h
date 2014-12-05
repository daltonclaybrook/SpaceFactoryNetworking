//
//  SFSFileDescriptor.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSFileDescriptor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *fileGroup;
@property (nonatomic, assign) NSUInteger fileURLComponent;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) BOOL encrypted;
@property (nonatomic, assign) BOOL awaitingEncryption;
@property (nonatomic, strong) NSDate *lastAccessDate;

- (NSURL *)fileURLWithBaseComponent:(NSString *)base;
- (NSURL *)fileURLWithBaseComponent:(NSString *)base fileGroup:(NSString *)group;

@end
