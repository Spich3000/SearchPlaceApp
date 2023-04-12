//
//  ContentView.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 09.04.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var serchVM = SearchCompleterDelegate()
    
    @State private var search: String = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var selectedResult: MKLocalSearchCompletion? = nil
    @State private var showProgressView: Bool = false

    var body: some View {
        VStack {
            textField
            selectedPlace
            progressView
            SearchResultsList(selectedResult: $selectedResult, searchResults: serchVM.searchResults)
        }
        .onReceive(serchVM.$searchResults) { results in
            searchResults = results
            showProgressView = false
        }
    }
    
    // Showing selected place
    @ViewBuilder var selectedPlace: some View {
        if let selectedResult {
            Text("City: \(serchVM.getPlace(selectedResult).city)")
            Text("Country: \(serchVM.getPlace(selectedResult).country)")
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
                    serchVM.searchCompleter.queryFragment = search
                    serchVM.searchCompleter.delegate = serchVM
                    serchVM.searchCompleter.resultTypes = .address
                    serchVM.searchCompleter.region = MKCoordinateRegion(MKMapRect.world)
                    showProgressView = true
                } else {
                    serchVM.searchResults = []
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
