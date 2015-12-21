//
//  EntityController.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/6/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/// Observes a managed object and updates a ```CoreDataDecodable```.
public final class EntityController<Decodable: CoreDataDecodable> {
    
    // MARK: - Properties
    
    public let entityName: String
    
    public let identifier: (key: String, value: String)
    
    public let context: NSManagedObjectContext
    
    public var event = ManagedObjectObserverEvent<Decodable>()
    
    // MARK: - Private Properties
    
    private let privateController: PrivateEntityController
    
    // MARK: - Initialization
    
    public init(entityName: String, identifier: (key: String, value: String), context: NSManagedObjectContext) {
        
        self.entityName = entityName
        self.identifier = identifier
        self.context = context
        
        self.privateController = PrivateEntityController(entityName: entityName, identifier: identifier, context: context)
    }
}

// MARK: - Supporting Types

public struct ManagedObjectObserverEvent<Decodable: CoreDataDecodable> {
    
    public var updated: Decodable -> () = { _ in }
    
    public var deleted: () -> () = { _ in }
}

// MARK: - Private

@objc private final class PrivateEntityController: NSObject {
    
    let entityName: String
    
    let identifier: (key: String, value: String)
    
    let context: NSManagedObjectContext
    
    weak var delegate: PrivateManagedObjectObserverDelegate?
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextObjectsDidChangeNotification, object: self.context)
    }
    
    init(entityName: String, identifier: (key: String, value: String), context: NSManagedObjectContext) {
        
        self.entityName = entityName
        self.identifier = identifier
        self.context = context
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextObjectsDidChange:", name: NSManagedObjectContextObjectsDidChangeNotification, object: context)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as! [NSManagedObject]? {
            
            for managedObject in updatedObjects {
                
                if managedObject.valueForKey(identifier.key) as? NSObject == identifier.value {
                    
                    self.delegate?.observer(self, managedObjectUpdated: managedObject)
                    
                    return
                }
            }
        }
        
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as! [NSManagedObject]? {
            
            for managedObject in deletedObjects {
                
                if managedObject.valueForKey(identifier.key) as? NSObject == identifier.value {
                    
                    self.delegate?.observer(self, managedObjectDeleted: managedObject)
                    
                    return
                }
            }
        }
    }
}

private protocol PrivateManagedObjectObserverDelegate: class {
    
    func observer(observer: PrivateEntityController, managedObjectUpdated managedObject: NSManagedObject)
    
    func observer(observer: PrivateEntityController, managedObjectDeleted managedObject: NSManagedObject)
}

extension EntityController: PrivateManagedObjectObserverDelegate {
    
    private func observer(observer: PrivateEntityController, managedObjectUpdated managedObject: NSManagedObject) {
        
        let decodable = Decodable.init(managedObject: managedObject)
        
        self.event.updated(decodable)
    }
    
    private func observer(observer: PrivateEntityController, managedObjectDeleted managedObject: NSManagedObject) {
        
        self.event.deleted()
    }
}
