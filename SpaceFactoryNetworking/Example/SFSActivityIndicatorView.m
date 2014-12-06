//
//  SFSActivityIndicatorView.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/6/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "SFSActivityIndicatorView.h"

@interface SFSActivityIndicatorView ()

@property (nonatomic, assign) NSInteger stackCount;

@end

@implementation SFSActivityIndicatorView

- (void)startAnimating
{
    self.stackCount++;
    if (self.stackCount == 1)
    {
        [super startAnimating];
    }
    NSLog(@"start: %li", (long)self.stackCount);
}

- (void)stopAnimating
{
    self.stackCount--;
    if (self.stackCount <= 0)
    {
        self.stackCount = 0;
        if ([self isAnimating])
        {
            [super stopAnimating];
        }
    }
    NSLog(@"stop: %li", (long)self.stackCount);
}

@end
