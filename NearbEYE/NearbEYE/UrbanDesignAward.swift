//
//  UrbanDesignAward.swift
//  NearbEYE
//
//  Created by Stephen Melinyshyn on 2015-10-24.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import CoreData

@objc (UrbanDesignAward)

class UrbanDesignAward: NSManagedObject, Stringify {

// Insert code here to add functionality to your managed object subclass

	func selfName() -> String {
		return projectName!
	}
	
}
