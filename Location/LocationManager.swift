//
//  LocationManager.swift
//  Location
//
//  Created by 전율 on 2024/01/18.
//

import Foundation
import CoreLocation

class LocationManager:NSObject {
    
    var manager = CLLocationManager()
    var completion: ((CLLocation)->Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        // 1. (앱을 사용하는 동안) 권한 요청
        manager.requestWhenInUseAuthorization()
    }
    
    func getMyLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 2. 권한이 변경되면 호출
    // 권한 요청 결과 조회
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // 허용
            // 내 위치 가져오기
            // 3. 내 위치 업데이트
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // 내 위치 항상 허용
            break
        case .notDetermined:
            // 안 물어봄
            manager.requestWhenInUseAuthorization()
            break
        case .denied:
            // 허용 안함
            break
        case .restricted:
            // 허용 못함
            break
        default:
            break
        }
    }
    
    // 4. 업데이트 된 내 위치 조회
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.completion?(location)
    }
    
}
