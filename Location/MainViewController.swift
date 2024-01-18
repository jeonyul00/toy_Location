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
    var searchController:UISearchController?
    var resultsController:SearchResultsTableViewController!
    var filteredLanmarks = [PinLandmark]()
    var locationManeger = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Landmark"
        self.mapView.delegate = self
        addPin()
        makeResultsController()
        makeSearchController()
        locationManeger.getMyLocation { location in
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true // 내 위치 표시
        }
        
    }
    
    private func addPin() {
        PinLandmark.allCases.forEach { landmark in
            let pin = CustomMKPointAnnotation()
            pin.id = landmark.id
            pin.title = landmark.title
            pin.coordinate = landmark.coordinate
            self.mapView.addAnnotation(pin)
        }
    }
    
    private func makeSearchController() {
        // searchResultsController: 결과화면, 필요없으면 nil
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self // UISearchController의 검색 결과를 업데이트
        searchController?.searchBar.autocapitalizationType = .none // 자동 대소문자 변경 제거
        navigationItem.searchController = searchController
    }
    
    private func makeResultsController() {
        resultsController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsTableViewController") as? SearchResultsTableViewController
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
    }
    
}

extension MainViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let hasView = view.annotation as? CustomMKPointAnnotation, let id = hasView.id else { return }
        let selectedPin = PinLandmark(rawValue: id)
        if let url = selectedPin?.url {
            self.navigationItem.title = selectedPin?.title
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.url = url
            self.navigationController?.pushViewController(detailVC, animated: true)
            // 셀렉트한 핀이 다시 디셀렉트 되도록 => ux
            self.mapView.deselectAnnotation(view.annotation, animated: true)
        }
    }
}

class CustomMKPointAnnotation: MKPointAnnotation {
    var id:Int?
}

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        cell.title.text = filteredLanmarks[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPin = PinLandmark(rawValue: filteredLanmarks[indexPath.row].id){
            self.navigationItem.title = selectedPin.title
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // zoom
            let region = MKCoordinateRegion(center: selectedPin.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            searchController?.isActive = false // 서치 컨트롤러 비활성화
        }
    }
    
}

extension MainViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        let pinAllList = PinLandmark.allCases
        filteredLanmarks = pinAllList.filter({ elements in
            // elements.title.contains(searchText)
            elements.title.lowercased().contains(searchText.lowercased())
        })
        resultsController.tableView.reloadData()
    }
}
