//
//  ViewController.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 12/5/14.
//  Copyright (c) 2014 Space Factory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)evictButtonPressed:(id)sender;
- (IBAction)fetchButtonPressed:(id)sender;
- (IBAction)segmentValueChanged:(id)sender;

@end

