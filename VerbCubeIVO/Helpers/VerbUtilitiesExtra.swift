//
//  VerbUtilitiesExtra.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/7/22.
//

import Foundation
import JumpLinguaHelpers

public struct VerbUtilitiesExtra {
    

    
    //compare 2 identical strings except primary string is missing a letter in the sequence - return index and first unmatched character as string
        //for example, primaryString =  abcdfg
        //             secondaryString =  abcdefg  -> returns "abcd", "e", "fg"
    
    public mutating func findMissingLetterAndSplit(newString : String, oldString : String)-> (String, String, String) {
        let vu = VerbUtilities()
        var firstString = ""
        var missingChar = ""
        var secondString = ""
        
        for i in 0..<newString.count {
            let pChar = vu.getStringCharacterAt(input: newString, charIndex:i)
            let sChar = vu.getStringCharacterAt(input: oldString, charIndex:i)
            if pChar  != sChar {
                for j in 0..<i {
                    firstString += vu.getStringCharacterAt(input: newString, charIndex:j)
                }
                missingChar = sChar
                for j in i..<newString.count {
                    secondString += vu.getStringCharacterAt(input: newString, charIndex:j)
                }
                print("findMissingLetterAndSplit:  \(firstString), \(missingChar), \(secondString)")
                return (firstString, missingChar, secondString)
            }
            
        }
        //if it gets here, then the removed letter is the last letter in secondary string
        missingChar = vu.getStringCharacterAt(input: oldString, charIndex:oldString.count-1)
        firstString = newString
        print("findMissingLetterAndSplit:  \(firstString), \(missingChar), \(secondString)")
        return (firstString, missingChar, secondString)
    }
    
    public mutating func findExtraLetterAndSplit(newString : String, oldString : String)-> (String, String, String){
        let vu = VerbUtilities()
        
        var firstString = ""
        var extraChar = ""
        var secondString = ""
        
        print("findExtraLetterAndSplit:  \(newString), \(oldString)")
        for i in 0..<oldString.count {
            let newChar = vu.getStringCharacterAt(input: newString, charIndex:i)
            let oldChar = vu.getStringCharacterAt(input: oldString, charIndex:i)
            if newChar  != oldChar {
                for j in 0..<i {
                    firstString += vu.getStringCharacterAt(input: oldString, charIndex:j)
                }
                extraChar = newChar
                for j in i..<oldString.count {
                    secondString += vu.getStringCharacterAt(input: oldString, charIndex:j)
                }
                print("findExtraLetterAndSplit:  \(firstString), \(extraChar), \(secondString)")
                return (firstString, extraChar, secondString)
            }
           
        }
        //if it gets here, then the additional letter is the last letter in primary string
        extraChar = vu.getStringCharacterAt(input: newString, charIndex:newString.count-1)
        firstString = oldString
        print("findExtraLetterAndSplit:  \(firstString), \(extraChar), \(secondString)")
        return (firstString, extraChar, secondString)
    }
    
    public func getFirstNCharactersInString(inputString: String, copyCount: Int) -> String {
        var newString = ""
        
        //if we only want the first letter and there is only one letter, then return it
        if copyCount == 1 && inputString.count == 1 {
            return inputString
        }
        
        if ( copyCount >= inputString.count ){
            return ""
        }
        
        for i in 0..<copyCount{
            newString.append(inputString[inputString.index(inputString.startIndex, offsetBy: i)])
        }
        return newString
    }
    
       
}
