import Foundation

// swiftlint:disable type_body_length

public extension Icon {

    enum Symbol: String, Comparable, CaseIterable {

        // basic
        case alert
        case alertCircle
        case checkCircle
        case emptyCircle
        case filledCircle
        case circleSmall
        case bug
        case chat
        case check
        case circle
        case close
        case closeCircle
        case edit
        case editOff
        case email
        case filters
        case informationCircle
        case link
        case messages
        case messagesOutline
        case phone
        case plus
        case plusCircle
        case questionCircle
        case remove
        case search
        case settings
        case smoking
        case starFull
        case visibility
        case visibilityOff
        case visa
        case showMore
        case showLess
        case minus
        case accountCircle
        case infant
        case document
        case dealsV2

        // files
        case download

        // kiwicom
        case kiwicom
        case kiwicomGuarantee

        // money
        case atm
        case creditCard
        case exchange
        case money
        case promoCode
        case refund

        // navigation
        case chevronDown
        case chevronUp
        case chevronLeft
        case chevronRight
        case gallery
        case grid
        case list
        case menuMeatballs
        case newWindow
        case replace
        case reload

        // services
        case accomodation
        case all
        case carRental
        case cocktail
        case coffee
        case entertainment
        case flightServices
        case gym
        case lounge
        case musicalInstruments
        case parking
        case pet
        case pharmacy
        case playground
        case powerPlug
        case relax
        case restaurant
        case meal
        case seat
        case shopping
        case spa
        case sports
        case termsAndConditions
        case wheelchair
        case wifi
        case airConditioning

        // social
        case facebook
        case feedback
        case google
        case shareiOS
        case thumbUp

        // time
        case calendar
        case calendarAnytime
        case calendarRange
        case calendarTripLength
        case clock
        case moon
        case notification
        case notificationOn
        case notificationAdd
        case sun
        case sunrise
        case timelapse

        // transportation
        case airplane
        case bus
        case car
        case city
        case compass
        case gps
        case gpsOff
        case map
        case selfTransfer
        case taxi
        case train
        case walk

        // travel
        case airplaneLanding
        case airplaneTakeoff
        case airplaneUp
        case airplaneUpOff
        case airplaneDown
        case airportSecurity
        case anywhere
        case baggageRecheck
        case baggageChecked
        case baggageCabin
        case baggageCabinNone
        case baggageNone
        case baggagePersonalItem
        case baggagePersonalItemNone
        case baggageSet

        case boardingGate
        case child
        case childFriendly
        case contactEmail
        case flightDirect
        case flightReturn
        case flightMulticity
        case flightNomad
        case insurance
        case insuranceConfirmed
        case insuranceOff
        case location
        case locationA
        case locationB
        case locationC
        case locationD
        case locationE
        case locationF
        case locationG
        case locationH
        case locationI
        case locationJ
        case locationAdd
        case logout
        case onlineCheckin
        case onlineCheckinOff
        case passenger
        case passengerOutline
        case passengerAdd
        case passengers
        case passport
        case priorityBoard
        case radiusSearch
        case routeNoStops
        case routeOneStop
        case routeTwoStops
        case sightseeing
        case suitcase
        case sort
        case terminal
        case ticket
        case ticketOutline
        case tips
        case trip
        case seatWindow
        case seatExtraLegroom
        case seatAisle
        case seatSitTogether

        case none

        case lock
        case lockOpen

        case arrowUp
        case arrowRight

        case billingDetails
        case customerSupport
        case security

        case attachment
        case send

