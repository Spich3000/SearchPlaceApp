//
//  ContentView.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 09.04.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var search: String = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showProgressView: Bool = false
    
    @State private var selectedResult: MKLocalSearchCompletion? = nil
    
    private let searchCompleter = MKLocalSearchCompleter()
    private let searchCompleterDelegate = SearchCompleterDelegate()
    
    var body: some View {
        VStack {
            textField
            selectedPlace
            progressView
            SearchResultsList(selectedResult: $selectedResult, searchResults: searchResults)
        }
        .onReceive(searchCompleterDelegate.resultsPublisher) { results in
            searchResults = results
            showProgressView = false
        }
    }
    
    func getСity(_ cityInput: String) -> String {
        let titleComponents = cityInput.split(separator: ",").map(String.init) as [String]
        return titleComponents.first ?? String()
    }
    
    func getCountry(_ countryInput: String) -> String {
        let subtitleComponents = countryInput.split(separator: ",").map(String.init) as [String]
        guard subtitleComponents.count >= 2 else { return countryInput }
        return subtitleComponents.last ?? ""
    }
    
    func getPlace(_ input: MKLocalSearchCompletion?) -> (city: String, country: String) {
        var city = getСity(input?.title ?? String())
        var country = ""
        
        if input?.subtitle != "" {
            country = getCountry(input?.subtitle ?? String())
        } else {
            if let titleComponents = input?.title {
                let components = titleComponents.split(separator: ",").map(String.init) as [String]
                if components.count == 1 {
                    city = ""
                }
            }
            country = getCountry(input?.title ?? String())
        }
        return (city, country)
    }
    
    
    
    // Showing selected place
    @ViewBuilder var selectedPlace: some View {
        if let selectedResult {
            Text("City: \(getPlace(selectedResult).city)")
            Text("Country: \(getPlace(selectedResult).country)")
        }
    }
    
    // Showing ProgressView
    @ViewBuilder var progressView: some View {
        if showProgressView {
            ProgressView()
        }
    }
}



extension ContentView {
    private var textField: some View {
        TextField("Search", text: $search)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: search, perform: { _ in
                if !search.isEmpty {
                    searchCompleter.queryFragment = search
                    searchCompleter.delegate = searchCompleterDelegate
                    searchCompleter.resultTypes = .address
                    searchCompleter.region = MKCoordinateRegion(MKMapRect.world)
                    showProgressView = true
                } else {
                    searchResults = []
                    showProgressView = false
                }
            })
    }
}

struct SearchResultsList: View {
    
    @Binding var selectedResult: MKLocalSearchCompletion?
    var searchResults: [MKLocalSearchCompletion]
    
    var body: some View {
        List(searchResults, id: \.self) { result in
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(.headline)
                
                Text(result.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onTapGesture {
                selectedResult = result
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//struct Place {
//    var input: MKLocalSearchCompletion?
//
//    var city: String {
//        let titleComponents = input?.title.split(separator: ",").map(String.init) as [String] ?? []
//        return titleComponents.first ?? ""
//    }
//
//    var country: String {
//        let subtitleComponents = input?.subtitle.split(separator: ",").map(String.init) as [String] ?? []
//        return subtitleComponents.last ?? (input?.subtitle ?? "")
//    }
//
//    var isSingleCity: Bool {
//        if let titleComponents = input?.title {
//            let components = titleComponents.split(separator: ",").map(String.init) as [String]
//            return components.count == 1
//        }
//        return false
//    }
//
//    var placeTuple: (city: String, country: String) {
//        let city = isSingleCity ? "" : self.city
//        let country = input?.subtitle != "" ? self.country : self.country
//        return (city, country)
//    }
//}
//
//// Usage
//@ViewBuilder var selectedPlace: some View {
//    if let selectedResult = selectedResult {
//        let place = Place(input: selectedResult)
//        Text("City: \(place.placeTuple.city)")
//        Text("Country: \(place.placeTuple.country)")
//    }
//}
