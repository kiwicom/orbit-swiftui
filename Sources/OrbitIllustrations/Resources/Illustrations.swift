import Foundation
import Orbit
import SwiftUI

public extension Illustration {

    enum Asset: String, CaseIterable, AssetNameProviding {
        case none
        
        case accommodation
        case airHelp
        case airportShuttle
        case airportTransport
        case airportTransportTaxi
        case ambulance
        case appKiwi
        case appQRCode
        case baggageDrop
        case boarding
        case boardingPass
        case businessTravel
        case cabinBaggage
        case cancelled
        case chatbot
        case compassCollectPoints
        case compassDemoted
        case compassEmailAdventurer
        case compassEmailCaptain
        case compassEmailPromoted
        case compassEmailPromotedCaptain
        case compassEmailScout
        case compassPoints
        case compassSaveOnBooking
        case compassTravelPlan
        case damage
        case desktopSearch
        case eVisa
        case enjoyApp
        case error
        case error404
        case fareLock
        case fareLockSuccess
        case fastBooking
        case fastTrack
        case fastTrackMan
        case feedback
        case flexibleDates
        case flightDisruptions
        case groundTransport404
        case help
        case improve
        case insurance
        case inviteAFriend
        case login
        case lounge
        case mailbox
        case meal
        case mobileApp
        case mobileApp2
        case money
        case musicalInstruments
        case netVerify
        case noBookings
        case noFavoriteFlights
        case noFlightChange
        case noNotification
        case noResults
        case nomad
        case nomadNeutral
        case offline
        case onlineCheckIn
        case openSearch
        case parking
        case pets
        case placeholderAirport
        case placeholderDestination
        case placeholderHotel
        case placeholderTours
        case planeAndMoney
        case planeDelayed
        case priorityBoarding
        case rating
        case referAFriend
        case rentalCar
        case seating
        case specialAssistance
        case sportsEquipment
        case success
        case ticketFlexi
        case time
        case timelineBoarding
        case timelineDropBaggage
        case timelineLeave
        case timelinePick
        case tours
        case train
        case transportBus
        case transportTaxi
        case wheelchair
        case womanWithPhone

        public var assetName: String {
            self == .none ? "" : defaultAssetName
        }
    }
}

public extension Image {
    
    /// Creates an image for selected Orbit illustration asset.
    static func orbit(illustration: Illustration.Asset) -> Self {
        self.init(illustration.assetName, bundle: .module)
    }
}
