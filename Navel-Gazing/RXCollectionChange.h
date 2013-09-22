//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;
@import UIKit;

@protocol RXCollectionChange <NSObject>

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;

@property (nonatomic, readonly) NSIndexPath *indexPath;

-(void)applyToTableView:(UITableView *)tableView;

@end

id<RXCollectionChange> RXCollectionChangeWithType(NSFetchedResultsChangeType type, NSIndexPath *indexPath, NSIndexPath *newIndexPath);


@interface RXCollectionInsertion : NSObject <RXCollectionChange>
@end


@interface RXCollectionUpdate : NSObject <RXCollectionChange>
@end


@interface RXCollectionMove : NSObject <RXCollectionChange>

@property (nonatomic, readonly) NSIndexPath *destinationIndexPath;

@end


@interface RXCollectionDeletion : NSObject <RXCollectionChange>
@end
