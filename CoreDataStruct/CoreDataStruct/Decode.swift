//
//  Decode.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/// Specifies how a type can be decoded from Core Data.
public protocol CoreDataDecodable {
    
    init(managedObject: NSManagedObject)
}