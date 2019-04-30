//
//  PicturesModel.swift
//  Project1
//
//  Created by Dmytro Kholodov on 4/27/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit


struct PictureFilesProvider {
    var byCriterion = { (value: String) in return value.hasPrefix("nssl") }

    var files: [String]

    init(_ filter: ((String)-> Bool)? = nil) {
        if let filter = filter {
            self.byCriterion = filter
        }

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        files = items.filter(byCriterion).sorted()
    }

    func pictureViewModel(at index: Int) -> PictureViewModel? {
        guard files.indices.contains(index) else { return nil }
        let title = "Picture \(index) of \(files.count)"
        return PictureViewModel.init(selectedImage: files[index], detailTitle: title)
    }


    // MARK: - Theme helpers

    let attributesForName: [NSAttributedString.Key:Any] = [
        .font : UIFont.preferredFont(forTextStyle: .title1),
        .kern: 2.0
    ]

    let attributesForExt: [NSAttributedString.Key:Any] = [
        .font : UIFont.preferredFont(forTextStyle: .title3),
        .foregroundColor: UIColor.gray
    ]

    func fileNameStyled(at index: Int) -> NSAttributedString? {
        guard files.indices.contains(index) else { return nil }
        let fileName = files[index]

        let parts = fileName.split(separator: ".")

        if parts.count > 1 {

            let combined = NSMutableAttributedString()

            let name = NSAttributedString(string: String(parts[0]), attributes: attributesForName)
            combined.append(name)

            let ext = NSAttributedString(string: String(parts[1]), attributes: attributesForExt)
            combined.append(ext)

            return combined
        }

        let string = NSAttributedString(string: fileName)
        return string
    }
}


struct PictureViewModel {
    var selectedImage: String
    var detailTitle: String
}
