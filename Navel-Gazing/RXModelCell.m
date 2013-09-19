//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXModelCell.h"
#import "RXMemoization.h"

@interface RXModelCell ()

@property (nonatomic) bool finishedLoading;

@property (nonatomic, readonly) NSMutableDictionary *maps;

@end

@implementation RXModelCell

-(void)updateWithModelObject:(id)object {
	for (NSString *keyPath in self.maps) {
		UIView<RXModelView> *view = [self valueForKeyPath:keyPath];
		id value = [object valueForKeyPath:self.maps[keyPath]];
		[view updateWithModelObject:value];
	}
}

-(void)cancelUpdating {
	for (NSString *keyPath in self.maps) {
		UIView<RXModelView> *view = [self valueForKeyPath:keyPath];
		[view cancelUpdating];
	}
}


@synthesize maps = _maps;

-(NSMutableDictionary *)maps {
	return RXMemoize(_maps, [NSMutableDictionary new]);
}

@end
