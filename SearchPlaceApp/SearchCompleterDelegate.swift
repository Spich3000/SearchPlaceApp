//
//  SearchCompleterDelegate.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 11.04.2023.
//

import MapKit
import Combine

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {

    let searchCompleter = MKLocalSearchCompleter()

    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed with error: \(error.localizedDescription)")
    }
    
    func getСity(_ cityInput: [String]) -> String {
        cityInput.first ?? ""
    }
    
    func getCountry(_ countryInput: [String]) -> String {
        guard countryInput.count >= 2 else { return countryInput.first ?? "" }
        return countryInput.last ?? ""
    }
    
    func getPlace(_ input: MKLocalSearchCompletion?) -> (city: String, country: String) {
        let cityComponents = input?.title.components(separatedBy: ",") ?? []
        let countryComponents = input?.subtitle.components(separatedBy: ",") ?? []
        
        var city = getСity(cityComponents)
        var country = getCountry(countryComponents)
        
        if input?.subtitle == "" {
            if cityComponents.count == 1 {
                city = ""
            }
            country = getCountry(cityComponents)
        }
        
        return (city, country)
    }
}
