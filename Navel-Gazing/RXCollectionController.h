//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXCollectionController <NSObject>

@property (nonatomic, readonly) NSArray *collection;

@end


#import "RXPromise.h"

@interface RXCollectionController : NSObject

/**
 @param request The request to track.
 @param context The context to perform the fetches within. Must have main queue or private queue concurrency type.
 */
-(instancetype)initWithFetchRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context;

-(id<RXPromise>)collectionPromise;

@end
