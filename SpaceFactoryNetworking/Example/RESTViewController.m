//
//  RESTViewController.m
//  SpaceFactoryNetworking
//
//  Created by Dalton Claybrook on 1/3/15.
//  Copyright (c) 2015 Space Factory Studios. All rights reserved.
//

#import "RESTViewController.h"
#import "SFSDataManager.h"
#import "SFSFormDataSerializer.h"
#import "SFSJSONSerializer.h"
#import "SFSFormDataField.h"
#import "SFSFormFieldCollectionViewCell.h"

static NSString * const kBaseURLSring = @"http://simpleapiapp.azurewebsites.net/api/farmanimals/";
static NSString * const kAddCellReuseID = @"kAddCellReuseID";

@interface RESTViewController () <SFSFormFieldCollectionViewCellDelegate>

@property (nonatomic, strong) SFSDataManager *dataManager;
@property (nonatomic, copy) NSArray *animalPaths;
@property (nonatomic, copy) NSArray *requestSerializers;
@property (nonatomic, strong) NSMutableArray *keyValuePairs;

@property (nonatomic, strong) NSIndexPath *nextIndexPath;

@end

@implementation RESTViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animalPaths = [self createAnimalPaths];
    
    [self setupSegmentedControl];

    UICollectionViewFlowLayout *layout = (id)self.formFieldCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds)-32.0f, layout.itemSize.height);
    
    NSURL *baseURL = [NSURL URLWithString:kBaseURLSring];
    self.dataManager = [[SFSDataManager alloc] initWithBaseURL:baseURL];
    
    self.keyValuePairs = [NSMutableArray arrayWithObject:[SFSFormDataField dataField]];
    [self.formFieldCollectionView reloadData];
}

#pragma mark - Actions

- (IBAction)contentTypeSegmentValueChanged:(UISegmentedControl *)sender
{
    self.dataManager.requestSerializer = self.requestSerializers[sender.selectedSegmentIndex];
    
    if (sender.selectedSegmentIndex == 0)
    {
        // form-data
        self.formFieldCollectionView.hidden = NO;
        self.jsonTextView.hidden = YES;
    }
    else
    {
        // json
        self.formFieldCollectionView.hidden = YES;
        self.jsonTextView.hidden = NO;
    }
}

#pragma mark - Private

- (void)setupSegmentedControl
{
    self.requestSerializers = [self createSerializers];
    [self.contentTypeSegment removeAllSegments];
    
    [self.requestSerializers enumerateObjectsUsingBlock:^(id<SFSRequestSerialization> serializer, NSUInteger idx, BOOL *stop) {
        
        [self.contentTypeSegment insertSegmentWithTitle:[serializer contentType] atIndex:idx animated:NO];
    }];
    
    self.contentTypeSegment.selectedSegmentIndex = 0;
    [self contentTypeSegmentValueChanged:self.contentTypeSegment];
}

- (NSArray *)createAnimalPaths
{
    return @[ @"sheep",
              @"cow",
              @"horse" ];
}

- (NSArray *)createSerializers
{
    return @[ [[SFSFormDataSerializer alloc] init],
              [[SFSJSONSerializer alloc] init] ];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.keyValuePairs.count;
    }
    else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (indexPath.section == 0) ? SFSFormFieldCollectionViewCellReuseID : kAddCellReuseID;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        SFSFormFieldCollectionViewCell *formCell = (id)cell;
        formCell.dataField = self.keyValuePairs[indexPath.item];
        formCell.delegate = self;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SFSFormFieldCollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
        
        [cell.keyField becomeFirstResponder];
    }
    else
    {
        [self.formFieldCollectionView performBatchUpdates:^{
            
            [self.keyValuePairs addObject:[SFSFormDataField dataField]];
            [self.formFieldCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.keyValuePairs.count-1 inSection:0]]];
        } completion:^(BOOL finished) {
            
            [self.formFieldCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }];
        [self.formFieldCollectionView reloadData];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.nextIndexPath)
    {
        SFSFormFieldCollectionViewCell *nextCell = (id)[self.formFieldCollectionView cellForItemAtIndexPath:self.nextIndexPath];
        [nextCell.keyField becomeFirstResponder];
        
        self.nextIndexPath = nil;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.animalPaths.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.animalPaths[row];
}

#pragma mark - SFSFormFieldCollectionViewCellDelegate

- (void)cellDidFinishEditing:(SFSFormFieldCollectionViewCell *)cell
{
    NSIndexPath *path = [self.formFieldCollectionView indexPathForCell:cell];
    if (path.item < self.keyValuePairs.count-1)
    {
        self.nextIndexPath = [NSIndexPath indexPathForItem:path.item+1 inSection:0];
        
        [self.formFieldCollectionView scrollToItemAtIndexPath:self.nextIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    else
    {
        [cell.valueField resignFirstResponder];
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:1];
        [self.formFieldCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

- (void)cellShouldBeDeleted:(SFSFormFieldCollectionViewCell *)cell
{
    NSIndexPath *path = [self.formFieldCollectionView indexPathForCell:cell];
    
    [self.formFieldCollectionView performBatchUpdates:^{
        
        [self.keyValuePairs removeObjectAtIndex:path.item];
        [self.formFieldCollectionView deleteItemsAtIndexPaths:@[path]];
    } completion:nil];
}

@end
