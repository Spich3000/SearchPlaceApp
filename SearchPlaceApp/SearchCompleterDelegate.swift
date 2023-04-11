//
//  SearchCompleterDelegate.swift
//  SearchPlaceApp
//
//  Created by Дмитрий Спичаков on 11.04.2023.
//

import MapKit
import Combine


class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {

    private let subject = PassthroughSubject<[MKLocalSearchCompletion], Never>()

    var resultsPublisher: AnyPublisher<[MKLocalSearchCompletion], Never> {
        subject.eraseToAnyPublisher()
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        subject.send(completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed with error: \(error.localizedDescription)")
    }
}
