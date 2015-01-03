//
//  SFSXMLSerializer.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/26/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSXMLSerializer.h"

@interface SFSXMLSerializer () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, assign) BOOL parsing;

@end

@implementation SFSXMLSerializer

#pragma mark - SFSRequestSerialization

#pragma mark - SFSResponseSerialization

- (id)objectFromData:(NSData *)data error:(out NSError *__autoreleasing *)error
{
    if (!data.length || self.parsing)
    {
        NSAssert(NO, @"Data %@ is empty, or already parsing", [data description]);
        return nil;
    }
    
    self.parsing = YES;
    self.xmlParser = [[NSXMLParser alloc] initWithData:data];
    self.xmlParser.delegate = self;
    [self.xmlParser parse];
    
#warning complete parser
    return nil;
}

#pragma mark - NSXMLParserDelegate



@end
