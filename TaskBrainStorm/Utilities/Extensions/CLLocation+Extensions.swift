//
//  CLLocation+Extensions.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import CoreLocation

extension CLLocation {
    func getCountry(completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(self) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let country = placemarks?.first?.country {
                completion(country)
            } else {
                completion(nil)
            }
        }
    }
}
