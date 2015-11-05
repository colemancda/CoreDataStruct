//
//  Discussion.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import CoreDataStruct

public struct Discussion: CoreDataEncodable, CoreDataDecodable {
    
    /// The unique identifier. 
    public let identifier: String
    
    public var tags: [String]
    
    public var subject: String
    
    public var visibility: Category
    
    /// The identifiers of the comments.
    public var comments: [Comment]
}

public extension Discussion {
    
    public enum Visibility: String {
        
        case Public, Private
    }
}

// MARK: - JSON



// MARK: - CoreData


