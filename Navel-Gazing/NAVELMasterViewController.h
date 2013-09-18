//
//  NAVELMasterViewController.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NAVELDetailViewController;

#import <CoreData/CoreData.h>

@interface NAVELMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NAVELDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
