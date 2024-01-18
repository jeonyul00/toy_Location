//
//  ViewController.swift
//  Location
//
//  Created by 전율 on 2024/01/18.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Landmark"
        self.mapView.delegate = self
        
        PinLandmark.allCases.forEach { landmark in
            let pin = CustomMKPointAnnotation()
            pin.id = landmark.id
            pin.title = landmark.title
            pin.coordinate = landmark.coordinate
            self.mapView.addAnnotation(pin)
        }
        
    }
    
}

extension MainViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let hasView = view.annotation as? CustomMKPointAnnotation, let id = hasView.id else { return }
        let selectedPin = PinLandmark(rawValue: id)
        if let url = selectedPin?.url {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.url = url
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

class CustomMKPointAnnotation: MKPointAnnotation {
    var id:Int?
}
