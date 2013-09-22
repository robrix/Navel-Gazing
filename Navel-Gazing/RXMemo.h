//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMemoDependency.h"

/**
 Implements an invalidatable memoized value.
 */
@interface RXMemo : NSObject <RXMemoDependency>

+(instancetype)memoWithTarget:(id)target ignoreNilValues:(bool)ignoresNilValues block:(id(^)(id target))block;
+(instancetype)memoWithTarget:(id)target block:(id(^)(id target))block;

@property (nonatomic, weak, readonly) id target;

@property (nonatomic, readonly) bool ignoresNilValues;

/**
 If `YES`, evaluate when invalidated (greedily).
 If `NO`, evaluate when its value is taken (lazily).
 
 Defaults to `NO`.
 */
@property (nonatomic, getter = isGreedy) bool greedy;

/**
 An array of `RXMemoDependency`-conformant objects changes to which should invalidate this memo.
 */
@property (nonatomic) NSArray *dependencies;

-(void)invalidate;

/**
 Evaluates the memo if necessary.
 */
-(void)evaluate;

/**
 Returns the value of the memo.
 
 KVO-compliant.
 */
@property (nonatomic, readonly) id value;

@end
