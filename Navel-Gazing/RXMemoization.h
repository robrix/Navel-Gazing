//  Copyright (c) 2013 Rob Rix. All rights reserved.



#define RXMemoize(variable, ...) \
	(^__typeof__(variable){ \
		if (!variable) { \
			variable = (__VA_ARGS__)(); \
		} \
		return variable; \
	})()
