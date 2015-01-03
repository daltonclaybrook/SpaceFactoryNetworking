//
//  SFSXMLSerializer.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSRequestSerialization.h"
#import "SFSResponseSerialization.h"

@interface SFSXMLSerializer : NSObject <SFSRequestSerialization, SFSResponseSerialization>

@end
