//
//  ViewController.swift
//  Project15
//
//  Created by Dmytro Kholodov on 5/29/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0

    @IBOutlet var angle: UISlider!
    @IBOutlet var x: UISlider!
    @IBOutlet var y: UISlider!
    @IBOutlet var z: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {

        let original = self.imageView.layer.transform

        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.imageView.transform = CGAffineTransform(scaleX: 4, y: 4)
        }

        animator.addAnimations({
            self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
        }, delayFactor: 0.2)

        animator.addAnimations({
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, delayFactor: 0.2)

        animator.addAnimations({
            self.imageView.transform = CGAffineTransform(rotationAngle: 1.5 * .pi)
        }, delayFactor: 0.2)


        animator.addCompletion { (r) in
            self.imageView.layer.transform = original
        }

        animator.startAnimation()
    }

    @IBAction func changeSettings(_ sender: UISlider) {
        let a = CGFloat(angle!.value)
        let xx = CGFloat(x!.value)
        let yy = CGFloat(y!.value)
        let zz = CGFloat(z!.value)

        let t = CATransform3DIdentity
        self.imageView.layer.transform = CATransform3DRotate(t, a, xx, yy, zz)
    }

    @IBAction func tapped_(_ sender: UIButton) {
        sender.isHidden = true


        let animator = {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity

            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity

            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity

            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green

            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear

            default:
                break
            }

        }

        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: animator)
        { finished in
            sender.isHidden = false
        }

        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }

}

