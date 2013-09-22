//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@class NAVELModelController;

#import "NAVELPerson.h"
#import "RXCollectionViewController.h"

@interface NAVELRepositoriesController : NSObject <RXCollectionViewControllerDelegate, RXCollectionViewControllerDataSource>

@property (nonatomic) NAVELModelController *modelController;

@property (nonatomic) NAVELPerson *user;

@end
