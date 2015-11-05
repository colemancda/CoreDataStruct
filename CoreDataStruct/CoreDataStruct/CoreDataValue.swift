//
//  CoreDataValue.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public enum CoreDataValue {
    
    case Null
    
    case Attribute(CoreDataAttributeValue)
    
    case Relationship(RelationshipValue)
}

public enum CoreDataAttributeValue {
    
    case String(NSString)
    
    case Number(NSNumber)
    
    case Data(NSData)
    
    case Date(NSDate)
    
    case Transformable(AnyObject)
}

public enum RelationshipValue {
    
    case ToOne([String: CoreDataValue])
    
    case ToMany([[String: CoreDataValue]])
}