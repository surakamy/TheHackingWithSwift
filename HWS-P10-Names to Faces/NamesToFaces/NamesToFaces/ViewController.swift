//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/14/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var persons = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1254901961, blue: 0.1294117647, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9176470588, green: 0.3882352941, blue: 0.5490196078, alpha: 1)
        navigationController?.navigationBar.barStyle = .blackOpaque

        let toolbar = UIToolbar()
        toolbar.barStyle = .blackOpaque
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        ]
        navigationItem.titleView = toolbar

        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK:

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        picker.view!.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1254901961, blue: 0.1294117647, alpha: 1)
        picker.view!.tintColor = #colorLiteral(red: 0.9176470588, green: 0.3882352941, blue: 0.5490196078, alpha: 1)
        present(picker, animated: true)
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.7) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        persons += [person]

        collectionView.reloadData()

        dismiss(animated: true)
    }


    // MARK: UINavigationControllerDelegate


    // MARK: CollectionView delegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell
            else { fatalError("Can't dequeue Person cell!")}
        let person = persons[indexPath.item]
        cell.nameView.text = person.name

        let url = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: url.path)

        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.maxX / 2
        cell.layer.cornerRadius = 7

        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = persons[indexPath.item]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let newName = ac.textFields?[0].text else { return }
            person.name = newName

            self.collectionView.reloadData()
        })

        present(ac, animated: true)
    }

    // MARK: helpers


    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

