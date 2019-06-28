//
//  ViewController.swift
//  Project22
//
//  Created by Dmytro Kholodov on 6/17/19.
//  Copyright © 2019 TheHackingWithSwift. All rights reserved.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?

    @IBOutlet var label: BoxLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.layer.cornerRadius = label.bounds.maxX / 2
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    var beaconsRemembered = Set<UUID>()

    func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion)
    {
        // Update with any first Beacon
        update(distance: beacons.first?.proximity ?? .unknown)

        // Promt if we got a new Beacon
        beacons
            .first(where: {
                !beaconsRemembered
                    .contains($0.proximityUUID)
            }).flatMap(promtAbout)
    }

    func promtAbout(new beacon: CLBeacon) {}

    func startScanning() {
        let uuid = UUID(uuidString: "FD949150-2EC3-4C39-81B6-6B1A0F5CFA02")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)

        pulse()
    }


    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.label.text = "UNKNOWN"

            case .far:
                self.view.backgroundColor = UIColor.blue
                self.label.text = "FAR"

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.label.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.label.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = UIColor.gray
                self.label.text = "UNKNOWN"
            }

        }
    }

    func pulse() {
        label.padding = 50
        label.layer.borderWidth = 0.5
        label.textColor = .white
        label.clipsToBounds = true


        UIView.animate(withDuration: 0.5, animations: {  self.label.isHidden = false })
        
        let colorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        colorAnimation.fromValue = UIColor.white.cgColor
        colorAnimation.toValue = UIColor.lightGray.cgColor
        label.layer.borderColor = UIColor.white.cgColor

        let widthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        widthAnimation.fromValue = 0.5
        widthAnimation.toValue = 2
        widthAnimation.duration = 1
        label.layer.borderWidth = 0.5

        let bothAnimations = CAAnimationGroup()
        bothAnimations.duration = 1
        bothAnimations.animations = [colorAnimation, widthAnimation]
        bothAnimations.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        bothAnimations.repeatCount = 1000000

        label.layer.add(bothAnimations, forKey: "color and width")
    }
}

