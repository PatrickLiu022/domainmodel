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
    
    init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome() -> Int {
        var income = 0
        switch type {
            case .Hourly(let hourlyPay):
                income = Int(hourlyPay) * 2000
            case .Salary(let salary):
                income = Int(salary)
        }
        return income
    }
    
    public func raise(byAmount : Double)  {
        switch type {
            case .Hourly(let hourlyPay):
                type = .Hourly(hourlyPay + byAmount)
            case .Salary(let salary):
                type = .Salary(salary + UInt(byAmount))
        }
    }
    
    public func raise(byPercent : Double) {
        switch type {
            case .Hourly(let hourlyPay):
                type = .Hourly(hourlyPay + (hourlyPay * byPercent))
            case .Salary(let salary):
                type = .Salary(salary + (salary * UInt(byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    var spouse : Person?
    
    init(firstName : String, lastName : String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job as Job?) spouse:\(self.spouse as Person?)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    private enum FamilyError : Error {
        case invalidMarriage
        case invalidAge
    }
    
    var members : [Person]
    
    init(spouse1 : Person, spouse2 : Person) throws {
        do {
            var validSpouse1 = validateSpouse(spouse1)
            var validSpouse2 = validateSpouse(spouse2)
            
            if (validSpouse1 && validSpouse) {
                self.members = [spouse1, spouse2]
            } else {
                throw FamilyError.invalidMarriage
            }
            
        } catch FamilyError.invalidMarriage {
            print("One spouse is already married")
        }
    }
    
    private func validateSpouse(_ spouse : Person) throws -> Bool {
        return spouse.spouse == nil
    }
    
    public func haveChild(_ child : Person) -> Bool {
        var validSpouse1Age = validateSpouseAge(members[0])
        var validSpouse2Age = validateSpouseAge(members[1])
        
        do {
            if (validSpouse1Age || validSpouse2Age) {
                let newChild = Person(firstName: child.firstName, lastName: child.lastName, age: child.age)
                members.append(newChild)
                return true
            } else {
                throw FamilyError.invalidAge
            }
        } catch FamilyError.invalidAge {
            return false
        }
    }
    
    private func validateSpouseAge(_ spouse : Person) -> Bool {
        return spouse.age >= 21
    }
    
    public func householdIncome(_ family : [Person]) -> Int {
        var sumIncome = 0
        for member in family {
            sumIncome += member.job?.calculateIncome()
        }
        return sumIncome
    }
}


