//
//  NewRunViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 10/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewRunViewController: UIViewController {

    @IBOutlet weak var StartLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //run contains the hole run and all locations.
    private var run: Run?
    
    //Dette er locationmanager fra Locationmanager i Suportfiles
    private let locationManager = LocationManager.shared
    //Din løbe tid i sec
    private var seconds = 0
    //Denne vil køre hver sec og opdatere UI
    private var timer: Timer?
    //Distance for din løbe runte
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    //Et array der har alle dine lokationer fra din route.
    private var locationList: [CLLocation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.isHidden = true
        distanceLabel.isHidden = true
        paceLabel.isHidden = true
        mapView.isHidden = true
    }
    
    //timer and locationManager stops when view is closed. to save energy and process speed.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func startBtn(_ sender: Any) {
        startRun()
    }
    
    //UI alert show and give you 3 options.
    @IBAction func stopBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRun()
            self.saveRun()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    //startrun. hide and shows the right info on screen and start timer and location manager to start a run.
    private func startRun() {
        StartLabel.isHidden = true
        mapView.isHidden = false
        timeLabel.isHidden = false
        distanceLabel.isHidden = false
        paceLabel.isHidden = false
        startButton.isHidden = true
        stopButton.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    //stoprun, hides and show the info that is needed and stops the locationmanager.
    private func stopRun() {
        StartLabel.isHidden = false
        startButton.isHidden = false
        
        stopButton.isHidden = true
        mapView.isHidden = true
        timeLabel.isHidden = true
        distanceLabel.isHidden = true
        paceLabel.isHidden = true
        
        locationManager.stopUpdatingLocation()
    }
    
    //runs every sec and it counts the sec and updating the display.
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    //updates the display to show the info that is captured of the run.
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        print("Distance:  \(formattedDistance)")
        print("Time:  \(formattedTime)")
        print("Pace:  \(formattedPace)")
    }
    
    //this starts the location updates and set the activitytime and the filter (The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 3
        locationManager.startUpdatingLocation()
    }
    
    //save run adds alle the info needed for a run to the new run object. and saves it to core data.
    private func saveRun() {
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        run = newRun
    }
}

// Navigation with sequeHandler
extension NewRunViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "RunDetails"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! RunDetailsViewController
            destination.run = run
        }
    }
}

//Location Manager Delegate
extension NewRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            //guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

//Map View Delegate
extension NewRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

