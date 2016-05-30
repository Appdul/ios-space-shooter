//
//  Score.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-05-29.
//  Copyright © 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import Foundation
import CoreData

@objc(Score)
class Score: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var highScore: NSNumber?
}