        public var value: String {
            switch self {
                case .trip:                         return "\u{E130}"
                case .city:                         return "c"
                case .airplaneTakeoff:              return "*"
                case .airplaneLanding:              return "%"
                case .airplaneUp:                   return "\u{E160}"
                case .airplaneDown:                 return "\u{E101}"
                case .airplaneUpOff:                return "\u{E102}"
                case .calendarRange:                return "z"
                case .calendarAnytime:              return "A"
                case .calendarTripLength:           return "\u{E109}"
                case .flightDirect:                 return "C"
                case .routeNoStops:                 return "o"
                case .routeTwoStops:                return "p"
                case .routeOneStop:                 return "q"
                case .flightReturn:                 return "s"
                case .replace:                      return "I"
                case .reload:                       return "2"
                case .chevronRight:                 return "\u{E01F}"
                case .chevronDown:                  return "\u{E09D}"
                case .chevronUp:                    return "m"
                case .chevronLeft:                  return "!"
                case .priorityBoard:                return "\u{E08D}"
                case .locationA:                    return "j"
                case .locationB:                    return "k"
                case .locationC:                    return "^"
                case .locationD:                    return "_"
                case .locationE:                    return "`"
                case .locationF:                    return "{"
                case .locationG:                    return "|"
                case .locationH:                    return "}"
                case .locationI:                    return "~"
                case .locationJ:                    return "\\"
                case .location:                     return "$"
                case .locationAdd:                  return "?"
                case .logout:                       return "\u{E0A7}"
                case .gps:                          return "\u{E161}"
                case .map:                          return "\u{E001}"
                case .facebook:                     return "\u{E002}"
                case .google:                       return "\u{E003}"
                case .visibilityOff:                return "\u{E004}"
                case .visibility:                   return "\u{E005}"
                case .passport:                     return "Q"
                case .baggageChecked:               return "h"
                case .baggageRecheck:               return "\u{E105}"
                case .baggageCabin:                 return "\u{E106}"
                case .baggageCabinNone:             return "\u{E174}"
                case .passenger:                    return "w"
                case .passengerOutline:             return "\u{E137}"
                case .passengers:                   return "("
                case .passengerAdd:                 return ")"
                case .creditCard:                   return "u"
                case .contactEmail:                 return "v"
                case .childFriendly:                return "\u{E05D}"
                case .insurance:                    return "'"
                case .insuranceOff:                 return ":"
                case .taxi:                         return ";"
                case .bus:                          return "<"
                case .boardingGate:                 return "\u{E00A}"
                case .ticketOutline:                return "\u{E138}"
                case .editOff:                      return "\u{E00D}"
                case .onlineCheckin:                return "\u{E00F}"
                case .onlineCheckinOff:             return "\u{E00E}"
                case .walk:                         return "\u{E052}"
                case .timelapse:                    return "\u{E000}"
                case .sun:                          return "\u{E096}"
                case .sunrise:                      return "\u{E08E}"
                case .moon:                         return "\u{E090}"
                case .calendar:                     return "f"
                case .radiusSearch:                 return "d"
                case .alertCircle:                  return "U"
                case .notification:                 return "\u{E018}"
                case .notificationOn:               return "\u{E025}"
                case .notificationAdd:              return "\u{E195}"
                case .closeCircle:                  return "t"
                case .clock:                        return "e"
                case .edit:                         return "E"
                case .settings:                     return "8"
                case .informationCircle:            return "R"
                case .plus:                         return "\u{E122}"
                case .plusCircle:                   return "\u{E027}"
                case .feedback:                     return "E"
                case .bug:                          return "N"
                case .remove:                       return "W"
                case .filters:                      return "&"
                case .starFull:                     return "#"
                case .chat:                         return "9"
                case .close:                        return "X"
                case .flightMulticity:              return "]"
                case .flightNomad:                  return "\u{E150}"
                case .download:                     return "\u{E014}"
                case .sightseeing:                  return "\u{E015}"
                case .accomodation:                 return "\u{E085}"
                case .gpsOff:                       return "\u{E01C}"
                case .baggageNone:                  return "\u{E021}"
                case .baggagePersonalItem:          return "\u{E156}"
                case .baggagePersonalItemNone:      return "\u{E175}"
                case .baggageSet:                   return "\u{E107}"
                case .visa:                         return "\u{E132}"
                case .showMore:                     return "\u{E125}"
                case .showLess:                     return "\u{E124}"
                case .minus:                        return "\u{E118}"
                case .accountCircle:                return "\u{E134}"
                case .newWindow:                    return "\u{E05E}"
                case .link:                         return "\u{E057}"
                case .ticket:                       return "."
                case .terminal:                     return "\u{E196}"
                case .phone:                        return "\u{E058}"
                case .email:                        return "G"
                case .restaurant:                   return "1"
                case .meal:                         return "\u{E116}"
                case .relax:                        return "\u{E046}"
                case .playground:                   return "\u{E053}"
                case .sports:                       return "\u{E042}"
                case .all:                          return "\u{E061}"
                case .gallery:                      return "\u{E064}"
                case .document:                     return "\u{E110}"
                case .dealsV2:                      return "\u{E206}"
                case .shareiOS:                     return "\u{E163}"
                case .questionCircle:               return "F"
                case .check:                        return "V"
                case .checkCircle:                  return "S"
                case .thumbUp:                      return "\u{E01B}"
                case .train:                        return "\u{E028}"
                case .selfTransfer:                 return "\u{E020}"
                case .compass:                      return "\u{E07E}"
                case .list:                         return "\u{E115}"
                case .menuMeatballs:                return "\u{E07D}"
                case .wheelchair:                   return "\u{E088}"
                case .gym:                          return "\u{E089}"
                case .musicalInstruments:           return "\u{E086}"
                case .messages:                     return "\u{E135}"
                case .messagesOutline:              return "\u{E136}"
                case .insuranceConfirmed:           return "r"
                case .termsAndConditions:           return "\u{E0A4}"
                case .search:                       return "\u{E07C}"
                case .seat:                         return "\u{E02A}"
                case .atm:                          return "\u{E02C}"
                case .suitcase:                     return "\u{E02D}"
                case .sort:                         return "\u{E171}"
                case .coffee:                       return "\u{E02F}"
                case .carRental:                    return "\u{E030}"
                case .exchange:                     return "\u{E032}"
                case .parking:                      return "\u{E03E}"
                case .pharmacy:                     return "\u{E034}"
                case .airportSecurity:              return "\u{E035}"
                case .shopping:                     return "\u{E036}"
                case .smoking:                      return "\u{E037}"
                case .airplane:                     return "a"
                case .powerPlug:                    return "\u{E06F}"
                case .entertainment:                return "\u{E06E}"
                case .grid:                         return "\u{E06D}"
                case .alert:                        return "\u{E07F}"
                case .cocktail:                     return "\u{E038}"
                case .car:                          return "\u{E03A}"
                case .pet:                          return "\u{E043}"
                case .tips:                         return "\u{E047}"
                case .money:                        return "@"
                case .flightServices:               return "\u{E049}"
                case .spa:                          return "\u{E04A}"
                case .lounge:                       return "\u{E04E}"
                case .child:                        return "\u{E050}"
                case .wifi:                         return "\u{E062}"
                case .promoCode:                    return "\u{E081}"
                case .circle:                       return "\u{E013}"
                case .circleSmall:                  return "\u{E148}"
                case .emptyCircle:                  return "\u{E179}"
                case .filledCircle:                 return "\u{E180}"
                case .anywhere:                     return "g"
                case .kiwicom:                      return "\u{E143}"
                case .kiwicomGuarantee:             return "\u{E145}"
                case .lock:                         return "\u{E169}"
                case .lockOpen:                     return "\u{E170}"
                case .refund:                       return "\u{E165}"
                case .airConditioning:              return "\u{E184}"
                case .arrowUp:                      return "\u{E09F}"
                case .arrowRight:                   return "\u{006F}"
                case .infant:                       return "\u{E186}"
                case .seatWindow:                   return "\u{E188}"
                case .seatExtraLegroom:             return "\u{E190}"
                case .seatAisle:                    return "\u{E189}"
                case .seatSitTogether:              return "\u{E192}"
                case .billingDetails:               return "\u{E108}"
                case .customerSupport:              return "\u{E194}"
                case .security:                     return "\u{E146}"
                case .attachment:                   return "\u{E104}"
                case .send:                         return "\u{004D}"

                case .none:                         return ""
            }
        }

        public static func < (lhs: Icon.Symbol, rhs: Icon.Symbol) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
