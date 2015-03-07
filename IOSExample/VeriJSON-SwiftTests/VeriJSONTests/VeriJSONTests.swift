//
//  VeriJSONTests.swift
//  VeriJSON-Swift
//
//  Created by Du, Xiaochen (Harry) on 3/5/15.
//  Copyright (c) 2015 Where Here. All rights reserved.
//


import XCTest


class VeriJSONTests: XCTestCase {

    var veriJSON : VeriJSON?
    var bundle = NSBundle(forClass: VeriJSONTests.self)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        veriJSON = VeriJSON()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNilJsonNilPattern() {
        let valid = veriJSON!.verifyJSON(nil, pattern: nil)
        XCTAssertTrue(valid, "Nil Json with Nil Pattern Should Pass!")
    }

    func testNonNilJsonNilPattern() {
        let valid = veriJSON!.verifyJSON("{}".toJson(), pattern: nil)
        XCTAssertTrue(valid, "Non-Nil Empty Json with Nil Pattern Should Pass!")
    }
    
    func testNilJsonNonNilPattern() {
        
        let pattern: AnyObject? = bundle.jsonFromResource("SimpleObjectPattern.json")
        let valid = veriJSON!.verifyJSON(nil, pattern:pattern)
        XCTAssertNotNil(pattern, "Failed to load test data")
        XCTAssertFalse(valid, "Nil Json with Non-Nil Pattern Should Fail!")
    }
    
    func testSimpleInvalidObject() {
        
        shouldFail(json: "SimpleObjectInvalid.json", pattern: "SimpleObjectPattern.json", message: "Should be invalid Json with for Pattern!")
    }
    
    func testSimpleValidObject() {
        shouldPass(json:"SimpleObject.json", pattern: "SimpleObjectPattern.json", message:"Should be valid json")
    }
    
    func testRequiredAttributeMissing() {
        shouldFail(json: "SimpleObject.json", pattern: "ObjectWithStringPattern.json", message: "Required attribute missing")
    }
    
    func testStringType() {
        shouldPass(json: "ObjectWithString.json", pattern: "ObjectWithStringPattern.json", message: "String Type Test Failed")
    }
    
    
    func testInvalidStringType() {
        shouldFail(json: "ObjectWithStringInvalid.json", pattern: "ObjectWithStringPattern.json", message: "Invalid String Type")
        
    }

    func testNumberType() {
        shouldPass(json: "ObjectWithNumber.json", pattern: "ObjectWithNumberPattern.json", message: "Valid Number Type")
    }
    
    func testInvalidNumberType() {
        shouldFail(json: "ObjectWithNumberInvalid.json", pattern: "ObjectWithNumberPattern.json", message: "Invalid Number Type")
        
    }
        
    
    func testNumberInRange() {
        shouldPass(json:"ObjectWithNumberInRange.json", pattern: "ObjectWithNumberRangePattern.json", message: "Number should be in range")
    }

    func testNumberNotInRange() {
        shouldFail(json:"ObjectWithNumberNotInRange.json", pattern: "ObjectWithNumberRangePattern.json", message: "Number should not be in range")
    }

    func testBoolType() {
        shouldPass(json:"ObjectWithBool.json", pattern: "ObjectWithBoolPattern.json", message: "Failed boolean type test")
    }
    
    
    func testInvalidBoolType() {
        shouldFail(json: "ObjectWithBoolInvalid.json", pattern: "ObjectWithBoolPattern.json", message: "Failed boolean type test")
    }
    
    func testNumberAsBool() {
        shouldPass(json: "ObjectWithBoolAsNumber.json", pattern: "ObjectWithBoolPattern.json", message: "Failed boolean type test")
    }
    
    func testObjectInObject() {
        shouldPass(json: "ObjectWithObject.json", pattern: "ObjectWithObjectPattern.json", message: "Failed object in object test")
    }
    
    func testInvalidObjectInObject() {
        shouldFail(json: "ObjectWithObjectInvalid.json", pattern: "ObjectWithObjectPattern.json", message: "Failed object in object test")
    }
    
    func testObjectWithNonObject() {
        shouldFail(json: "ObjectWithNonObject.json", pattern: "ObjectWithObjectPattern.json", message: "Failed object in object test")
        
    }
    
    func testMultiAttributeObject() {
        shouldPass(json: "RealisticObject.json", pattern: "RealisticObjectPattern.json", message: "Failed Multi-attribute object test")
    }
    
    func testArray() {
        shouldPass(json: "SimpleArray.json", pattern: "SimpleArrayPattern.json", message: "Failed Array Test")
    }
    
    func testEmail() {
        shouldPass(json: "ObjectWithEmail.json", pattern: "ObjectWithEmailPattern.json", message: "Failed Email Type Test")
    }

