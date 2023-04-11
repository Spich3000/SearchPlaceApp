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

    
    private let searchCompleter = MKLocalSearchCompleter()
    private let searchCompleterDelegate = SearchCompleterDelegate()

    var body: some View {
        VStack {
            textField

            if showProgressView {
                ProgressView()
            }

            SearchResultsList(searchResults: searchResults)
        }
        .onReceive(searchCompleterDelegate.resultsPublisher) { results in
            searchResults = results
            showProgressView = false
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
