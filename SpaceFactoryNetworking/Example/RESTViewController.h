//
//  RESTViewController.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/3/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESTViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak) IBOutlet UICollectionView *formFieldCollectionView;
@property (nonatomic, weak) IBOutlet UITextView *jsonTextView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *contentTypeSegment;

- (IBAction)contentTypeSegmentValueChanged:(UISegmentedControl *)sender;

@end
