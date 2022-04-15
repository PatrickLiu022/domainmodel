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
    
    public func calculateIncome(_ hours : Int) -> Int {
        var income = 0
        switch type {
            case .Hourly(let hourlyPay):
                income = Int(hourlyPay * Double(hours))
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
                let amountRaised = hourlyPay * byPercent
                type = .Hourly(hourlyPay + amountRaised)
            case .Salary(let salary):
                let amountRaised = Double(salary) * byPercent
                type = .Salary(salary + UInt(amountRaised))
        }
    }
    
    public func convert() {
        if case let .Hourly(hourlyPay) = self.type {
            self.type = .Salary(UInt(hourlyPay * 2000))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    
    var firstName : String?
    var lastName : String?
    var age : Int
    private var _job : Job?
    private var _spouse : Person?
    
    init(firstName : String?, lastName : String?, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    init(firstName: String?, age: Int) {
        self.firstName = firstName
        self.age = age
    }
    
    init(lastName: String?, age: Int) {
        self.lastName = lastName
        self.age = age
    }
    
    var job : Job? {
        set {
            if (self.age >= 18) {
                self._job = newValue
            } else {
                self._job = nil
            }
        }
        get {
            return self._job
        }
    }
    
    var spouse : Person? {
        set {
            if (self.age >= 18) {
                self._spouse = newValue
            } else {
                self._spouse = nil
            }
        }
        get {
            return self._spouse
        }
    }
    
    public func toString() -> String {
        var unwrappedFName = ""
        var unwrappedLName = ""
        var nilJob : String?
        var unwrappedJob = ""
        
        if let fName = self.firstName {
            unwrappedFName = fName
        }
        
        if let lName = self.lastName {
            unwrappedLName = lName
        }
        
        if let job = self._job {
            if self._job?.title == nil {
                nilJob = nil
            } else {
                unwrappedJob = job.title
            }
        }
        
        return unwrappedJob == "" ? "[Person: firstName:\(unwrappedFName) lastName:\(unwrappedLName) age:\(self.age) job:\(nilJob as String?) spouse:\(self._spouse as Person?)]" : "[Person: firstName:\(unwrappedFName) lastName:\(unwrappedLName) age:\(self.age) job:\(unwrappedJob) spouse:\(self._spouse as Person?)]"
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
    
    init(spouse1 : Person, spouse2 : Person) {
        do {
            self.members = [spouse1, spouse2]
            let _ = try validateSpouse(spouse1) == nil && validateSpouse(spouse2) == nil
        } catch FamilyError.invalidMarriage {
            print("One spouse is already married")
        } catch {
            print("Unknown Error")
        }
    }
    
    private func validateSpouse(_ spouse : Person) throws -> Error? {
        if (spouse.spouse != nil) {
            throw FamilyError.invalidMarriage
        }
        return nil
    }
    
    public func haveChild(_ child : Person) -> Bool {
        
        do {
            let _ = try validateSpouseAge(members[0]) == nil && validateSpouseAge(members[1]) == nil
        } catch FamilyError.invalidAge {
            return false
        } catch {
            print("Unknown Error")
        }
        
        members.append(child)
        return true
    }
    
    private func validateSpouseAge(_ spouse : Person) throws -> Error? {
        if (spouse.age < 21) {
            throw FamilyError.invalidAge
        }
        return nil
    }
    
    public func householdIncome() -> Int {
        var sumIncome = 0
        for member in self.members {
            let memberIncome = member.job?.calculateIncome(2000)
            if let memberIncome = memberIncome {
                sumIncome += memberIncome
            }
        }
        
        return sumIncome
    }
}


