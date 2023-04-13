//
//  SearchCompleterDelegate.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 11.04.2023.
//

import MapKit
import Combine

// ViewModel

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {

    let searchCompleter = MKLocalSearchCompleter()

    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedResult: MKLocalSearchCompletion? = nil

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed with error: \(error.localizedDescription)")
    }
    
    private func getСity(_ cityInput: [String]) -> String {
        cityInput.first ?? ""
    }
    
    private func getCountry(_ countryInput: [String]) -> String {
        guard countryInput.count >= 2 else { return countryInput.first ?? "" }
        return countryInput.last ?? ""
    }
    
    func getPlace() -> (city: String, country: String) {
        let cityComponents = selectedResult?.title.components(separatedBy: ",") ?? [] // Prepare city components
        let countryComponents = selectedResult?.subtitle.components(separatedBy: ",") ?? [] // Prepare country components
        
        var city = getСity(cityComponents)
        var country = getCountry(countryComponents)
        
        if selectedResult?.subtitle == "" {
            if cityComponents.count == 1 {
                city = "" // Case with country in title components
            }
            country = getCountry(cityComponents) // Get country from title components
        }
        return (city, country)
    }
    
}
