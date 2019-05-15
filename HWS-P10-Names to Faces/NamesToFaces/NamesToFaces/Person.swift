//
//  Person.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/15/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class Person: NSObject {
    internal init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    var name: String
    var image: String
}
