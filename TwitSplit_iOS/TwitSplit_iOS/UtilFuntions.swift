//
//  UtilFuntions.swift
//  TwitSplit_iOS
//
//  Created by dat on 9/15/17.
//  Copyright © 2017 dat. All rights reserved.
//

import Foundation


/// Class to save position of split part in message
class PosOfSplit {
    var index: Int
    var startIndex: String.Index
    var endIndex: String.Index
    
    /// init func
    ///
    /// - Parameters:
    ///   - index: index of split part in message
    ///   - startIndex: start character position of split part in message
    ///   - endIndex: end character position of split part in message
    init(index: Int, startIndex: String.Index, endIndex: String.Index) {
        self.index = index
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    
    /// get number of redundant character in split part ( number of character make split part more than 50 character  )
    ///
    /// - Parameters:
    ///   - message: input message
    ///   - numberOfParts: total number of split part of message
    ///   - maxCharacter: max valid number of character each split part ( default is 50)
    /// - Returns: return number of redundant character in split part, return nil if cant find valid split part
    func getNumberOfRedundantCharacter(_ message: String, numberOfParts: Int, maxCharacter: Int) -> Int? {
        let suffix = "\(index)/\(numberOfParts)"
        var subMesssage = ""
        if endIndex != message.endIndex {
            subMesssage = message[startIndex...endIndex]
        } else {
            subMesssage = message[startIndex..<endIndex]
        }
        let fullSubMessage = suffix + " " + subMesssage
        let newEndIndexFullSubMessage = fullSubMessage.index(fullSubMessage.startIndex, offsetBy: maxCharacter + 1, limitedBy: fullSubMessage.endIndex) ?? fullSubMessage.endIndex
        if newEndIndexFullSubMessage == fullSubMessage.endIndex && endIndex == message.endIndex {
            return 0
        }
        let newFullSubMessage = fullSubMessage[fullSubMessage.startIndex..<newEndIndexFullSubMessage]
        
        if let indexLastWord: Range<String.Index> = newFullSubMessage.range(of: " ", options: .backwards, range: nil, locale: nil) {
            // if have any space in subMessage
            let tmpMsg = newFullSubMessage[newFullSubMessage.startIndex..<indexLastWord.lowerBound]
            if tmpMsg.characters.count == suffix.characters.count { return nil }
            let numberOfRedundantCharacter = fullSubMessage.characters.count - 1 - tmpMsg.characters.count
            self.endIndex = message.index(endIndex, offsetBy: -numberOfRedundantCharacter)
            return numberOfRedundantCharacter - 1
        } else {
            // no space in string
            return nil // return nil if non-whitespace characters longer than maxCharacter characters
        }
    }
    
    
    /// get split message with range is startIndex..<endIndex in input message
    ///
    /// - Parameters:
    ///   - message: input message
    ///   - numberOfParts: total number of split part of message
    /// - Returns: split message
    func getSubMessage(_ message: String, numberOfParts: Int) -> String {
        let suffix = "\(index)/\(numberOfParts)"
        let subMesssage = message[startIndex..<endIndex]
        return suffix + " " + subMesssage
    }
}

class UtilFunctions{
    
    /// Split message into parts (each part have length <= maxCharacter)
    ///
    /// - Parameters:
    ///   - message: input message
    ///   - maxCharacter: max character for each splitting part , default is 50
    /// - Returns: array String of splitting result, return nil if invalid input
    public static func splitMessage(_ message:String?, maxCharacter: Int = 50) -> [String]? {
        guard let message = message else { return nil }
        guard message.characters.count > maxCharacter else {
            return [message]
        }
        var count = 0
        var startIndex = message.startIndex
        var endIndex = message.startIndex
        var posList = [PosOfSplit]()
        // initialize array of split position of split parts
        while endIndex != message.endIndex {
            startIndex = endIndex
            let expectedSuffix = "\(count)/\(count) "
            let expectedSubMessageLength = maxCharacter + 1 - expectedSuffix.characters.count
            endIndex = message.index(startIndex, offsetBy: expectedSubMessageLength, limitedBy: message.endIndex) ?? message.endIndex
            count += 1
            posList.append(PosOfSplit(index: count, startIndex: startIndex, endIndex: endIndex))
        }
        
        var lastSuccessPosPosition = -1
        // recorrect split part position by maxCharacter rule
        while lastSuccessPosPosition < posList.count - 1 {
            let checkPosition = lastSuccessPosPosition+1
            var pos = posList[checkPosition]
            if let numberOfRedundantCharacter = pos.getNumberOfRedundantCharacter(message, numberOfParts: count, maxCharacter: maxCharacter) {
                if numberOfRedundantCharacter > 0 {
                    for j in (checkPosition+1)..<posList.count {
                        pos = posList[j]
                        pos.startIndex = message.index(pos.startIndex, offsetBy: -numberOfRedundantCharacter, limitedBy: message.endIndex) ?? message.endIndex
                        pos.endIndex = message.index(pos.endIndex, offsetBy: -numberOfRedundantCharacter, limitedBy: message.endIndex) ?? message.endIndex
                        
                        if j == posList.count - 1 {
                            if pos.endIndex != message.endIndex {
                                // add new pos
                                count += 1
                                let expectedSuffix = "\(count)/\(count)"
                                let newStartIndex = pos.endIndex
                                let newEndIndex = message.index(startIndex, offsetBy: maxCharacter + 1 - expectedSuffix.characters.count, limitedBy: message.endIndex) ?? message.endIndex
                                posList.append(PosOfSplit(index: count, startIndex: newStartIndex, endIndex: newEndIndex))
                                lastSuccessPosPosition = -1
                                break
                            }
                        }
                    }
                }
                lastSuccessPosPosition += 1
            } else {
                // cant correct split part position
                return nil
            }
            
        }
        
        // get array of split part of message base on array of split part position
        var result = [String]()
        for pos in posList {
            let subString = pos.getSubMessage(message, numberOfParts: count)
            result.append(subString)
        }
        return result
    }
    
}
