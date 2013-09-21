//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

/**
 Implements an invalidatable memoized value.
 */
@interface RXMemo : NSObject

+(instancetype)memoWithTarget:(id)target block:(id(^)(id target))block;

@property (nonatomic, weak, readonly) id target;

-(void)invalidate;

/**
 Evaluates the memo if necessary.
 */
-(void)evaluate;

/**
 Returns the value of the memo.
 */
@property (nonatomic, readonly) id value;

@end
