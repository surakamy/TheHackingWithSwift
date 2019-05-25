//
//  ViewController.swift
//  Instafilter
//
//  Created by Dmytro Kholodov on 5/24/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var buttonFilter: UIButton!
    @IBOutlet var visualEffects: UIVisualEffectView!
    var context: CIContext!
    var currentFilter: CIFilter! {
        didSet {
            let filterTitle = currentFilter.name
                .dropFirst("CI".count)
                .uppercased()
            self.buttonFilter.setTitle(filterTitle, for: .normal)
        }
    }

    var originalImage: UIImage!

    var currentImage: UIImage! {
        didSet {
            self.view.backgroundColor = UIColor(patternImage: currentImage)
            self.imageView.image = self.currentImage
            self.imageView.transform = CGAffineTransform(scaleX: -0.7, y: -0.7)

            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, delay: 0.1, options: [.curveEaseInOut], animations: {
                    self.imageView.transform = CGAffineTransform.identity
                })
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let imageFrame = self.imageView.superview?.bounds {
            self.imageView.frame = imageFrame.insetBy(dx: 10, dy: 10)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "\\_🦆_🦆_🦆_/"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")

        prevIntensity = intensity.value
    }


    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else {
            return
        }

        guard let actionTitle = action.title else {
            return
        }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)

        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func intensityChange(_ sender: Any) {
        applyProcessing()
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()

        picker.allowsEditing = true
        picker.delegate = self

        present(picker, animated: true)
    }

    let filterQueue = DispatchQueue(label: "Picture filter")
    var prevIntensity: Float = 0
    func applyProcessing3() {
        let value = self.intensity.value
        if abs(prevIntensity - value) < 0.1 {
            print("skip")
            return
        }

            guard let image = self.currentFilter?.outputImage else {return}
            guard let currentFilter = self.currentFilter else { return }
            guard let currentImage = self.currentImage else { return }
            let inputKeys = currentFilter.inputKeys

            if inputKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(value, forKey: kCIInputIntensityKey)
            }

            if inputKeys.contains(kCIInputRadiusKey) {
                currentFilter.setValue(value * 200, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentFilter.setValue(value * 10, forKey: kCIInputScaleKey)
            }
            if inputKeys.contains(kCIInputCenterKey) {
                currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
            }

            if let cgimg = self.context.createCGImage(image, from: image.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                self.imageView.image = processedImage
            }

    }



    private var pendingFilterWorkItem: DispatchWorkItem?

    func applyProcessing() {
        let value = self.intensity.value

        pendingFilterWorkItem?.cancel()

        guard let image = self.currentFilter.outputImage else {return}

        let requestWorkItem = DispatchWorkItem { [weak self] in
            print("DOING STH.............\(value)")

            guard let currentFilter = self?.currentFilter else { return }
            guard let currentImage = self?.currentImage else { return }
            let inputKeys = currentFilter.inputKeys

            if inputKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(value, forKey: kCIInputIntensityKey)
            }

            if inputKeys.contains(kCIInputRadiusKey) {
                currentFilter.setValue(value * 200, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentFilter.setValue(value * 10, forKey: kCIInputScaleKey)
            }
            if inputKeys.contains(kCIInputCenterKey) {
                currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
            }


            if let cgimg = self?.context.createCGImage(image, from: image.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                DispatchQueue.main.async {
                    self?.imageView.image = processedImage
                }
            }
        }
        pendingFilterWorkItem = requestWorkItem

        filterQueue.sync(execute: requestWorkItem)
    }


    func resizedImage(_ image: UIImage, for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picture = info[.editedImage] as? UIImage else { return }
        originalImage = picture

        let ratio = imageView.bounds.size.width / picture.size.width
        let previewSize = CGSize(width: picture.size.width * ratio, height: picture.size.height * ratio )
        guard let preview = resizedImage(picture, for: previewSize) else { return }

        let beginImage = CIImage(image: preview)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()


        currentImage = preview

        dismiss(animated: true)
    }
}


/// The Throttler will ignore work items until the time limit for the preceding call is over.
public final class Throttler {

    // MARK: - Properties

    public let limit: TimeInterval
    public private(set) var lastExecutedAt: Date?

    private let syncQueue = DispatchQueue(label: "com.stackexchange.throttle", attributes: [])

    /// Initialize a new throttler with given time interval.
    ///
    /// - Parameter limit: The number of seconds for throttle work items.
    public init(limit: TimeInterval) {
        self.limit = limit
    }

    /// Submits a work item and ensures it is not called until the delay is completed.
    ///
    /// - Parameter block: The work item to be invoked on the throttler.
    @discardableResult public func execute(_ block: () -> Void) -> Bool {
        let executed = syncQueue.sync { () -> Bool in
            let now = Date()

            // Lookup last executed
            let timeInterval = now.timeIntervalSince(lastExecutedAt ?? .distantPast)

            // If the time since last execution is greater than the limit, execute
            if timeInterval > limit {
                // Record execution
                lastExecutedAt = now

                // Execute
                return true
            }

            return false
        }

        if executed {
            block()
        }

        return executed
    }

    /// Cancels all work items to allow future work items to be executed with the specified delayed.
    public func reset() {
        syncQueue.sync {
            lastExecutedAt = nil
        }
    }
}
