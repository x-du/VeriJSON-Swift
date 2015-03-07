//
//  String+JSON.swift
//  VeriJSON-Swift
//
//  Created by Du, Xiaochen (Harry) on 3/5/15.
//  Copyright (c) 2015 Where Here. All rights reserved.
//

import Foundation

extension String {
    
    func toJson() -> AnyObject? {
        
        if let jsonData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        } else {
            return nil
        }
        //NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
        //return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        
    }
}