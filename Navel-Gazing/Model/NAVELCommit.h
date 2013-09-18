//
//  NAVELCommit.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

@import CoreData;

@class NAVELBranch, NAVELCommit, NAVELPerson;

@interface NAVELCommit : NSManagedObject

@property (nonatomic) NSDate *dateAuthored;
@property (nonatomic, copy) NSString *sha1;
@property (nonatomic) NAVELPerson *author;
@property (nonatomic, copy) NSSet *branches;
@property (nonatomic, copy) NSSet *children;
@property (nonatomic, copy) NSSet *parents;

@end

@interface NAVELCommit (CoreDataGeneratedAccessors)

-(void)addBranchesObject:(NAVELBranch *)value;
-(void)removeBranchesObject:(NAVELBranch *)value;
-(void)addBranches:(NSSet *)values;
-(void)removeBranches:(NSSet *)values;

-(void)addChildrenObject:(NAVELCommit *)value;
-(void)removeChildrenObject:(NAVELCommit *)value;
-(void)addChildren:(NSSet *)values;
-(void)removeChildren:(NSSet *)values;

-(void)addParentsObject:(NAVELCommit *)value;
-(void)removeParentsObject:(NAVELCommit *)value;
-(void)addParents:(NSSet *)values;
-(void)removeParents:(NSSet *)values;

@end
