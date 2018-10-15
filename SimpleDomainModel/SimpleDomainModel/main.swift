//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//

public struct Money {
  public var amount : Int
  public var currency : String
    
  public func convert(_ to: String)  -> Money {
//    if !(try! currencyCheck(to)) {
//        throw WrongCurrency.UnknownCurrency
//    }
    
//    if !(currency == "USD") || !(currency == "GBP") ||
//        !(currency == "EUR") || !(currency == "CAN") {
//        throw WrongCurrency.UnknownCurrency
//    }
    
    
    if self.currency == to {
        return Money(amount: self.amount, currency: self.currency)
    }
    
    let val = self.toVal(self.amount, self.currency, to)
    return Money(amount: val, currency: to);
    
  }
  
  public func add(_ from: Money) -> Money {
//    if !(try! currencyCheck(to.currency)) {
//        throw WrongCurrency.UnknownCurrency
//    }

//    if !(currency == "USD") || !(currency == "GBP") ||
//        !(currency == "EUR") || !(currency == "CAN") {
//        throw WrongCurrency.UnknownCurrency
//    }
    
    if from.currency == self.currency {
        return Money(amount: from.amount + self.amount, currency: self.currency)
    } else {
        let converted = self.toVal(self.amount, self.currency, from.currency)
        return Money(amount: converted + from.amount, currency: from.currency)
    }
    
  }


  public func subtract(_ from: Money) -> Money {
//    if !(try! currencyCheck(from.currency)) {
//        throw WrongCurrency.UnknownCurrency
//    }
    
//    if !(currency == "USD") || !(currency == "GBP") ||
//        !(currency == "EUR") || !(currency == "CAN") {
//        throw WrongCurrency.UnknownCurrency
//    }
    
    if from.currency == self.currency {
        return Money(amount: from.amount - self.amount, currency: self.currency)
    } else {
        let converted = self.toVal(self.amount, self.currency, from.currency)
        return Money(amount: converted - from.amount, currency: from.currency)
    }
    
  }
    
    private func toVal(_ amount: Int,
                       _ currCurrency: String,
                       _ targetCurrency: String) -> Int {
        var val = amount;
        if currCurrency == "GBP" {
            val = amount * 2
        } else if currCurrency == "EUR" {
            val = ( amount * 2 ) / 3
        } else if currCurrency == "CAN"{ // currCurrency == "CAN"
            val = ( amount * 4 ) / 5 
        }
        
        if targetCurrency == "GBP" {
            return val / 2
        } else if targetCurrency == "EUR" {
            return val * 3 / 2
        } else if targetCurrency == "CAN" {
            return val * 5 / 4
        } else { //Already USD
            return val;
        }
        
    }
    
//    private func currencyCheck(_ currency: String) throws {
//        if !(currency == "USD") || !(currency == "GBP") ||
//            !(currency == "EUR") || !(currency == "CAN") {
//            throw WrongCurrency.UnknownCurrency
//        }
//    }
//
//    enum WrongCurrency: Error {
//        case UnknownCurrency
//    }

}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourly):
        return Int(Double(hours) * hourly)
    case .Salary(let salary):
        return salary;
    
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourly):
        self.type = .Hourly(hourly + amt)
    case .Salary(let salary):
        self.type = .Salary(salary + Int(amt))
        
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if self.age >= 16 {
            self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

    //public init(firstName: String, lastName: String, age: Int, )

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job)) spouse:\(String(describing: self.spouse))]"
    //[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    self.members.append(spouse1)
    self.members.append(spouse2)
  }

  open func haveChild(_ child: Person) -> Bool {
    var over21 = false
    for person in self.members {
        if person.age >= 21 {
            over21 = true
        }
    }
    if over21 {
        self.members.append(child)
    }
    return over21;
  }

  open func householdIncome() -> Int {
    var income = 0;
    for person in self.members {
        if person.job != nil {
            income += (person.job?.calculateIncome(2000))!
        }
        
    }
    return income
  }
}





