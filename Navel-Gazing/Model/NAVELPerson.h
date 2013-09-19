//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;

@class NAVELCommit, NAVELRepository;

@interface NAVELPerson : NSManagedObject

@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSSet *commits;
@property (nonatomic, copy) NSSet *repositories;

@end

@interface NAVELPerson (CoreDataGeneratedAccessors)

-(void)addCommitsObject:(NAVELCommit *)value;
-(void)removeCommitsObject:(NAVELCommit *)value;
-(void)addCommits:(NSSet *)values;
-(void)removeCommits:(NSSet *)values;

-(void)addRepositoriesObject:(NAVELRepository *)value;
-(void)removeRepositoriesObject:(NAVELRepository *)value;
-(void)addRepositories:(NSSet *)values;
-(void)removeRepositories:(NSSet *)values;

@end
