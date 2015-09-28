//
//  NSBundle+JSONLoader.swift
//  VeriJSON-Swift
//
//  Created by Du, Xiaochen (Harry) on 3/5/15.
//  Copyright (c) 2015 Where Here. All rights reserved.
//

import Foundation

extension NSBundle {
    
    func jsonFromResource(resource:String) -> AnyObject? {
        
        if let path = self.pathForResource(resource, ofType: nil) {
            if let jsonData = NSData(contentsOfFile: path) {
                return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            }
        }
        return nil;
        

    }
}