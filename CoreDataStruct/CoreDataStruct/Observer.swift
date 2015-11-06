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
    
    public var decodable: Decodable?
    
    public let managedObject: NSManagedObject
    
    public let context: NSManagedObjectContext
    
    private let privateObserver: PrivateManagedObjectObserver
    
    public init(managedObject: NSManagedObject, context: NSManagedObjectContext) {
        
        self.managedObject = managedObject
        self.context = context
        
        self.privateObserver = PrivateManagedObjectObserver(managedObject: managedObject, context: context)
    }
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
        
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as! [NSManagedObject]? {
            
            for managedObject in insertedObjects {
                
                if managedObject === self.managedObject {
                    
                    self.delegate?.observer(self, managedObjectInserted: managedObject)
                    
                    return
                }
            }
        }
    }
}

private protocol PrivateManagedObjectObserverDelegate: class {
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectUpdated managedObject: NSManagedObject)
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectInserted managedObject: NSManagedObject)
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectDeleted managedObject: NSManagedObject)
}

extension ManagedObjectObserver: PrivateManagedObjectObserverDelegate {
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectUpdated managedObject: NSManagedObject) {
        
        
    }
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectDeleted managedObject: NSManagedObject) {
        
        
    }
    
    func observer(observer: PrivateManagedObjectObserver, managedObjectInserted managedObject: NSManagedObject) {
        
        
    }
}