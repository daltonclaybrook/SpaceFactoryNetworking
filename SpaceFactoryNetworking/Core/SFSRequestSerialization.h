//
//  SFSRequestSerialization.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSRequestSerialization <NSObject>

- (BOOL)canSerializeObject:(id)object;

/**
 *  This method will throw an exception if object cannot be serialized
 */
- (NSData *)bodyDataFromObject:(id)object;

@end
