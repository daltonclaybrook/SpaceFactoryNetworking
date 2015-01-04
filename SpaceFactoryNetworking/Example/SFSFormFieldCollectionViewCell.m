//
//  SFSFormFieldCollectionViewCell.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/4/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "SFSFormFieldCollectionViewCell.h"

NSString * const SFSFormFieldCollectionViewCellReuseID = @"SFSFormFieldCollectionViewCellReuseID";

@implementation SFSFormFieldCollectionViewCell

#pragma mark - Accessors

- (void)setDataField:(SFSFormDataField *)dataField
{
    if (_dataField == dataField)
    {
        return;
    }
    _dataField = dataField;
}

#pragma mark - Actions

- (IBAction)deleteButtonPressed:(id)sender
{
    [self.delegate cellShouldBeDeleted:self];
}

#pragma mark - Private

- (void)configureWithDataField:(SFSFormDataField *)dataField
{
    self.keyField.text = dataField.key;
    self.valueField.text = dataField.value;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.keyField isFirstResponder])
    {
        [self.valueField becomeFirstResponder];
    }
    else
    {
        [self.delegate cellDidFinishEditing:self];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *fullString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.keyField)
    {
        self.dataField.key = fullString;
    }
    else
    {
        self.dataField.value = fullString;
    }
    
    return YES;
}

@end
