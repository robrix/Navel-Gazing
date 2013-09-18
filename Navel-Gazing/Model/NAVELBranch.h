//
//  NAVELBranch.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

@import CoreData;

@class NAVELCommit, NAVELRepository;

@interface NAVELBranch : NSManagedObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic) NAVELCommit *head;
@property (nonatomic) NAVELRepository *repository;

@end
