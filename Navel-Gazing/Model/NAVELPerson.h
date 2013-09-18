//
//  NAVELPerson.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NAVELCommit, NAVELRepository;

@interface NAVELPerson : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *commits;
@property (nonatomic, retain) NSSet *repositories;
@end

@interface NAVELPerson (CoreDataGeneratedAccessors)

- (void)addCommitsObject:(NAVELCommit *)value;
- (void)removeCommitsObject:(NAVELCommit *)value;
- (void)addCommits:(NSSet *)values;
- (void)removeCommits:(NSSet *)values;

- (void)addRepositoriesObject:(NAVELRepository *)value;
- (void)removeRepositoriesObject:(NAVELRepository *)value;
- (void)addRepositories:(NSSet *)values;
- (void)removeRepositories:(NSSet *)values;

@end
