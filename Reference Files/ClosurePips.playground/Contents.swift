//: Playground - noun: a place where people can play

import UIKit


var functionVar: (String, Double) -> String

functionVar = { (v1, v2) in
    var output = String(v1) + " -> " + String(v2)
    return output
}
functionVar("Test", 23.123)


functionVar = {
    var output = String($0) + " -> " + String($1)
    return output
}
functionVar("Test", 23.123)


functionVar = {
    var output = String($1)
    return output
}
functionVar("Test", 23.123)


var arr = [Double?]()
arr.append(nil)
arr.append(Double(100.0))



var triplet1:(String, Double, Dictionary<String, String>)
var triplet2:(String, Double, [String:String])


triplet1 = ("lol", 0.125, ["a": "_a", "b": "_b"])


var dic2 = [String:String]()
dic2["a"] = "_a"
dic2["b"] = "_b"
triplet2 = ("lol", 0.325, dic2)




















