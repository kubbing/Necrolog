//
//  Necrolog.swift
//  Necrolog
//
//  Created by Jakub Hladík on 08.01.16.
//  Copyright © 2016 Jakub Hladík. All rights reserved.
//

import Foundation

//
//  Log.swift
//  NecroLog
//
//  Created by Jakub Hladík on 08.01.16.
//  Copyright © 2016 Jakub Hladík. All rights reserved.
//

import UIKit

@objc enum LogLevel: Int {
    case Verbose = 0
    case Debug
    case Info
    case Warning
    case Error
}

class Necrolog {
    
    static let instance = Necrolog()
    
    private init() {
        
    }
    
    var time0 = CACurrentMediaTime()
    var logLevel: LogLevel = .Debug
    var splitArgs = false
    var logCodeLocation = true
    
    // color support
    var colorize = false
    var timeColor = UIColor.grayColor()
    var verboseColor = UIColor.lightGrayColor()
    var debugColor = UIColor.lightGrayColor()
    var infoColor = UIColor.lightTextColor()
    var warningColor = UIColor.orangeColor()
    var errorColor = UIColor.redColor()
    var codeLocationColor = UIColor.darkGrayColor()
    
    static let Escape: String = "\u{001b}["
    let ResetGg: String = Escape + "fg;"    // Clear any foreground color
    let ResetBg: String = Escape + "bg;"    // Clear any background color
    let Reset: String = Escape + ";"        // Clear any foreground or background color
    
    class func setup(
        withInitialTimeInterval time0: CFTimeInterval?,
        logLevel level: LogLevel = .Debug,
        splitMultipleArgs splitArgs: Bool = false,
        logCodeLocation: Bool = true,
        withColors colorize: Bool = false)
    {
        if let interval = time0 {
            self.instance.time0 = interval
        }
        
        self.instance.logLevel = level
        self.instance.splitArgs = splitArgs
        self.instance.logCodeLocation = logCodeLocation
        self.instance.colorize = colorize
    }
    
    class func entry(
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__)
    {
        self.instance.trace(messages: [ "Entry" ], withLevel: .Debug, longPath: longPath, function: function, line: line)
    }
    
    class func exit(
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__)
    {
        self.instance.trace(messages: [ "Exit" ], withLevel: .Debug, longPath: longPath, function: function, line: line)
    }
    
    class func raw(messages: Any...) {
        self.instance.trace(messages: messages, withLevel: .Error)
    }
    
    class func verbose(
        messages: Any...,
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) -> Void
    {
        self.instance.trace(messages: messages, withLevel: .Verbose, longPath: longPath, function: function, line: line)
    }
    
    class func debug(
        messages: Any...,
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) -> Void
    {
        self.instance.trace(messages: messages, withLevel: .Debug, longPath: longPath, function: function, line: line)
    }
    
    class func info(
        messages: Any...,
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) -> Void
    {
        self.instance.trace(messages: messages, forcePrefix: " Info:", withLevel: .Info, longPath: longPath, function: function, line: line)
    }
    
    class func warning(
        messages: Any...,
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) -> Void
    {
        self.instance.trace(messages: messages, forcePrefix: " Warning:", withLevel: .Warning, longPath: longPath, function: function, line: line)
    }
    
    class func error(
        messages: Any...,
        longPath: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) -> Void
    {
        self.instance.trace(messages: messages, forcePrefix: " Error:", withLevel: .Error, longPath: longPath, function: function, line: line)
    }
    
    private func trace(
        messages messages: Array<Any>,
        withLevel level: LogLevel = .Debug,
        forcePrefix prefix: String = "",
        splitArray split: Bool = false,
        longPath: String? = nil,
        function: String? = nil,
        line: Int? = nil)
    {
        guard messages.count > 0 else {
            self.log(
                messages: [ "Keep trying lol" ],
                textColor:self.color(forLogLevel: level))
            
            return
        }
        
        if level.rawValue >= self.logLevel.rawValue {
            self.log(
                messages: messages,
                forcePrefix: prefix,
                textColor: self.colorize ? self.color(forLogLevel: level) : nil,
                splitArgs: self.splitArgs,
                filePath: longPath,
                functionName: function,
                lineNumber: line)
        }
    }
    
    private func log(
        messages messages: Array<Any>,
        forcePrefix messagePrefix: String = "",
        textColor: UIColor?,
        splitArgs: Bool = false,
        filePath: String? = nil,
        functionName: String? = nil,
        lineNumber: Int? = nil) -> Void
    {
        #if DEBUG
            // time
            let elapsedTime = CACurrentMediaTime() - self.time0;
            let elapsedString = String(format: "%7.2f", elapsedTime)
            let timeString = textColor != nil ? self.colored(string: elapsedString, withColor: self.timeColor) : elapsedString
            
            // file function:line
            var codeLocation: String?
            if logCodeLocation == true, let path = filePath, let function = functionName, let line = lineNumber {
                let filename = (path as NSString).lastPathComponent
                let filenameFunctionLine = "- \(filename) \(function):\(line)"
                if self.colorize {
                    codeLocation = self.colored(string: filenameFunctionLine, withColor: self.codeLocationColor)
                }
                else {
                    codeLocation = filenameFunctionLine
                }
            }
            
            // prefix
            let finalPrefix = self.colorize ? self.colored(string: messagePrefix, withColor: textColor!) : messagePrefix
            
            var outputString = "\(timeString)\(finalPrefix)"
            let separatorString = (messages.count > 1 && splitArgs) ? "\n        " : " "
            
            var iterator = messages.generate()
            if let first = iterator.next() {
                let firstString = " \(first)"
                outputString.appendContentsOf(textColor != nil ? self.colored(string: firstString, withColor: textColor!) : firstString)
            }
            
            while let element = iterator.next() {
                let elementString = "\(separatorString)\(element)"
                outputString.appendContentsOf(textColor != nil ? self.colored(string: elementString, withColor: textColor!) : elementString);
            }
            
            if let line = codeLocation {
                outputString.appendContentsOf(" \(line)")
            }
            
            print(outputString)
        #endif
    }
    
    private func color(forLogLevel level: LogLevel) -> UIColor {
        switch (level) {
        case .Verbose:
            return self.verboseColor
        case .Debug:
            return self.debugColor
        case .Info:
            return self.infoColor
        case .Warning:
            return self.warningColor
        case .Error:
            return self.errorColor
        }
    }
    
    private func colorString(fromColor color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return "\(Necrolog.Escape)fg\(Int(r*255)),\(Int(g*255)),\(Int(b*255));" // \(Escape)fg128,128,128;
    }
    
    private func colored(
        string string: String,
        withColor color: UIColor) -> String
    {
        return "\(self.colorString(fromColor: color))\(string)\(self.Reset)"
    }
}