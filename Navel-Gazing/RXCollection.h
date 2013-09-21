//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXCollection <NSObject>

@property (nonatomic, readonly) NSArray *members;

/**
 KVO-compliant.
 */
@property (nonatomic, readonly) NSSet *changes;

@end


@interface RXFetchedCollection : NSObject <RXCollection>

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *sortKey;

@property (nonatomic, readonly) NSError *fetchError;

@end
