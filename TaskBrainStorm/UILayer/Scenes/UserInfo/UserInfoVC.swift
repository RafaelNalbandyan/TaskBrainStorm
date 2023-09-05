//
//  UserInfoVC.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit
import MapKit
import Kingfisher

final class UserInfoVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var userSavedView: UIView!
    
    
    // MARK: - Public methods
    
    public var viewModel: UserInfoVM!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        initialSetup(viewModel.user)
    }
    
    // MARK: - Private methods
    
    private func setupNavigation(user: UserProtocol) {
        let firstName = user.getFirstName() ?? ""
        let lastName = user.getLastName() ?? ""
        self.title = "\(firstName) \(lastName)"
    }
    
    private func initialSetup(_ user: UserProtocol) {
        setupNavigation(user: user)
        setupUserImageView(url: user.getImageUrl())
        setupInfoLabel(user)
        setupNameLabel(user)
        setupAddressLabel(user)
        countryLabel.text = user.getCountry()
        setupMapView(user)
        setupButtons()
    }
    
    private func setupUserImageView(url: String?) {
        self.userImageView.image = UIImage()
        guard let urlString = url,
              let url = URL(string: urlString) else { return }
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: nil,
                                  completionHandler: nil)
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 3
    }
    
    private func setupNameLabel(_ user: UserProtocol) {
        let firstName = user.getFirstName() ?? ""
        let lastName = user.getLastName() ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
    }
    
    private func setupInfoLabel(_ user: UserProtocol) {
        infoLabel.text = user.getInfo()
    }
    
    private func setupAddressLabel(_ user: UserProtocol) {
        addressLabel.text = user.getAddress()
    }
    
    private func setupMapView(_ user: UserProtocol) {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
//        mapView.isZoomEnabled = false
        mapView.showsUserLocation = true
        
        guard let lat = user.getLatitude(),
              let long = user.getLongitude(),
              let doubleLong = Double(long),
              let doubleLat = Double(lat) else {
            return
        }
        //        let latitude = CLLocationDegrees((-180...180 ~= doubleLat) ? doubleLat : 46)
        let latitude = CLLocationDegrees(doubleLat)
        let longitude = CLLocationDegrees(doubleLong)
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.setPositionInMap(latitude: latitude, longitude: longitude)
        })
    }
    
    private func setPositionInMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {

//        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749,
                                                          longitude: -122.4194) // San Francisko
            setRegion(coordinate: centerCoordinate)
            return
        }
        setRegion(coordinate: coordinate)
    }
    
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        let annotation = createPlaceAnnotation(coordinate: coordinate, title: "", subtitle: "")
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupButtons() {
        userSavedView.isHidden = !viewModel.isUserSaved
        removeButton.isHidden = !viewModel.isUserSaved
        saveButton.isHidden = viewModel.isUserSaved
    }
    
    private func createPlaceAnnotation(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) -> UserPlaceAnnotation {
        let userAnnotation = UserPlaceAnnotation(
            coordinate: coordinate,
            title: title,
            subtitle: subtitle)
        return userAnnotation
    }
    
    // MARK: - IBActions
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveToLocalDB()
        setupButtons()
    }
    
    @IBAction private func removeButtonTapped(_ sender: UIButton) {
        viewModel.removeFromLocalDB()
        setupButtons()
    }
}

extension UserInfoVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "UserPlaceAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "user_place_icon")
        return annotationView
    }
}
