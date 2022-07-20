//
//  Validation.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/11/22.
//

import Foundation

class Validation {
    
    public func validateName(_ name: String) -> Bool {
        // Length be 30 characters max and 1 character minimum, you can always modify.
        let nameRegex = "^[a-zA-Z]{1,30}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    
    public func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = email.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    public func validatePassword(_ password: String) -> Bool {
        //Minimum 6 characters, maximum 30 characters, alphabetical, numerical, and symbols are permitted:
        let passRegEx = "^[A-Za-z0-9@~`!@#$%^&*()_=+\\\\';:\"\\/?>.<,-]{6,30}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    
}
