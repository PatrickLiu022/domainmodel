struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    private func createConversion(_ currencyType : String) -> Double {
        var currencyAmount : Double
        switch currencyType {
            case "CAN":
                currencyAmount = 1.25
            case "EUR":
                currencyAmount = 1.5
            case "GBP":
                currencyAmount = 0.5
            case "USD":
                currencyAmount = 1.0
            default:
                currencyAmount = 0
        }
        return currencyAmount
    }
    
    public func convert(_ currencyName : String) -> Money {
        let selfConvert = createConversion(self.currency)
        let otherConvert = createConversion(currencyName)
        
        if (selfConvert != 0) {
            let selfToUsd = Double(self.amount) / selfConvert
            let UsdToConversion : Double = selfToUsd * otherConvert
            
            return Money(amount: Int(UsdToConversion), currency: currencyName)
        } else {
            return Money(amount: 0, currency: "ERROR")
        }
    }
    
    public func add(_ money : Money) -> Money {
        let convertedAmount = convert(money.currency)
        return Money(amount: convertedAmount.amount + money.amount, currency: money.currency)
    }
    
    public func subtract(_ money : Money) -> Money {
        let convertedAmount = convert(money.currency)
        return Money(amount: convertedAmount.amount - money.amount, currency: money.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title : String
    var type : JobType
    
    public func calculateIncome(_ money : Int) -> Int {
        switch type {
            case .Hourly(let hourlyPay):
                return money * 2000
            case .Salary(let salary):
                return salary
            default:
                return 0
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