    func testInvalidEmail() {
        shouldFail(json: "ObjectWithEmailInvalid.json", pattern: "ObjectWithEmailPattern.json", message: "Failed Email Type Test")
        shouldFail(json: "ObjectWithEmailInvalid2.json", pattern: "ObjectWithEmailPattern.json", message: "Failed Email Type Test")
        shouldFail(json: "ObjectWithEmailInvalidEmpty.json", pattern: "ObjectWithEmailPattern.json", message: "Failed Email Type Test")
    }

    func testColor() {
        shouldPass(json: "ObjectWithColor.json", pattern: "ObjectWithColorPattern.json", message: "Failed Color Test")
        shouldPass(json: "ObjectWithColorNumber.json", pattern: "ObjectWithColorPattern.json", message: "Failed Color Test")
        shouldFail(json: "ObjectWithColorInvalid.json", pattern: "ObjectWithColorPattern.json", message: "Failed Color Test")
        shouldFail(json: "ObjectWithColorInvalidNumber.json", pattern: "ObjectWithColorPattern.json", message: "Failed Color Test")
        
    }


    func testWildcard() {
        shouldPass(json: "ObjectWithWildcardValid.json", pattern: "ObjectWithWildcardPattern.json", message: "Failed Wildcard Test")
        shouldFail(json: "ObjectWithWildcardInvalid.json", pattern: "ObjectWithWildcardPattern.json", message: "Failed Wildcard Test")

    }
    
    func testMultipleTypes() {
        shouldPass(json: "ObjectWithMultipleTypeInt.json", pattern: "ObjectWithMultipleTypePattern.json", message: "Failed Multiple Type Int Test")
        shouldPass(json: "ObjectWithMultipleTypeString.json", pattern: "ObjectWithMultipleTypePattern.json", message: "Failed Multiple Type Test")
        shouldFail(json: "ObjectWithMultipleTypeArray.json", pattern: "ObjectWithMultipleTypePattern.json", message: "Failed Multiple Type Test")
        
    }

    func testBadPattern() {
        let json: AnyObject? = "{\"count\":42 }".toJson()
        let pattern: AnyObject? = "{\"count\":\"foobartype\" }".toJson()
        var error: NSError?
        let valid = veriJSON?.verifyJSON(json, pattern: pattern, error:&error )
        XCTAssert(valid == false, "Should Failed on Bad Pattern")
        
        if let error = error {
            XCTAssertEqual(error.domain, VeriJSONErrorDomain, "Invalid Error Domain")
            XCTAssertEqual(error.code, VeriJSONErrorCode.InvalidPattern.rawValue, "Invalid Error Code")
            XCTAssertEqual(error.localizedDescription, "Invalid pattern .count.foobartype", "Failed on Error description")
            
        } else {
            XCTAssertTrue(true, "Should have Error")
        }


    }

    func testArrayWithBadType() {
        let json: AnyObject? = "[42]".toJson()
        let pattern: AnyObject? = bundle.jsonFromResource("ArrayPatternWithBadType.json")
        var error: NSError?
        let valid = veriJSON?.verifyJSON(json, pattern: pattern, error:&error )
        XCTAssert(valid == false, "Should Failed on Bad Pattern")
        if let error = error {
            XCTAssert(error.domain == VeriJSONErrorDomain, "Invalid Error Domain")
            XCTAssert(error.code == VeriJSONErrorCode.InvalidPattern.rawValue, "Invalid Error Code")
            XCTAssert(error.localizedDescription == "Invalid pattern .foobartype", "Failed on Error description")
            
        } else {
            XCTAssertTrue(true, "Should have Error")
        }
        
    }

    func testRealisticObjectPatternInvalid() {
        let json: AnyObject? = bundle.jsonFromResource("RealisticObject.json")
        let pattern: AnyObject? = bundle.jsonFromResource("RealisticObjectPatternInvalid.json")
        var error: NSError?
        let valid = veriJSON?.verifyJSON(json, pattern: pattern, error:&error )
        XCTAssert(valid == false, "Should Failed on Bad Pattern")
        if let error = error {
            XCTAssert(error.domain == VeriJSONErrorDomain, "Invalid Error Domain")
            XCTAssert(error.code == VeriJSONErrorCode.InvalidPattern.rawValue, "Invalid Error Code")
            XCTAssert(error.localizedDescription == "Invalid pattern .properties.tags.foo", "Failed on Error description")
            
        } else {
            XCTAssertTrue(true, "Should have Error")
        }

        
    }

    func testIgnoreAdditionalAttributes() {
        shouldPass(json: "ExtraAttributes.json", pattern: "RealisticObjectPattern.json", message: "Should Ignore Additional Attributes")
    }

    func testMissingAttributes() {
        shouldFail(json: "MissingAttributes.json", pattern: "RealisticObjectPattern.json", message: "Missing Attribute Test Failed")
    }

