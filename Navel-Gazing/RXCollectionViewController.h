//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import UIKit;

#import "RXCollection.h"
#import "RXViewModel.h"

@interface RXCollectionViewController : UITableViewController

@property (nonatomic) IBOutlet id<RXCollection> collection;

//@property (nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) IBOutlet id<RXViewModel> viewModel;

@property (nonatomic, copy) NSString *defaultReuseIdentifier;
@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

@end
