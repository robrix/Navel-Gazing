//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import UIKit;

#import "RXCollection.h"
#import "RXViewModel.h"

@protocol RXCollectionViewControllerDataSource;
@protocol RXCollectionViewControllerDelegate;

@interface RXCollectionViewController : UITableViewController

@property (nonatomic, readonly) id<RXCollection> collection;

@property (nonatomic) IBOutlet id<RXViewModel> viewModel;

@property (nonatomic, copy) NSString *defaultReuseIdentifier;
@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

@property (nonatomic) IBOutlet id<RXCollectionViewControllerDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<RXCollectionViewControllerDelegate> delegate;

@end

@protocol RXCollectionViewControllerDataSource <NSObject>

-(id<RXCollection>)collectionForCollectionViewController:(RXCollectionViewController *)collectionViewController;

@end

@protocol RXCollectionViewControllerDelegate <NSObject>

-(void)collectionViewController:(RXCollectionViewController *)controller prepareForSegue:(UIStoryboardSegue *)segue withModelObject:(id)modelObject;

@end
