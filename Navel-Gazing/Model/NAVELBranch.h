//
//  NAVELBranch.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NAVELCommit, NAVELRepository;

@interface NAVELBranch : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NAVELCommit *head;
@property (nonatomic, retain) NAVELRepository *repository;

@end
