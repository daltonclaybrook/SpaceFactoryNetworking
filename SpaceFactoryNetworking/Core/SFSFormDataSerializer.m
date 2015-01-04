//
//  SFSFormDataSerializer.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/4/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSFormDataSerializer.h"

static NSUInteger const kBoundaryLength = 16;
static NSString * const kNewlineString = @"\r\n";

@interface SFSFormDataSerializer ()

@property (nonatomic, copy) NSString *boundaryString;

@end

@implementation SFSFormDataSerializer

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self SFSFormDataSerializerCommonInit];
    }
    return self;
}

- (void)SFSFormDataSerializerCommonInit
{
    _boundaryString = [self createBoundaryString];
}

#pragma mark - SFSRequestSerialization

- (NSString *)contentType
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundaryString];
}

- (BOOL)canSerializeObject:(id)object
{
    BOOL canSerialize = NO;
    if ([object isKindOfClass:[NSDictionary class]])
    {
        canSerialize = YES;
        NSDictionary *dict = object;
        
        for (NSString *key in [dict keyEnumerator])
        {
            NSString *value = dict[key];
            if (![key isKindOfClass:[NSString class]] ||
                ![value isKindOfClass:[NSString class]])
            {
                canSerialize = NO;
                break;
            }
        }
    }
    return canSerialize;
}

- (NSData *)bodyDataFromObject:(id)object
{
    if (![self canSerializeObject:object])
    {
        NSAssert(NO, @"Cannot serialize object: %@", object);
        return nil;
    }
    
    NSDictionary *dict = object;
    NSMutableData *formData = [NSMutableData data];
    
    [self addBoundaryToData:formData];
    for (NSString *key in [dict keyEnumerator])
    {
        NSString *value = dict[key];
        [self addKey:key value:value toData:formData];
        [self addBoundaryToData:formData];
    }
    
    return [formData copy];
}

#pragma mark - Private

- (void)addBoundaryToData:(NSMutableData *)data
{
    NSString *string = [NSString stringWithFormat:@"\r\n--%@\r\n", self.boundaryString];
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)addKey:(NSString *)key value:(NSString *)value toData:(NSMutableData *)data
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value];
    
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)createBoundaryString
{
    NSString *characters = @"0123456789abcdef";
    NSMutableString *boundarySuffix = [NSMutableString string];
    for (NSUInteger i=0; i<kBoundaryLength; i++)
    {
        NSUInteger index = arc4random_uniform((u_int32_t)characters.length);
        [boundarySuffix appendString:[characters substringWithRange:NSMakeRange(index, 1)]];
    }
    return [@"SFSNetworing--" stringByAppendingString:boundarySuffix];
}

@end
