//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXCollection <NSObject>

@property (nonatomic, readonly) NSArray *members;

-(id)memberAtIndexPath:(NSIndexPath *)indexPath;

/**
 KVO-compliant.
 */
@property (nonatomic, readonly) NSSet *changes;

@end


@interface RXFetchedCollection : NSObject <RXCollection>

@property (nonatomic) NSFetchRequest *request;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic, readonly) NSError *fetchError;

@end
