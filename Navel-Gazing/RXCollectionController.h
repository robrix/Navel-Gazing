//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXPromise.h"

@interface RXCollectionController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *sortKey;

@property (nonatomic, copy) NSString *defaultReuseIdentifier;
@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

@end
