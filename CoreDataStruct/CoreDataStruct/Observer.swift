//
//  Observer.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/6/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/// Observes a managed object and updates a ```CoreDataDecodable```.
public final class ManagedObjectObserver<Decodable: CoreDataDecodable> {
    
    // MARK: - Properties
    
    public private(set) var decodable: Decodable?
    
    public let managedObject: NSManagedObject
    
    public let context: NSManagedObjectContext
    
    public var event = ManagedObjectObserverEvent<Decodable>()
    
    // MARK: - Private Properties
    
    private let privateObserver: PrivateManagedObjectObserver
    
    // MARK: - Initialization
    
    public init(managedObject: NSManagedObject, context: NSManagedObjectContext) {
        
        self.managedObject = managedObject
        self.context = context
        
        self.decodable = Decodable.init(managedObject: managedObject)
        
        self.privateObserver = PrivateManagedObjectObserver(managedObject: managedObject, context: context)
    }
}

// MARK: - Supporting Types

public struct ManagedObjectObserverEvent<Decodable: CoreDataDecodable> {
    
    public var updated: Decodable -> () = { _ in }
    
    public var deleted: () -> () = { _ in }
}

// MARK: - Private

@objc private final class PrivateManagedObjectObserver: NSObject {
    
    let managedObject: NSManagedObject
    
    let context: NSManagedObjectContext
    
    weak var delegate: PrivateManagedObjectObserverDelegate?
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextObjectsDidChangeNotification, object: self.context)
    }
    
    init(managedObject: NSManagedObject, context: NSManagedObjectContext) {
        
        self.managedObject = managedObject
        self.context = context
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextObjectsDidChange:", name: NSManagedObjectContextObjectsDidChangeNotification, object: context)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as! [NSManagedObject]? {
            
            for managedObject in updatedObjects {
                
                if managedObject === self.managedObject {
                    
                    self.delegate?.observer(self, managedObjectUpdated: managedObject)
                    
                    return
                }
            }
        }
        
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as! [NSManagedObject]? {
            
            for managedObject in deletedObjects {
                
                if managedObject === self.managedObject {
                    
                    self.delegate?.observer(self, managedObjectDeleted: managedObject)
                    
                    return
                }
            }
        }
    }
}

private protocol PrivateManagedObjectObserverDelegate: class {
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectUpdated managedObject: NSManagedObject)
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectDeleted managedObject: NSManagedObject)
}

extension ManagedObjectObserver: PrivateManagedObjectObserverDelegate {
    
    private func observer(observer: PrivateManagedObjectObserver, managedObjectUpdated managedObject: NSManagedObject) {
        
        let decodable = Decodable.init(managedObject: managedObject)
        
        self.decodable = decodable
        
        self.event.updated(decodable)
    }
    
    private func observer(observer: PrivateManagedObjectObserver, managedObjectDeleted managedObject: NSManagedObject) {
        
        self.decodable = nil
        
        self.event.deleted()
    }
}
