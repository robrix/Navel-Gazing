//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXPromise.h"

@interface RXCollectionController : UIResponder <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

@end
