# VeriJSON-Swift

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

JSON validator in Swift. 

VeriJSON helps you validate your JSON data easily with pattern based rules. 

The Objective-C version of VeriJSON was created by [dcutting](https://bitbucket.org/dcutting/verijson).

# Patterns

The VeriJSON patterns are designed with simplicity in mind. The patterns are also defined in json format. 

## Types

VeriJSON supports validation of String, Number, Int, Date, URL, HTTP, Email, Array and Dictionary types.

### String

The following pattern defines the name attribute be a string

	{
		"name": "string"
	}
	
Here a valid json: 

	{
		"name" : "Apple"
	}
	
### Number

The following pattern defines the int number with range

	{
		"value" :"int:1,100"
	}
	
Here is a valid json:

	{
		"value": "99"
	}
	
### Array

Pattern Example: 

	{
		"fruits": [ "String"]
	}
	
Valid json:

	{
		"fruits": ["Apple", "Pear", "Orange"]	
	}
	
### Dictionary

Pattern Example:

	{
		"name" : "string"
		"price": "number" 
		"author": "string"
	}
	
Valid json:
	
	{
		"name": "Test Driven Development: By Example"
		"price": "49.00"
		"author" "Kent Beck"	
	}

### Wildcard

Wildcard symbol "*" specifies the value can be any type, including collection types.  

Pattern Example: 
	{
		"object": "*" 
	}
	
### Multiple Types

YOu can use "|" to specify multiple possible types.  The following example defines a value to be either string or number. 

Pattern Example: 
	{
		"value": "string|number"
	}
	
	
### More

VeriJSON also supports Color, URL, HTTP, Email, Bool. 	

### Optionals
	

You can specify an attribute is optional with "?", if the attribute is provided, the type must satisfy the pattern.  Optional can apply on any name. 

Here is an example with optional attribute "reviews"

	{ 
		"name" : "string"
		"price" : "number"
		"author" : "string"
		"review?": ["string"]
	}
	
# More Examples

There are more examples in [./VeriJSONTests/Data](./VeriJSONTests/Data) directory. 

