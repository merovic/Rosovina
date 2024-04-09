//
//  LocationPickerView.swift
//  Hareef
//
//  Created by Amir Ahmed on 15/05/2023.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import MapKit
import MOLH

class LocationPickerView: UIViewController, GMSMapViewDelegate {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var currentLocationName:String?
    var currentLocationAddress:String?
    var currrentLocationCoordinates:CLLocationCoordinate2D?
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var googleMapsView: GMSMapView!
        
    @IBOutlet weak var markerImage: UIImageView!
    
    //public var completion: ((HareefPlaceAPI?) -> ())?
        
    var isLocationWithSearch = false
    
    var isFirstRunOfPage = true
        
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.prettyHareefButton(radius: 16.0)

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        let filter = GMSAutocompleteFilter()
        filter.countries = ["EG", "SA"]

        resultsViewController?.autocompleteFilter = filter

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        let subView = UIView(frame: CGRect(x: 0, y: 100.0, width: UIScreen.main.bounds.size.width - 50, height: 25.0))
        subView.backgroundColor = UIColor.clear
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.showsCancelButton = false

        searchController?.searchBar.placeholder = MOLHLanguage.isRTLLanguage() ? "بحث" : "Search"

        //navigationItem.titleView = searchController?.searchBar


        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.text = ""

        googleMapsView.delegate = self

        googleMapsView.isMyLocationEnabled = true
        googleMapsView.settings.myLocationButton = true
                
    }
        
    override func viewWillAppear(_ animated: Bool) {
        isFirstRunOfPage = true
    }
    
    func findMyLocation(){
        isFirstRunOfPage = true
        mapViewDidFinishTileRendering(googleMapsView)
    }
    
    @IBAction func sateViewClicked(_ sender: Any) {
        if googleMapsView.mapType == .satellite{
            googleMapsView.mapType = .normal
        }else{googleMapsView.mapType = .satellite}
    }
    
    
    @IBAction func currentLocationClicked(_ sender: Any) {
        findMyLocation()
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if isFirstRunOfPage{
            let location = mapView.myLocation
            
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude) ?? 0.0, longitude:(location?.coordinate.longitude) ?? 0.0, zoom: 18.0)
            currrentLocationCoordinates = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude) ?? 0.0, longitude: (location?.coordinate.longitude) ?? 0.0)
            mapView.animate(to: camera)
            
            isFirstRunOfPage = false
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if !isLocationWithSearch {
            var address: String = ""
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)

            geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "ar_EG"), completionHandler: { (placemarks, error) -> Void in

                // Place details
                var placeMark: CLPlacemark?
                placeMark = placemarks?[0]

                // Building number
                if let buildingNumber = placeMark?.subThoroughfare {
                    address += buildingNumber + ", "
                }

                // Street address
                if let street = placeMark?.thoroughfare {
                    address += street + ", "
                }

                // Area
                if let area = placeMark?.subLocality {
                    address += area + ", "
                }

                // City
                if let city = placeMark?.subAdministrativeArea {
                    address += city + ", "
                }

                // Locality
                if let locality = placeMark?.locality {
                    address += locality + ", "
                }

                // Country
                if let country = placeMark?.country {
                    address += country
                }

                print(address)

                self.currentLocationLabel.text = address
                
                self.currentLocationName = address
                self.currentLocationAddress = address
                self.currrentLocationCoordinates = position.target
            
            })

            UIView.animate(withDuration: 0.02) {
              self.view.layoutIfNeeded()
            }
        }else{isLocationWithSearch.toggle()}
    }
    
    
    @IBAction func confirmLocation(_ sender: Any) {
        let place = GooglePlaceLocation(locationName: currentLocationName ?? "no_address_returned".localized, locationAddress: currentLocationAddress ?? "no_address_returned".localized, locationCoordinates: currrentLocationCoordinates!)
       
        let newViewController = AddAddressView()
        newViewController.viewModel = AddAddressViewModel(mapLocation: place)
        self.navigationController?.pushViewController(newViewController, animated: true)
        
//        self.completion?(HareefPlaceAPI(id: 0, place: place))
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

// Handle the user's selection.
extension LocationPickerView: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {

    isFirstRunOfPage = false
    isLocationWithSearch = true
    searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(place.name ?? "NAME")")
    print("Place address: \(place.formattedAddress ?? "ADDRESS")")
    print("Place attributions: \(String(describing: place.attributions))")

    let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 18.0)
    googleMapsView.animate(to: camera)

    self.currentLocationLabel.text = place.formattedAddress!
      
    currentLocationName = place.name!
    currentLocationAddress = place.formattedAddress!
    currrentLocationCoordinates = place.coordinate

  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

}

struct GooglePlaceLocation{
    var locationName:String?
    var locationAddress:String?
    var locationCoordinates:CLLocationCoordinate2D?
    
     init(locationName:String,locationAddress:String,locationCoordinates:CLLocationCoordinate2D) {
        self.locationName = locationName
        self.locationAddress = locationAddress
        self.locationCoordinates = locationCoordinates
    }
}

