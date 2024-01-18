//
//  PinLandmark.swift
//  Location
//
//  Created by 전율 on 2024/01/18.
//

import Foundation
import MapKit

enum PinLandmark:Int,CaseIterable {
    case Deoksugung
    case Gyeongbokgung
    case SeoulCityHall
}

extension PinLandmark {
    var id: Int {
        return self.rawValue
    }
    var title: String {
        return "\(self)"
    }
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .Deoksugung:
            return CLLocationCoordinate2D(latitude: 37.5658049, longitude: 126.9751461)
        case .Gyeongbokgung:
            return CLLocationCoordinate2D(latitude: 37.579617, longitude: 126.977041)
        case .SeoulCityHall:
            return CLLocationCoordinate2D(latitude: 37.5666612, longitude: 126.9783785)
        }
    }
    
    var url:URL? {
        switch self {
        case .Deoksugung:
            return .init(string: "http://www.deoksugung.go.kr")
        case .Gyeongbokgung:
            return .init(string: "https://www.royalpalace.go.kr")
        case .SeoulCityHall:
            return .init(string: "https://www.seoul.go.kr")
        }
    }
    
}
