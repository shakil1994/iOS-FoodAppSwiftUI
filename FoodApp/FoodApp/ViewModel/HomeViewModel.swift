//
//  HomeViewModel.swift
//  FoodApp
//
//  Created by Md Shah Alam on 10/15/21.
//

import SwiftUI
import CoreLocation
import Firebase

//Fatching User Location...
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    //Location Details...
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    //Menu...
    @Published var showMenu = false
    
    //Item Data...
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Checking location access...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            //Direct Call
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Reading user location and extracting details...
        self.userLocation = locations.last
        self.extractLocation()
        //After Extracting Location Logging in...
        self.login()
    }
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation){
            (res, err) in
            guard let safeData = res else {return}
            var address = ""
            
            //Getting area and locality name...
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }
    
    //Anynomus login for reading database...
    func login() {
        Auth.auth().signInAnonymously{ (res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            
            //After Logging in Fetching Data...
            self.fetchData()
        }
    }
    
    //Fetching Items Data...
    func fetchData() {
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments{(snap, err) in
            guard let itemData = snap else {return}
            self.items = itemData.documents.compactMap({(doc) -> Item? in
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_rating") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_rating: ratings)
            })
            self.filtered = self.items
        }
    }
    
    //Search of Filter...
    func filterData() {
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
}
