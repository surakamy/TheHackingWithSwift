//
//  ViewController.swift
//  Capital Cities
//
//  Created by Dmytro Kholodov on 5/31/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import MapKit
import UIKit
import WebKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var contraint: NSLayoutConstraint!
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")


        let kyiv = Capital(title: "Kyiv", coordinate: CLLocationCoordinate2D(latitude: 50.45466, longitude: 30.5238), info: "Named after one of four legendary founders.")

        let hp = Capital(title: "Horishni Plavni", coordinate: CLLocationCoordinate2D(latitude: 49.0101814, longitude: 33.6356697), info: "Just a town with a fancy name.")

        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
        mapView.addAnnotation(kyiv)
        mapView.addAnnotation(hp)

        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }

        // 2
        let identifier = "Capital"

        // 3
        var annotationView = mapView
            .dequeueReusableAnnotationView(withIdentifier: identifier)
            .flatMap({$0 as? MKPinAnnotationView})

        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }

        annotationView?.pinTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, animations: {
            self.contraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, animations: {
            self.contraint.isActive = false
            self.view.layoutIfNeeded()
        })

        guard let name = view.annotation?.title else {return}
        guard let request = request(city: name ?? "") else {return}
        let controller = ViewHolderController {
            let webview = WKWebView()
            webview.load(request)
            return webview
        }
        controller.title = name
        if let nc = children.first as? UINavigationController {
            nc.view.clipsToBounds = true
            nc.view.layer.cornerRadius = 15.0
            nc.view.layer.borderWidth = 0.3
            nc.setViewControllers([controller], animated: false)
        } else {
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    private func nameForURL(_ value: String) -> String {
        return value.replacingOccurrences(of: " ", with: "_")
    }

    private func request(city: String) -> URLRequest? {
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(nameForURL(city))") {
            return URLRequest(url: url)
        }
        return nil
    }

}

