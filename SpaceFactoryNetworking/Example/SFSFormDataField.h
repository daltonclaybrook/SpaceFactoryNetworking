//
//  SFSFormDataField.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/4/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSFormDataField : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

+ (instancetype)dataField;

@end
