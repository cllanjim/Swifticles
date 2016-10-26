//: Playground - noun: a place where people can play

import UIKit



//func twist(arr:[String]) -> [String] {
var twist = {(arr:[String]) -> [String] in
    
    
    var result = [String]()
    
    //var clone = [String]()
    //for s in arr {
    //    clone.append(s)
    //}
    var clone = arr
    
    while clone.count > 0 {
        let index = Int(arc4random()) % clone.count
        var pop = clone.removeAtIndex(index)
        result.append(pop)
    }
    return result
}

var f1 = { (i1:Int, i2:Int) -> Int in
    return i1 + i2
}

var f2 = { (i1:Int, i2:Int) -> Int in
    return i1 * i2
}

var f3 = { (i1:Int, i2:Int) -> Int in
    return i1 * i1 + i2 * i2
}

var f4 = { (i1:Int, i2:Int) -> Int in
    return i1 - i2
}

var op = f1;
op(2, 3)
op = f2
op(2, 3)
op = f3
op(2, 3)

op = f4
op(2, 3)


func cross( p1:(x:Double, y:Double), p2:(x:Double, y:Double)) -> Double {
    return p1.y * p2.x - p1.x * p2.y
}

var p1 = (0.5, 0.25)
var p2 = (0.15, 0.88)

var cr = cross(p1, p2: p2)

var qq = [String]()
qq.append("hamburger")
qq.append("cheeseburger")
qq.append("hotdog")
qq.append("steak")
qq.append("chicken wings")
var aa = twist(qq)

var sorted = aa.sort()

var unsorted = aa

unsorted.removeAll()

var test = aa

label: for i in 1...2 { if i==1 { continue label } else { print(i) } }

let a = 123456

let b = a

//LOL
let c = b + a










