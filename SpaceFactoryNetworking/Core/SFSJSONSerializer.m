//
//  SFSJSONSerializer.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSJSONSerializer.h"

@implementation SFSJSONSerializer

#pragma mark - SFSRequestSerialization

- (BOOL)canSerializeObject:(id)object
{
    return [NSJSONSerialization isValidJSONObject:object];
}

- (NSData *)bodyDataFromObject:(id)object
{
    if (![self canSerializeObject:object])
    {
        NSAssert(NO, @"Object %@ cannot be serialized into JSON", object);
        return nil;
    }
    
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
}

#pragma mark - SFSResponseSerialization

- (id)objectFromData:(NSData *)data error:(out NSError *__autoreleasing*)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

@end
