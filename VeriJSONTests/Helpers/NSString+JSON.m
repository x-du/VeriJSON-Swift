//  Copyright (c) 2013 Daniel Cutting. All rights reserved.

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (id)toJSON {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
}

@end
