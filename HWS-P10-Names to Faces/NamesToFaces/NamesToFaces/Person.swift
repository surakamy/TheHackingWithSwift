//
//  Person.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/15/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {

    internal init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    var name: String
    var image: String

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }

}
