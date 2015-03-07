#import "Kiwi.h"
#import "NSBundle+JSONLoader.h"
#import "NSString+JSON.h"
#import "VeriJSON.h"

SPEC_BEGIN(VeriJSONTests)

describe(@"VeriJSON Tests", ^{
    registerMatchers(@"SKKiwi");
    
    __block NSBundle *bundle;
    __block VeriJSON *veriJSON;
    
    beforeEach(^{
        bundle = [NSBundle bundleForClass:[self class]];
        veriJSON = [VeriJSON new];
    });
    
    it(@"nil JSON and nil pattern", ^{
        BOOL valid = [veriJSON verifyJSON:nil pattern:nil];
        [[@(valid) should] beYes];
    });
    
    it(@"non-nil JSON and nil pattern", ^{
        NSData *jsonData = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        BOOL valid = [veriJSON verifyJSON:json pattern:nil];
        [[@(valid) should] beYes];
    });
    
    it(@"nil JSON and non-nil pattern", ^{
        id pattern = [bundle jsonFromResource:@"SimpleObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:nil pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"simple invalid object", ^{
        id json = [bundle jsonFromResource:@"SimpleObjectInvalid.json"];
        id pattern = [bundle jsonFromResource:@"SimpleObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"simple valid object", ^{
        id json = [bundle jsonFromResource:@"SimpleObject.json"];
        id pattern = [bundle jsonFromResource:@"SimpleObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"required attribute missing", ^{
        id json = [bundle jsonFromResource:@"SimpleObject.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithStringPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"string type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithString.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithStringPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"invalid string type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithStringInvalid.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithStringPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"number type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNumber.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithNumberPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"invalid number type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNumberInvalid.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithNumberPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"number in range", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNumberInRange.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithNumberRangePattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"number not in range", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNumberNotInRange.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithNumberRangePattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"bool type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithBool.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithBoolPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"invalid bool type", ^{
        id json = [bundle jsonFromResource:@"ObjectWithBoolInvalid.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithBoolPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"bool/numbers interchangeable - this is because there is no BOOL object in Objective-C", ^{
        id json = [bundle jsonFromResource:@"ObjectWithBoolAsNumber.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithBoolPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"object containing an object", ^{
        id json = [bundle jsonFromResource:@"ObjectWithObject.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"object containing an invalid object", ^{
        id json = [bundle jsonFromResource:@"ObjectWithObjectInvalid.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"object expecting to contain an object but getting something else", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNonObject.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"multi-attribute object with an embedded object", ^{
        id json = [bundle jsonFromResource:@"RealisticObject.json"];
        id pattern = [bundle jsonFromResource:@"RealisticObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"simple array", ^{
        id json = [bundle jsonFromResource:@"SimpleArray.json"];
        id pattern = [bundle jsonFromResource:@"SimpleArrayPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    context(@"email", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithEmailPattern.json"];
        });
        
        it(@"email valid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmail.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"email invalid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"email invalid 2", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalid2.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"email empty", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalidEmpty.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
    });
 
    context(@"email", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithEmailPattern.json"];
        });
        
        it(@"email valid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmail.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"email invalid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"email invalid 2", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalid2.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"email empty", ^{
            id json = [bundle jsonFromResource:@"ObjectWithEmailInvalidEmpty.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
    });

    
    context(@"color", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithColorPattern.json"];
        });
        
        it(@"valid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithColor.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });

        it(@"valid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithColorNumber.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"invalid Color String", ^{
            id json = [bundle jsonFromResource:@"ObjectWithColorInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });

        it(@"invalid Color Number", ^{
            id json = [bundle jsonFromResource:@"ObjectWithColorInvalidNumber.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
     });
    
    context(@"type wildcard", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithWildcardPattern.json"];
        });
        
        it(@"valid wildcard", ^{
            id json = [bundle jsonFromResource:@"ObjectWithWildcardValid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"invalid wildcard", ^{
            id json = [bundle jsonFromResource:@"ObjectWithWildcardInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
    });
    
    context(@"multiple types", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithMultipleTypePattern.json"];
        });
        
        it(@"valid int", ^{
            id json = [bundle jsonFromResource:@"ObjectWithMultipleTypeInt.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"valid string", ^{
            id json = [bundle jsonFromResource:@"ObjectWithMultipleTypeString.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"invalid type array", ^{
            id json = [bundle jsonFromResource:@"ObjectWithMultipleTypeArray.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
    });
    
    context(@"bad pattern", ^{
        it(@"object pattern with bad type", ^{
            id json = [@"{ \"count\": 42 }" toJSON];
            id pattern = [@"{ \"count\": \"foobartype\" }" toJSON];
            NSError *error;
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern error:&error];
            [[@(valid) should] beNo];
            [[error.domain should] equal:VeriJSONErrorDomain];
            [[@(error.code) should] equal:@(VeriJSONErrorCodeInvalidPattern)];
            [[[error localizedDescription] should] equal:@"Invalid pattern .count.foobartype"];
        });

        it(@"array pattern with bad type", ^{
            id json = [@"[42]" toJSON];
            id pattern = [bundle jsonFromResource:@"ArrayPatternWithBadType.json"];
            NSError *error;
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern error:&error];
            [[@(valid) should] beNo];
            [[error.domain should] equal:VeriJSONErrorDomain];
            [[@(error.code) should] equal:@(VeriJSONErrorCodeInvalidPattern)];
            [[[error localizedDescription] should] equal:@"Invalid pattern .foobartype"];
        });

        it(@"realistic pattern with bad type", ^{
            id json = [bundle jsonFromResource:@"RealisticObject.json"];
            id pattern = [bundle jsonFromResource:@"RealisticObjectPatternInvalid.json"];
            NSError *error;
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern error:&error];
            [[@(valid) should] beNo];
            [[error.domain should] equal:VeriJSONErrorDomain];
            [[@(error.code) should] equal:@(VeriJSONErrorCodeInvalidPattern)];
            [[[error localizedDescription] should] equal:@"Invalid pattern .properties.tags.foo"];
        });
    });
    
    it(@"additional attributes in the JSON are ignored", ^{
        id json = [bundle jsonFromResource:@"ExtraAttributes.json"];
        id pattern = [bundle jsonFromResource:@"RealisticObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"by default, all attributes in the pattern are required in the JSON", ^{
        id json = [bundle jsonFromResource:@"MissingAttributes.json"];
        id pattern = [bundle jsonFromResource:@"RealisticObjectPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"optional attributes", ^{
        id json = [bundle jsonFromResource:@"RealisticObjectOptional.json"];
        id pattern = [bundle jsonFromResource:@"RealisticObjectPatternOptional.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"optional attributes must still be the right type", ^{
        id json = [bundle jsonFromResource:@"RealisticObjectOptionalWrongType.json"];
        id pattern = [bundle jsonFromResource:@"RealisticObjectPatternOptional.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"null values not accepted for mandatory attributes", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNullString.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithStringPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beNo];
    });
    
    it(@"null values are accepted for optional attributes", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNullString.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithOptionalStringPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"null values for array attributes", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNullArray.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithOptionalArrayPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    it(@"non-null values for optional array attributes", ^{
        id json = [bundle jsonFromResource:@"ObjectWithNonNullArray.json"];
        id pattern = [bundle jsonFromResource:@"ObjectWithOptionalArrayPattern.json"];
        BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
        [[@(valid) should] beYes];
    });
    
    context(@"regex strings", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithDateStringPattern.json"];
        });

        it(@"valid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithDateString.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"invalid", ^{
            id json = [bundle jsonFromResource:@"ObjectWithDateStringInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
    });
    
    context(@"URL types", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithURLPattern.json"];
        });

        it(@"absolute URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURL.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"relative URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLRelative.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"non-string value", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLNonString.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"invalid URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLInvalid.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"empty URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLInvalidEmpty.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"whitespace URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLInvalidWhitespace.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
    });

    context(@"HTTP URL types", ^{
        __block id pattern;
        
        beforeEach(^{
            pattern = [bundle jsonFromResource:@"ObjectWithHTTPURLPattern.json"];
        });
        
        it(@"HTTP URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithHTTPURL.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"HTTPS URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithHTTPSURL.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"HTTP URL uppercase", ^{
            id json = [bundle jsonFromResource:@"ObjectWithHTTPURLUppercaseScheme.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"HTTPS URL uppercase", ^{
            id json = [bundle jsonFromResource:@"ObjectWithHTTPSURLUppercaseScheme.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beYes];
        });
        
        it(@"relative URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLRelative.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"non-string value", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLNonString.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });

        it(@"non-HTTP URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURL.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
        
        it(@"whitespace URL", ^{
            id json = [bundle jsonFromResource:@"ObjectWithURLInvalidWhitespace.json"];
            BOOL valid = [veriJSON verifyJSON:json pattern:pattern];
            [[@(valid) should] beNo];
        });
    });
    
    it(@"hack to ensure tests finish", ^{
        sleep(1);
    });
});

SPEC_END
