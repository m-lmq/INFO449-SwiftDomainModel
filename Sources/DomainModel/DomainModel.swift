import Foundation

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
    var amount:Int
    var currency:String
    
    public func convert(_ convertTo: String) -> Money {
        var toUSD = amount
        var newAmount: Int
        
        if(currency == "GBP") {
            toUSD = amount * 2
        } else if (currency == "EUR"){
            toUSD = amount * 2 / 3
        } else if (currency == "CAN"){
            toUSD = amount * 4 / 5
        }
        
        if(convertTo == "GBP") {
            newAmount = toUSD / 2
        }else if(convertTo == "EUR"){
            newAmount = toUSD * 3 / 2
        }else if(convertTo == "CAN") {
            newAmount = toUSD * 5 / 4
        }else {
            newAmount = toUSD
        }
        
        return Money(amount: newAmount, currency: convertTo)
        
    }
    
    func add(_ to: Money) -> Money{
        
        var result = self.convert(to.currency)
        return Money(amount:result.amount + to.amount, currency: to.currency)
    }
    
    func subtract(_ to: Money) -> Money{
        var result = self.convert(to.currency)
        return Money(amount: result.amount - to.amount, currency: to.currency)
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
    
    public var title: String
    public var type: JobType
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Salary(let amount):
            return Int(amount)
        case .Hourly(let wage):
            return Int(wage * Double(hours))
        }
    }
    
    public func raise(byAmount amount: Double) {
        switch type {
        case .Salary(let salary):
            self.type = .Salary(salary + UInt(amount))
        case .Hourly(let wage):
            self.type = .Hourly(wage + amount)
        }
    }
    
    public func raise(byPercent percent: Double) {
        switch type {
        case .Salary(let salary):
            self.type = .Salary(salary + UInt(Double(salary) * percent))
        case .Hourly(let wage):
            self.type = .Hourly(wage + (wage * percent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var _job: Job?
    var _spouse: Person?
    
    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String{
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job?.title)) spouse:\(String(describing: _spouse?.firstName))]"
    }
    
    var job: Job?{
        get{return _job}
        set{
            if age >= 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }
    
    var spouse: Person?{
        get{return _spouse}
        set{
            if age >= 18 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    init(spouse1: Person, spouse2: Person) {
        self.members = [spouse1, spouse2]
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    
    func haveChild(_ child: Person) -> Bool {
        for member in members {
            if member.age >= 21{
                members.append(child)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalincome = 0
        for member in members {
            totalincome += member.job?.calculateIncome(2000) ?? 0
        }
        return totalincome
    }
}
