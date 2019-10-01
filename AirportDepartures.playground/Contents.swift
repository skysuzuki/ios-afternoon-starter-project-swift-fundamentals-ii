import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
enum FlightStatus : String
{
    case EnRoute
    case Scheduled
    case Landed
    case Delayed
    case Canceled
    case Boarding
}

struct Airport
{
    var destination: String
}

struct Flight
{
    let airport: Airport
    var airline: String
    var flightNumber: String
    var departureTime: Date?
    var terminalNumber: String?
    var flightStatus: FlightStatus
}

class DepartureBoard
{
    var departureFlights: [Flight] = []
    
    init()
    {
    }
    
    func alertPassengers()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        for flight in departureFlights
        {
            switch flight.flightStatus
            {
            case .Canceled:
                print("We're sorry your flight to \(flight.airport.destination) was canceled, here is a $500 voucher")
            case .Scheduled:
                var alert: String = "Your flight to \(flight.airport.destination) is scheduled to"
                if let departureTime = flight.departureTime
                {
                    alert += " depart at \(dateFormatter.string(from: departureTime))"
                }
                else
                {
                    alert += " depart at TBD"
                }
                if let terminalNumber = flight.terminalNumber
                {
                    alert += " from terminal \(terminalNumber)"
                }
                else
                {
                    alert += " from terminal TBD"
                }
                print(alert)
            case .Boarding:
                var alert: String = "Your flight is boarding, please head"
                if let terminalNumber = flight.terminalNumber
                {
                    alert += " to terminal: \(terminalNumber) immediately."
                }
                else
                {
                    alert += " to terminal TBD immediately."
                }
                print(alert + " The doors are closing soon.")
            default:
                continue
            }
        }
    }
}
//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time

let newyorkFlight = Flight(airport: Airport(destination: "Los Angeles"), airline: "Delta", flightNumber: "Dl2341", departureTime: Date(), terminalNumber: "4", flightStatus: .Landed)
let houstonFlight = Flight(airport: Airport(destination: "Houston"), airline: "American", flightNumber: "AA171", departureTime: nil, terminalNumber: "8", flightStatus: .Canceled)
let orlandoFlight = Flight(airport: Airport(destination: "Orlando"), airline: "JetBlue", flightNumber: "B61273", departureTime: Date(), terminalNumber: nil, flightStatus: .Scheduled)
let myDepartureBoard = DepartureBoard()
myDepartureBoard.departureFlights.append(newyorkFlight)
myDepartureBoard.departureFlights.append(houstonFlight)
myDepartureBoard.departureFlights.append(orlandoFlight)

// E Stretch: creating a specific time
var date = DateComponents()
date.hour = 8
date.minute = 30
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short

// check for space between AM && PM for .date(from:) function
if let _hour = date.hour
{
    let hour = _hour
    if let _minute = date.minute
    {
        let dateString: String = "\(hour):\(_minute) " + dateFormatter.amSymbol //OR PM
        let specificTime = dateFormatter.date(from: dateString)
        if let specificTime = specificTime{
            print(dateFormatter.string(from: specificTime))
        }
    }
}

//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function

func printDepartures(departureBoard: DepartureBoard)
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    // departure time and terminal number are optional
    for departure in departureBoard.departureFlights
    {
        var time = "", terminal = ""
        if let departureTime = departure.departureTime
        {
            //time = "\(departureTime)"
            time = dateFormatter.string(from: departureTime)
        }
        if let terminalNumber = departure.terminalNumber
        {
            terminal = "\(terminalNumber)"
        }
        
        print("Destination: \(departure.airport.destination) Airline: \(departure.airline): Flight: \(departure.flightNumber) Departure Time: \(time) Terminal: \(terminal) Status: \(departure.flightStatus.rawValue)")
    }
    
}

printDepartures(departureBoard: myDepartureBoard)
//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled

// Edited the function above to do this step!!

//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.

myDepartureBoard.alertPassengers()


//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.
func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double
{
    let ticketCost = Double(distance) * 0.10
    let bagCost = checkedBags * 25
    let totalCost: Double = (ticketCost * Double(travelers)) + Double(bagCost)
    return totalCost
}

let trip1 = calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3)
let trip2 = calculateAirfare(checkedBags: 4, distance: 2537, travelers: 2)
let trip3 = calculateAirfare(checkedBags: 3, distance: 1337, travelers: 6)

// Number Formatter stretch!
let usCurrencyFormatter = NumberFormatter()
usCurrencyFormatter.numberStyle = .currency
if let price = usCurrencyFormatter.string(from: NSNumber(floatLiteral: trip1))
{
    print(price)
}
if let price = usCurrencyFormatter.string(from: NSNumber(floatLiteral: trip2))
{
    print(price)
}
if let price = usCurrencyFormatter.string(from: NSNumber(floatLiteral: trip3))
{
    print(price)
}
