//
//  Comment.swift
//  CoreDataStruct
//
//  Created by Alsey Coleman Miller on 11/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import CoreDataStruct

public struct Comment: CoreDataEncodable, CoreDataDecodable {
    
    /// The unique identifier. 
    public let identifier: String
    
    public var text: String
    
    public var discussionID: String
}

// MARK: - JSON



// MARK: - CoreData

