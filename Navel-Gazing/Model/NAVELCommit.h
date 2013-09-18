//
//  NAVELCommit.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NAVELBranch, NAVELCommit, NAVELPerson;

@interface NAVELCommit : NSManagedObject

@property (nonatomic) NSTimeInterval dateAuthored;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic, retain) NAVELPerson *author;
@property (nonatomic, retain) NSSet *branches;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSSet *parents;
@end

@interface NAVELCommit (CoreDataGeneratedAccessors)

- (void)addBranchesObject:(NAVELBranch *)value;
- (void)removeBranchesObject:(NAVELBranch *)value;
- (void)addBranches:(NSSet *)values;
- (void)removeBranches:(NSSet *)values;

- (void)addChildrenObject:(NAVELCommit *)value;
- (void)removeChildrenObject:(NAVELCommit *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addParentsObject:(NAVELCommit *)value;
- (void)removeParentsObject:(NAVELCommit *)value;
- (void)addParents:(NSSet *)values;
- (void)removeParents:(NSSet *)values;

@end
