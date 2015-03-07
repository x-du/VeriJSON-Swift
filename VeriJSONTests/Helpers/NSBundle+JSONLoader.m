//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import "NSBundle+JSONLoader.h"

@implementation NSBundle (JSONLoader)

- (id)jsonFromResource:(NSString *)resource {
    NSString *path = [self pathForResource:resource ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    if (!json) {
        @throw @"Could not load JSON.";
    }
    return json;
}

@end
