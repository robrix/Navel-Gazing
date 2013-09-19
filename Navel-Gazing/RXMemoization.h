//  Copyright (c) 2013 Rob Rix. All rights reserved.

#define RXMemoize(variable, ...) \
	(^__typeof__(variable){ \
		__typeof__(variable) _variable = (variable);\
		\
		if (!_variable) { \
			_variable = variable = (__VA_ARGS__); \
		} \
		return _variable; \
	})()
