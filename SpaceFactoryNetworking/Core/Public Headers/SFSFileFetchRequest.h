//
//  SFSFileFetchRequest.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/7/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SFSFileFetchRequestEncryptionPolicy)
{
    SFSFileFetchRequestEncryptionPolicyDefault,
    SFSFileFetchRequestEncryptionPolicyUseEncryption,
    SFSFileFetchRequestEncryptionPolicyNoEncryption
};

typedef NS_ENUM(NSInteger, SFSFileFetchRequestTaskPriority)
{
    SFSFileFetchRequestTaskPriorityDefault,
    SFSFileFetchRequestTaskPriorityHigh,
    SFSFileFetchRequestTaskPriorityLow
};

@interface SFSFileFetchRequest : NSObject

@property (nonatomic, copy) NSURLRequest *urlRequest;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *fileGroup;
@property (nonatomic, assign) SFSFileFetchRequestEncryptionPolicy encryptionPolicy;
@property (nonatomic, assign) SFSFileFetchRequestTaskPriority taskPriority;

+ (instancetype)request;
+ (instancetype)defaultRequestWithURL:(NSURL *)url;
+ (instancetype)defaultRequestWithURLRequest:(NSURLRequest *)request;

@end