    func testOptionalAttribute() {
        shouldPass(json: "RealisticObjectOptional.json", pattern: "RealisticObjectPatternOptional.json", message: "Optional attribute should be optional")
        shouldFail(json: "RealisticObjectOptionalWrongType.json", pattern: "RealisticObjectPatternOptional.json", message: "Is provided, the optional attribute must have the correct type")
        
    }
    
    func testNullValue() {
        shouldFail(json: "ObjectWithNullString.json", pattern: "ObjectWithStringPattern.json", message: "null value not accepted for mandatory attributes")
        shouldPass(json: "ObjectWithNullString.json", pattern: "ObjectWithOptionalStringPattern.json", message:"null values are accepted for optional attributes")
        shouldPass(json: "ObjectWithNullArray.json", pattern: "ObjectWithOptionalArrayPattern.json", message:"null values are accepted for optional array")
        shouldPass(json: "ObjectWithNonNullArray.json", pattern: "ObjectWithOptionalArrayPattern.json", message:"non-null values are accepted for optional array")
        
    }

    func testDate() {
        
        shouldPass(json: "ObjectWithDateString.json", pattern: "ObjectWithDateStringPattern.json", message: "Date Pattern test failed")
        shouldFail(json: "ObjectWithDateStringInvalid.json", pattern: "ObjectWithDateStringPattern.json", message: "Date Pattern test failed")
    }

    func testURL() {
        
        shouldPass(json: "ObjectWithURL.json", pattern: "ObjectWithURLPattern.json", message: "Absolute URL Test Failed")
        shouldPass(json: "ObjectWithURLRelative.json", pattern: "ObjectWithURLPattern.json", message: "Relative URL Test Failed")
        shouldFail(json: "ObjectWithURLNonString.json", pattern: "ObjectWithURLPattern.json", message: "Non String for URL should fail")
        shouldFail(json: "ObjectWithURLInvalid.json", pattern: "ObjectWithURLPattern.json", message: "Non String for URL should fail")
        shouldFail(json: "ObjectWithURLInvalid.json", pattern: "ObjectWithURLPattern.json", message: "Invalid URL for URL should fail")
        shouldFail(json: "ObjectWithURLInvalidEmpty.json", pattern: "ObjectWithURLPattern.json", message: "Empty for URL should fail")
        shouldFail(json: "ObjectWithURLInvalidWhitespace.json", pattern: "ObjectWithURLPattern.json", message: "Whitespace in  URL should fail")
    }
    
    func testHTTPURL() {
        shouldPass(json: "ObjectWithHTTPURL.json", pattern: "ObjectWithHTTPURLPattern.json", message: "HTTP Test Failed")
        shouldPass(json: "ObjectWithHTTPSURL.json", pattern: "ObjectWithHTTPURLPattern.json", message: "HTTPS Test Failed")
        shouldPass(json: "ObjectWithHTTPURLUppercaseScheme.json", pattern: "ObjectWithHTTPURLPattern.json", message: "HTTP Upper Case Test Failed")
        shouldPass(json: "ObjectWithHTTPSURLUppercaseScheme.json", pattern: "ObjectWithHTTPURLPattern.json", message: "HTTPS Upper Case Test Failed")
        
        shouldFail(json: "ObjectWithURLRelative.json", pattern: "ObjectWithHTTPURLPattern.json", message: "Relative URL  should fail")
        shouldFail(json: "ObjectWithURLNonString.json", pattern: "ObjectWithHTTPURLPattern.json", message: "Non-string HTTP  should fail")
        shouldFail(json: "ObjectWithURL.json", pattern: "ObjectWithHTTPURLPattern.json", message: "Non-string HTTP  should fail")
        shouldFail(json: "ObjectWithURLInvalidWhitespace.json", pattern: "ObjectWithHTTPURLPattern.json", message: "Non-string HTTP  should fail")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    internal func shouldPass(# json:String, pattern:String, message:String) {
        should(pass:true, json:json, pattern: pattern, message: message)
    }
    
    internal func shouldFail(# json:String, pattern:String, message:String) {
        should(pass: false, json: json, pattern: pattern, message: message)
    }
    
    internal func should(# pass:Bool, json:String, pattern:String, message:String) {
        
        let jsonObj: AnyObject? = bundle.jsonFromResource(json)
        let patternObj: AnyObject? = bundle.jsonFromResource(pattern)
        XCTAssertNotNil(jsonObj, "Failed to load test json data: \(json)")
        XCTAssertNotNil(patternObj, "Failed to load test pattern data: \(pattern)")
        let valid = veriJSON!.verifyJSON(jsonObj,pattern:patternObj)
        XCTAssertEqual(valid, pass, message)
    }

}
