//
//  ViewController.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import "ImageViewController.h"
#import "SFSFileManager.h"
#import "SFSImageManager.h"

@interface ImageViewController ()

@property (nonatomic, strong) SFSFileManager *fileManager;
@property (nonatomic, strong) SFSImageManager *imageManager;
@property (nonatomic, copy) NSArray *imageURLs;

@property (nonatomic, weak) id<SFSTask> currentTask;

@end

@implementation ImageViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageURLs = [self createImageURLs];
    
    self.imageManager = [[SFSImageManager alloc] init];
    self.imageManager.backingFileManager.usesEncryptionByDefault = YES;
    
    self.fileManager = [[SFSFileManager alloc] init];
    self.fileManager.usesEncryptionByDefault = NO;
    
    [self setupSegmentedControl];
}

#pragma mark - Actions

- (IBAction)evictButtonPressed:(id)sender
{
    [self.imageManager.backingFileManager evictAllFiles];
    self.imageView.image = nil;
    
    [self updateStatus:@"Eviction"];
}

- (IBAction)fetchButtonPressed:(id)sender
{
    [self fetchImageIfNecessary];
}

- (IBAction)segmentValueChanged:(id)sender
{
    [self fetchImageIfNecessary];
}

#pragma mark - Private

- (NSArray *)createImageURLs
{
    return @[ [NSURL URLWithString:@"https://placekitten.com/1050/1000"],
              [NSURL URLWithString:@"https://placekitten.com/1100/1000"],
              [NSURL URLWithString:@"https://placekitten.com/1170/1000"],
              [NSURL URLWithString:@"https://placekitten.com/1200/1000"],
              [NSURL URLWithString:@"https://placekitten.com/1250/1000"],
              [NSURL URLWithString:@"https://placekitten.com/1300/1000"] ];
}

- (void)setupSegmentedControl
{
    [self.segmentedControl removeAllSegments];
    [self.imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.segmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%lu", (unsigned long)idx+1] atIndex:idx animated:NO];
    }];
}

- (void)fetchImageIfNecessary
{
    [self prepareToSwitchImage];
    
    NSUInteger index = MAX(self.segmentedControl.selectedSegmentIndex, 0);
    NSURL *url = self.imageURLs[index];
    UIImage *image = [self.imageManager existingImageForIdentifier:[url absoluteString]];
    if (image)
    {
        self.imageView.image = image;
        [self updateStatus:@"Image exists"];
    }
    else
    {
        [self fetchImageForSegment:index];
        [self updateStatus:@"Fetching image..."];
    }
}

- (void)prepareToSwitchImage
{
    [self.loadingIndicator stopAnimating];
    
    // we are initiating a new fetch. we no longer care about the results of the old fetch, but we do want the request to continue so the image will become cached. If we happen to be starting a fetch that is identical to a currently running fetch, our completion block will become associated with that request.
    [self.currentTask ignoreResults];
    self.currentTask = nil;
}

- (void)fetchImageForSegment:(NSInteger)segment
{
    self.imageView.image = nil;
    [self.loadingIndicator startAnimating];
    
    segment = MAX(segment, 0);
    NSURL *url = self.imageURLs[segment];
    
    __typeof__(self) __weak weakSelf = self;
    self.currentTask = [self.imageManager fetchImageAtURL:url withCompletion:^(UIImage *image, NSError *error) {
        
        [weakSelf.loadingIndicator stopAnimating];
        if (error)
        {
            [weakSelf updateStatus:@"Error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[NSUnderlyingErrorKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self updateStatus:@"Complete"];
            weakSelf.imageView.image = image;
        }
    }];
}

- (void)updateStatus:(NSString *)status
{
    // callbacks from the image manager are intended to occur on the main thread. If a status changes, but other UI is not updated, we are probably updating UI on a background thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = status;
    });
}

@end