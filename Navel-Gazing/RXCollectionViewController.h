//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import UIKit;

#import "RXCollection.h"
#import "RXViewModel.h"

@protocol RXCollectionViewControllerDataSource;

@interface RXCollectionViewController : UITableViewController

@property (nonatomic, readonly) id<RXCollection> collection;

//@property (nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) IBOutlet id<RXViewModel> viewModel;

@property (nonatomic, copy) NSString *defaultReuseIdentifier;
@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

@property (nonatomic, weak) IBOutlet id<RXCollectionViewControllerDataSource> dataSource;

@end

@protocol RXCollectionViewControllerDataSource <NSObject>

-(id<RXCollection>)collectionForCollectionViewController:(RXCollectionViewController *)collectionViewController;

@end
