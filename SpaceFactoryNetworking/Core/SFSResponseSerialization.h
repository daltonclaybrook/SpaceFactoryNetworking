//
//  SFSResponseSerialization.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSResponseSerialization <NSObject>

- (id)objectFromData:(NSData *)data error:(out NSError *__autoreleasing*)error;

@end
