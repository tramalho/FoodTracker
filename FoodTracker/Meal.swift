//
//  Meal.swift
//  FoodTracker
//
//  Created by Thiago Antonio Ramalho on 07/05/18.
//  Copyright © 2018 Tramalho. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    
    //MARK: Properties
    var name: String = ""
    var photo : UIImage?
    var rating : Int = 0
    
    //MARK: Archiving Paths
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArcheveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    init?(name:String,  photo: UIImage?, rating : Int) {
        super.init()
        // Initialization should fail if there is no name or if the rating is negative.
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }

    //MARK: NSCoding

    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string,
        // the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,  forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating,forKey: PropertyKey.rating)
    }

    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
}

