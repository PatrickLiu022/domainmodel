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
        var currencyType : Double
        switch currencyType {
            case "CAN": 1.25
            case "EUR": 1.5
            case "GBP": 0.5
            case "USD": 1.0
        }
        return currencyType
    }
    
    public func convert(_ currencyName : String) -> Int {
        let selfConvert = createConversion(self.currency)
        let otherConvert = createConversion(currencyName)
        
        var selfToUsd = self.amount / selfConvert
        var UsdToConversion = selfToUsd * otherConvert
        
        var result = round(UsdToConversion)
        
        return Int(result)!
    }
    
    public func add(_ money : Money) -> Int {
        let convertedAmount = convert(money.currency)
        self.currency = convertedAmount
        self.amount = convertedAmount + money.amount
        return convertedAmount + money.amount
    }
    
    public func subtract(_ money : Money) -> Int {
        let convertedAmount = convert(money.currency)
        self.currency = convertedAmount
        self.amount = convertedAmount - money.amount
        return convertedAmount - money.amount
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
