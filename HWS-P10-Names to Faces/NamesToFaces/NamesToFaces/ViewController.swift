//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/14/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    PersonCellDelegate
{

    #if USE_CODABLE
    let KEY = "persons-with-codable"
    #else   // NSSecureCoding
    let KEY = "persons"
    #endif

    var persons = [PersonOnTwitter]()

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


        #if USE_CODABLE
        let ud = UserDefaults.standard
        if let savedPersons = ud.object(forKey: KEY) as? Data {
            persons = (try? JSONDecoder()
                .decode([PersonOnTwitter].self,
                        from: savedPersons))
                ?? []
        }
        #else   // NSSecureCoding
        let ud = UserDefaults.standard
        if let savedPersons = ud.object(forKey: KEY) as? Data {
            if let decodedPersons = try? NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(savedPersons) as? [PersonOnTwitter] {
                persons = decodedPersons
            }
        }
        #endif
    }

    // MARK:

    @objc func addNewPerson() {
        let picker = UIImagePickerController()

        picker.sourceType =
            UIImagePickerController.isSourceTypeAvailable(.camera) ?
                .camera : .photoLibrary
        
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

        let person = PersonOnTwitter(name: "Unknown", image: imageName, handler: "")
        persons += [person]

        collectionView.reloadData()

        save()

        dismiss(animated: true)
    }


    // MARK: PersonCellDelegate

    func didTapPersonCellImageViewAt(person: PersonOnTwitter) {
        if let index = persons.firstIndex(of: person) {
            let ac = UIAlertController(title: nil, message: "Are you want to forget \(person.name)?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Forget", style: .destructive) { action in
                self.persons.remove(at: index)
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.deleteItems(at: [indexPath])
                self.save()
            }
            ac.addAction(deleteAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }


    func didTapPersonCellNameViewAt(person: PersonOnTwitter) {
        if let index = persons.firstIndex(of: person) {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()

            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                guard let newName = ac.textFields?[0].text else { return }
                person.name = newName

                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                self.save()
            })

            present(ac, animated: true)
        }
    }
    // MARK: CollectionView delegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell
            else { fatalError("Can't dequeue Person cell!")}

        let person = persons[indexPath.item]
        cell.person = person
        cell.delegate = self

        let url = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: url.path)

        return cell
    }

    // MARK: helpers


    private func getDocumentsDirectory() -> URL {
        let paths = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }


    #if USE_CODABLE
    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(persons) {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let txt = String(data: data, encoding: .utf8)
            print(txt)
            let ud = UserDefaults.standard
            ud.set(data, forKey: KEY)
        } else {
            fatalError("Failed to sabe data!")
        }
    }
    #else   // NSSecureCoding
    func save() {
        if let savedData = try? NSKeyedArchiver
            .archivedData(withRootObject: persons, requiringSecureCoding: true) {
            let ud = UserDefaults.standard
            ud.set(savedData, forKey: KEY)
        } else {
            fatalError("Failed to sabe data!")
        }
    }
    #endif
}
