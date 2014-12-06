//
//  ViewController.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "ViewController.h"
#import "SFSFileManager.h"

@interface ViewController ()

@property (nonatomic, strong) SFSFileManager *fileManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0.5 GB
//    NSUInteger fileSize = 0.5 * 1024.0 * 1024.0 * 1024.0;
//    NSString *urlString = [NSString stringWithFormat:@"https://datautility.herokuapp.com/jibberishblob/ofsize/%lu", (unsigned long)fileSize];
    NSString *urlString = @"http://toplist.xyz/wp-content/uploads/2014/08/Landscape.jpg";
    
    self.fileManager = [[SFSFileManager alloc] init];
    self.fileManager.usesEncryptionByDefault = YES;
    
    id<SFSTask> task = [self.fileManager fetchFileDataAtURL:[NSURL URLWithString:urlString] withCompletion:^(NSURL *fileURL, NSError *error) {
        
        NSLog(@"");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"task: %@", task);
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

@end
