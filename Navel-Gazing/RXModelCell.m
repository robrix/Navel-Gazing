//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXModelCell.h"
#import "RXMemoization.h"

#import "UIView+RXModelMapping.h"

@interface RXModelCell ()

@property (nonatomic) bool finishedLoading;

@property (nonatomic, readonly) NSMutableDictionary *maps;

@end

@implementation RXModelCell

-(void)updateWithModelObject:(id)object {
	for (NSString *keyPath in self.maps) {
		UIView *view = [self valueForKeyPath:keyPath];
		id value = [object valueForKeyPath:self.maps[keyPath]];
		view.rx_objectValue = value;
	}
}


@synthesize maps = _maps;

-(NSMutableDictionary *)maps {
	return RXMemoize(_maps, [NSMutableDictionary new]);
}


@end
