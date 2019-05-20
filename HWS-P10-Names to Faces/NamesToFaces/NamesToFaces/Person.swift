//
//  Person.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/15/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String

    override var description: String {
        return self.name
    }

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        // no sense to call super.encode(with:) here
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.image, forKey: "image")
    }

}

class PersonOnTwitter: Person, NSSecureCoding {

    static var supportsSecureCoding: Bool { return true }

    var handler: String

    override var name: String {
        didSet {
            let parts = self.name.components(separatedBy: "@")
            if parts.count > 1 {
                self.name = parts[0].trimmingCharacters(in: .whitespaces)
                self.handler = parts[1].trimmingCharacters(in: .whitespaces)
            }
        }
    }

    override var description: String {
        let twitter = self.handler.isEmpty ? "" : "\n🌀 \(self.handler)"
        return "\(self.name)\(twitter)"
    }

    init(name: String, image: String, handler: String) {
        self.handler = handler
        super.init(name: name, image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        // Safe codding
        handler = aDecoder
            .decodeObject(of: NSString.self, forKey: "handler") as String? ?? ""
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.handler, forKey: "handler")
    }

}



