//
//  ContentView.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 09.04.2023.
//

import SwiftUI
import MapKit

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var searchResults: [MKLocalSearchCompletion] = []

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed with error: \(error.localizedDescription)")
    }
}

struct ContentView: View {

    @State private var search: String = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    
    private let searchCompleter = MKLocalSearchCompleter()
    private let searchCompleterDelegate = SearchCompleterDelegate()
    
    @State var showProgressView: Bool = false

    var body: some View {
        VStack {
            textField
            
            if showProgressView {
                ProgressView()
            }
            
            SearchResultsList(searchResults: searchCompleterDelegate.searchResults)
        }
    }
}

extension ContentView {
    private var textField: some View {
        TextField("Search", text: $search)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: search, perform: { query in
                if !query.isEmpty {
                    
                    // For progressView indicator
                    if searchCompleterDelegate.searchResults == [] {
                        showProgressView = true
                    } else {
                        showProgressView = false
                    }
                    
                    searchCompleter.queryFragment = query
                    searchCompleter.delegate = searchCompleterDelegate
                    searchCompleter.resultTypes = .address
                    searchCompleter.region = MKCoordinateRegion(MKMapRect.world)
                    
                } else {
                    searchCompleterDelegate.searchResults = []
                }
            })
    }
}

struct SearchResultsList: View {

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
