//
//  SFSFormFieldCollectionViewCell.h
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/4/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSFormDataField.h"

extern NSString * const SFSFormFieldCollectionViewCellReuseID;

@protocol SFSFormFieldCollectionViewCellDelegate;

@interface SFSFormFieldCollectionViewCell : UICollectionViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id<SFSFormFieldCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) SFSFormDataField *dataField;

@property (nonatomic, weak) IBOutlet UITextField *keyField;
@property (nonatomic, weak) IBOutlet UITextField *valueField;

- (IBAction)deleteButtonPressed:(id)sender;

@end

@protocol SFSFormFieldCollectionViewCellDelegate <NSObject>

- (void)cellDidFinishEditing:(SFSFormFieldCollectionViewCell *)cell;
- (void)cellShouldBeDeleted:(SFSFormFieldCollectionViewCell *)cell;

@end
