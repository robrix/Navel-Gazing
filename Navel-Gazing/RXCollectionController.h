//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXPromise.h"

@interface RXCollectionController : NSObject <UITableViewDataSource, UITableViewDelegate>

/**
 @param request The request to track.
 @param context The context to perform the fetches within. Must have main queue or private queue concurrency type.
 */
//-(instancetype)initWithFetchRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context;

//@property (nonatomic, copy) NSString *entityName;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UITableViewCell *defaultCellPrototype;

@property (nonatomic, copy) NSString *reuseIdentifierKeyPath;

-(id<RXPromise>)collectionPromise;

@end
