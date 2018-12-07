//
//  Necrolog.swift
//  Necrolog
//
//  Created by Jakub Hladík on 08.01.16.
//  Copyright © 2016 Jakub Hladík. All rights reserved.
//

import UIKit


public enum LogLevel: Int {
    case verbose = 0
    case debug
    case info
    case warning
    case error
}

public final class Necrolog: NSObject {
    
    static let instance = Necrolog()
    
    fileprivate override init() {
        
    }
    
    private(set) var time0 = CACurrentMediaTime()
    private(set) var logLevel: LogLevel = .debug
    private(set) var splitArgs = false
    private(set) var logCodeLocation = true
    
    // color support
    private(set) var colorize = false
    let timeColor = UIColor.gray
    let verboseColor = UIColor.lightGray
    let debugColor = UIColor.lightGray
    let infoColor = UIColor.lightText
    let warningColor = UIColor.orange
    let errorColor = UIColor.red
    let codeLocationColor = UIColor.darkGray
    
    // emoji support
    private(set) var includeEmoji = false
    
    static let Escape: String = "\u{001b}["
    let ResetGg: String = Escape + "fg;"    // Clear any foreground color
    let ResetBg: String = Escape + "bg;"    // Clear any background color
    let Reset: String = Escape + ";"        // Clear any foreground or background color
    
    class func setup(withInitialTimeInterval time0: CFTimeInterval = CACurrentMediaTime(),
                     logLevel level: LogLevel = .debug,
                     splitMultipleArgs splitArgs: Bool = false,
                     logCodeLocation: Bool = true,
                     withColors colorize: Bool = false,
                     withEmoji: Bool = true)
    {
        self.instance.time0 = time0
        self.instance.logLevel = level
        self.instance.splitArgs = splitArgs
        self.instance.logCodeLocation = logCodeLocation
        self.instance.colorize = colorize
        self.instance.includeEmoji = withEmoji
    }
    
    public class func entry(
        _ longPath: String = #file,
        function: String = #function,
        line: Int = #line)
    {
        self.instance.logMessages([ "Entry" ], withLevel: .debug, longPath: longPath, function: function, line: line)
    }
    
    public class func exit(
        _ longPath: String = #file,
        function: String = #function,
        line: Int = #line)
    {
        self.instance.logMessages([ "Exit" ], withLevel: .debug, longPath: longPath, function: function, line: line)
    }
    
    public class func verbose(
        _ messages: Any?...,
        longPath: String = #file,
        function: String = #function,
        line: Int = #line) -> Void
    {
        self.instance.logMessages(messages, withLevel: .verbose, longPath: longPath, function: function, line: line)
    }
    
    public class func debug(
        _ messages: Any?...,
        longPath: String = #file,
        function: String = #function,
        line: Int = #line) -> Void
    {
        self.instance.logMessages(messages, withLevel: .debug, longPath: longPath, function: function, line: line)
    }
    
    public class func info(
        _ messages: Any?...,
        longPath: String = #file,
        function: String = #function,
        line: Int = #line) -> Void
    {
        self.instance.logMessages(messages, withLevel: .info, forcePrefix: " Info:", longPath: longPath, function: function, line: line)
    }
    
    public class func warning(
        _ messages: Any?...,
        longPath: String = #file,
        function: String = #function,
        line: Int = #line) -> Void
    {
        self.instance.logMessages(messages, withLevel: .warning, forcePrefix: " Warning:", longPath: longPath, function: function, line: line)
    }
    
    public class func error(
        _ messages: Any?...,
        longPath: String = #file,
        function: String = #function,
        line: Int = #line) -> Void
    {
        self.instance.logMessages(messages, withLevel: .error, forcePrefix: " Error:", longPath: longPath, function: function, line: line)
    }
    
    fileprivate func logMessages(
        _ messages: Array<Any?>,
        withLevel level: LogLevel = .debug,
        forcePrefix prefix: String = "",
        splitArray split: Bool = false,
        longPath: String? = nil,
        function: String? = nil,
        line: Int? = nil)
    {
        guard messages.count > 0 else {
            self.logMessages([ "Keep trying lol" ],
                             textColor:self.color(forLogLevel: level))
            return
        }
        
        if level.rawValue >= self.logLevel.rawValue {
            self.logMessages(messages,
                             forcePrefix: includeEmoji == true ? " \(emoji(forLogLevel: level))\(prefix)" : prefix,
                             textColor: self.colorize ? self.color(forLogLevel: level) : nil,
                             splitArgs: self.splitArgs,
                             filePath: longPath,
                             functionName: function,
                             lineNumber: line)
        }
    }
    
    fileprivate func logMessages(
        _ messages: Array<Any?>,
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
        let timeString = textColor != nil ? self.coloredString(elapsedString, withColor: self.timeColor) : elapsedString
        
        // file function:line
        var codeLocation: String?
        if logCodeLocation == true, let path = filePath, let function = functionName, let line = lineNumber {
            let filename = (path as NSString).lastPathComponent
            let filenameFunctionLine = "- \(filename) \(function):\(line)"
            if self.colorize {
                codeLocation = self.coloredString(filenameFunctionLine, withColor: self.codeLocationColor)
            }
            else {
                codeLocation = filenameFunctionLine
            }
        }
        
        // prefix
        let finalPrefix = self.colorize ? self.coloredString(messagePrefix, withColor: textColor!) : messagePrefix
        
        let initialString = "\(timeString)\(finalPrefix)"
        let separatorString = (messages.count > 1 && splitArgs) ? "\n        " : " "
        
        let messageString = messages.reduce("") { (partial, element) -> String in
            switch element {
            case .some(let elem):
                if partial.count == 0 {
                    let elementString: String = "\(elem)"
                    return textColor != nil ? self.coloredString(elementString, withColor: textColor!) : elementString
                }
                else {
                    let elementString: String = "\(partial)\(separatorString)\(elem)"
                    return textColor != nil ? self.coloredString(elementString, withColor: textColor!) : elementString
                }
            case .none:
                let elementString: String = "\(partial)\(separatorString)nil)"
                return textColor != nil ? self.coloredString(elementString, withColor: textColor!) : elementString
            }
        }
        
        var finalString = initialString
        finalString.append(" ")
        finalString.append(messageString)
        
        if let line = codeLocation {
            finalString.append(" \(line)")
        }
        
        print(finalString)
        #endif
    }
    
    fileprivate func color(forLogLevel level: LogLevel) -> UIColor {
        switch (level) {
        case .verbose:
            return self.verboseColor
        case .debug:
            return self.debugColor
        case .info:
            return self.infoColor
        case .warning:
            return self.warningColor
        case .error:
            return self.errorColor
        }
    }
    
    fileprivate func emoji(forLogLevel level: LogLevel) -> String {
        switch (level) {
        case .verbose:
            return "🗣"
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "🛑"
        }
    }
    
    fileprivate func colorString(fromColor color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return "\(Necrolog.Escape)fg\(Int(r*255)),\(Int(g*255)),\(Int(b*255));" // \(Escape)fg128,128,128;
    }
    
    fileprivate func coloredString(_ string: String,
                                   withColor color: UIColor) -> String
    {
        return "\(self.colorString(fromColor: color))\(string)\(self.Reset)"
    }
}
