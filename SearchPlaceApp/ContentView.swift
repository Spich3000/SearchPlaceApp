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
            
            if let selectedResult {
                Text(selectedResult.title)
                Text(getCountry(selectedResult.subtitle))
            }
            
            if showProgressView {
                ProgressView()
            }
            
            SearchResultsList(selectedResult: $selectedResult, searchResults: searchResults)
        }
        .onReceive(searchCompleterDelegate.resultsPublisher) { results in
            searchResults = results
            showProgressView = false
        }
    }
    
    func getCountry(_ input: String) -> String {
        var output: String = ""
        if let subtitleComponents = input.split(separator: ",").map(String.init) as? [String] {
            if subtitleComponents.count >= 2 {
                output = (subtitleComponents.last ?? String())
            } else {
                output = input
            }
        }
        return output
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
