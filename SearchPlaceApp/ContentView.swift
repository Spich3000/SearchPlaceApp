//
//  ContentView.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 09.04.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var searchVM = SearchCompleterDelegate()
    
    @State private var search: String = ""
    @State private var showProgressView: Bool = false

    var body: some View {
        VStack {
            textField
            selectedPlace
            progressView
            SearchResultsList(serchVM: searchVM)
        }
        .onReceive(searchVM.$searchResults) { _ in
            showProgressView = false
        }
    }
    
    // Showing selected place
    @ViewBuilder var selectedPlace: some View {
        if searchVM.selectedResult != nil {
            Text("City: \(searchVM.getPlace().city)")
            Text("Country: \(searchVM.getPlace().country)")
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
                    searchVM.searchCompleter.queryFragment = search
                    searchVM.searchCompleter.delegate = searchVM
                    searchVM.searchCompleter.resultTypes = .address
                    searchVM.searchCompleter.region = MKCoordinateRegion(MKMapRect.world)
                    showProgressView = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        searchVM.searchResults = []
                        showProgressView = false
                    }
                }
            })
    }
}

struct SearchResultsList: View {
    
    @ObservedObject var serchVM: SearchCompleterDelegate
    
    var body: some View {
        List(serchVM.searchResults, id: \.self) { result in
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(.headline)
                
                Text(result.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onTapGesture {
                serchVM.selectedResult = result
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
