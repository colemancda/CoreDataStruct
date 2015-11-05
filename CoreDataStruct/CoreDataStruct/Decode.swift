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

public extension NSManagedObjectContext {
    
    /// Executes a fetch request and returns ```CoreDataDecodable``` types.
    func executeFetchRequest<T: CoreDataDecodable>(fetchRequest: NSFetchRequest) throws -> [T] {
        
        guard fetchRequest.resultType == .ManagedObjectResultType
            else { fatalError("Method only supports fetch requests with NSFetchRequestResultType.ManagedObjectResultType") }
        
        let managedObjects = try self.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
        let decodables = managedObjects.map { (element) -> T in T.init(managedObject: element) }
        
        return decodables
    }
}