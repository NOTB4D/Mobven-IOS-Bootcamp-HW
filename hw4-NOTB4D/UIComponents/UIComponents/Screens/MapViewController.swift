//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationPermission()
        addLongGestureRecognizer()
    }

    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }


    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Pinned"
        mapView.addAnnotation(annotation)
    }

    
    
    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
        case .denied, .restricted:
            
            // uydulama location ayarlarına izin vermediyse burdan
            //ayarlar penceresine gitmesi için gereken func cagırılır
            showPermissionAlert()

            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }

    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")

        mapView.setCenter(coordinate, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
    func showPermissionAlert() {
        // popup sayfası mesajlarını ayarlar
        let alert = UIAlertController(title: "Location access required to get your current location", message: "Please allow location access", preferredStyle: .alert)
                
        // ayar butonu ayarı
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in

                    // //location izni sayfasını acar
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                })
        //  iptal butonu ayarı
         let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        alert.preferredAction = settingsAction

        self.present(alert, animated: true, completion: nil)
            
    }
}

extension MapViewController: MKMapViewDelegate {

}
