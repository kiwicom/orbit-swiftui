import Foundation

public extension Illustration {

    enum Image: CaseIterable, AssetNameProviding {
        case none
        
        case accommodation
        case airHelp
        case airportShuttle
        case airportTransport
        case airportTransportTaxi
        case appQRCode
        case baggageDrop
        case boarding
        case boardingPass
        case businessTravel
        case cabinBaggage
        case desktopSearch
        case enjoyApp
        case error
        case error404
        case eVisa
        case fastTrack
        case fastTrackMan
        case feedback
        case groundTransport404
        case help
        case improve
        case inviteAFriend
        case login
        case lounge
        case mailbox
        case meal
        case mobileApp
        case money
        case netVerify
        case noBookings
        case noFavoriteFlights
        case noNotification
        case noResults
        case offline
        case onlineCheckIn
        case openSearch
        case parking
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
        case success
        case time
        case timelineBoarding
        case timelineDropBaggage
        case timelineLeave
        case timelinePick
        case tours
        case train
        case transportBus
        case transportTaxi
        case womanWithPhone

        public var assetName: String {
            self == .none ? "" : defaultAssetName
        }
    }
}
