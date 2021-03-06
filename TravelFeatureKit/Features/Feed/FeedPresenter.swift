import UIKit
import TravelKit

typealias FeedPresenter = FeaturePresenter<FeedViewController, FeedAdapter>

class FeedAdapter: FeatureAdapter {
    typealias Content = Feed.Data
    typealias ViewModel = Feed.ViewModel

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  DateFormatter.dateFormat(fromTemplate: "MM/dd", options: 0, locale: Locale.current)
        return formatter
    }()

    func makeViewModel(viewState: ViewState<Feed.ViewModel.Content>) -> Feed.ViewModel {
        return Feed.ViewModel(
            state: viewState,
            title: ""
        )
    }

    func makeContentViewModel(content: Feed.Data) throws -> Feed.ViewModel.Content {
        return Feed.ViewModel.Content(
            rows: makeFeedCardRows(content),
            availableRegions: makeAvailableRegions(content),
            selectedRegion: makeSelectedRegion(content)
        )
    }

    private func makeSelectedRegion(_ content: Feed.Data) -> Feed.ViewModel.Content.Region? {
        guard let regionId = content.selectedRegionId,
            let region = (content.regions.filter { $0.id == regionId }).first else { return nil }

        return Feed.ViewModel.Content.Region(
            id: regionId,
            name: region.name
        )
    }

    private func makeAvailableRegions(_ content: Feed.Data) -> [Feed.ViewModel.Content.Region] {
        return content.regions.map {
            Feed.ViewModel.Content.Region(
                id: $0.id,
                name: $0.name
            )
        }
    }

    private func makeFeedCardRows(_ content: Feed.Data) -> [FeedCardViewModel] {
        return getSortedTrips(content).map { trip in
            currencyFormatter.currencyCode = trip.currency
            return FeedCardViewModel(
                direction: R.string.localizable.feedBothWaysTitle(),
                trip: makeTripString(trip),
                price: formatCurrency(trip),
                dateRange: dateRange(trip),
                routeName: R.string.localizable.feedBookTitle(),
                imageUrl: makeTripImageURL(trip, content: content),
                route: Feed.Route.book(trip),
                isExpired: trip.expiresAt <= Date()
            )
        }
    }

    private func makeTripString(_ trip: Trip) -> String {
        guard let from = trip.departure.city,
            let to = trip.destination.city else { return "" }

        return "\(from) \n\(to)"
    }

    private func makeTripImageURL(_ trip: Trip, content: Feed.Data) -> URL? {
        return content.tripImages
            .filter { $0.tripId == trip.id }
            .first?
            .imageURL
    }

    private func dateRange(_ trip: Trip) -> String {
        return "\(dateFormatter.string(from: trip.departureAt)) - \(dateFormatter.string(from: trip.returnAt))"
    }

    private func formatCurrency(_ trip: Trip) -> String {
        let price = trip.price
        let currency = trip.currency
        currencyFormatter.currencyCode = currency

        return currencyFormatter.string(from: NSNumber(value: price)) ?? "\(price) \(currency)"
    }

    // MARK: - Sorting of trips

    private func getSortedTrips(_ content: Feed.Data) -> [Trip] {
        let validTrips = content.trips
            .filter { !self.isExpired($0) }
            .sorted(by: tripDateSort)

        let expiredTrips = content.trips
            .filter { self.isExpired($0) }
            .sorted(by: tripDateSort)

        return validTrips + expiredTrips
    }

    private func tripDateSort(_ lTrip: Trip, rTrip: Trip) -> Bool {
        return lTrip.createdAt < rTrip.createdAt
    }

    private func isExpired(_ trip: Trip) -> Bool {
        return trip.expiresAt <= Date()
    }
}
