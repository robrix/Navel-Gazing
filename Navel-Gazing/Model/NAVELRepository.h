//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;

@class NAVELBranch, NAVELPerson;

@interface NAVELRepository : NSManagedObject

@property (nonatomic) NSURL *URL;

@property (nonatomic, copy) NSSet *branches;
@property (nonatomic) NAVELPerson *owner;

@end

@interface NAVELRepository (CoreDataGeneratedAccessors)

-(void)addBranchesObject:(NAVELBranch *)value;
-(void)removeBranchesObject:(NAVELBranch *)value;
-(void)addBranches:(NSSet *)values;
-(void)removeBranches:(NSSet *)values;

@end
