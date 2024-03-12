//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var largestObjc: Double = 0
        var largestSwift: Double = 0
        
        
        for word in words {
            let fraction = 0.000000000000001
            let query = "\(word) &*"
            let clock = ContinuousClock()
            
            var objcBrands = [String]()
            var swiftBrands = [String]()
            
            let time = clock.measure {
                objcBrands = handleSearchQuery(query, swift: false)
            }
            
            let milliseconds = Double(time.components.attoseconds) * fraction
            largestObjc = max(largestObjc, milliseconds)
//            print("Objc \(milliseconds) milliseconds")
            
            let timeSwift = clock.measure {
                swiftBrands = handleSearchQuery(query, swift: true)
            }
            
            let millisecondsSwift = Double(timeSwift.components.attoseconds) * fraction
            largestSwift = max(largestSwift, millisecondsSwift)

//            print("Swift \(millisecondsSwift) milliseconds")
            print(swiftBrands == objcBrands)
        }
        
        print(largestObjc, largestSwift)
        //5.8491670000000004 36.328834
        //8.649792000000001 36.371334000000004
        //6.223292000000001 36.372625
    }
    
    private func handleSearchQuery(_ searchQuery: String, swift: Bool) -> [String] {
        return brands.sorted { brand1, brand2 in
            let brand1Lowercased = brand1.lowercased()
            let brand2Lowercased = brand2.lowercased()

            guard !searchQuery.isEmpty else {
                return brand1Lowercased < brand2Lowercased
            }
            
            let brand1Distance: Float
            let brand2Distance: Float
            
            if swift {
                brand1Distance = brand1Lowercased.asciiLevenshteinDistanceSwift(with: searchQuery)
                brand2Distance = brand2Lowercased.asciiLevenshteinDistanceSwift(with: searchQuery)
            } else {
                brand1Distance = brand1Lowercased.asciiLevenshteinDistance(with: searchQuery)
                brand2Distance = brand2Lowercased.asciiLevenshteinDistance(with: searchQuery)
            }

            if brand1Distance < brand2Distance {
                return true
            } else if brand1Distance > brand2Distance {
                return false
            } else {
                return brand1Lowercased < brand2Lowercased
            }
        }
    }
}

extension String {
    
    func asciiLevenshteinDistanceSwift(with stringB: String) -> Float {
        guard
            let dataA = self.data(using: .utf8, allowLossyConversion: true),
            let dataB = stringB.data(using: .utf8, allowLossyConversion: true)
        else {
            return Float.greatestFiniteMagnitude
        }
        
        
        let cstringA = [UInt8](dataA)
        let cstringB = [UInt8](dataB)
        
        let n = dataA.count + 1
        let m = dataB.count + 1
        
        var d = [Int](repeating: 0, count: m * n)
        
        for k in 0..<n {
            d[k] = k
        }
        
         return 5 // still slower
        
        for k in 0..<m {
            d[k * n] = k
        }
        
        // return 5 // still slower
        
        for i in 1..<n {
            for j in 1..<m {
                let cost = cstringA[i - 1] == cstringB[j - 1] ? 0 : 1
                d[j * n + i] = smallestOfSwift(
                    d[(j - 1) * n + i] + 1,
                    d[j * n + i - 1] + 1,
                    d[(j - 1) * n + i - 1] + cost
                )
            }
        }
        
        return Float(d[n * m - 1])
    }
    
    private func smallestOfSwift(_ a: Int, _ b: Int, _ c: Int) -> Int {
        return min(a, min(b, c))
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

//arms

let brands = [
    "Petarmor 7 Way De Wormer",
    "Petarmor - 1 Ct",
    "Petarmor - 12 Ct",
    "Petarmor Plus Collar",
    "Georges Farmers Market Chicken Wings",
    "Cascadian Farm Frozen Fruit",
    "Cascadian Farm Frozen Beans",
    "Cascadian Farm Frozen Vegetables",
    "Cascadian Farm Hearty Blend",
    "Cascadian Farm Mirepoix",
    "Cascadian Farm Frozen Vegetabe Mix",
    "Cascadian Farm Frozen Potatoes",
    "Spearmint Seasonal",
    "Spearmint Multipack",
    "Spearmint Single Pack",
    "Cascadian Farm Frozen Fruit Juice Concentrate",
    "Garelick Farms Conventional White Milk",
    "Garelick Farms Light Cream",
    "Garelick Farms Heavy Cream",
    "Garelick Farms Fat Free Half And Half",
    "Garelick Farms Half And Half",
    "Petarmor - 8 Ct",
    "Arm & Hammer Shoe Refresher Spray",
    "Arm & Hammer Foot Wipes",
    "Arm & Hammer Foot Powder Spray",
    "Arm & Hammer Foot Powder",
    "Hillshire Farm",
    "Hillshire Farm Lit\'l Smokies - 3 Pound",
    "Hillshire Farm Smoked Sausage - 4 Pack",
    "Arm & Hammer Liquid Laundry Detergent",
    "Arm & Hammer Baking Soda & Baking Powder",
    "Arm & Hammer Refrigerator Accessories",
    "Arm & Hammer Laundry Sheets",
    "Arm & Hammer Laundry Paks",
    "Arm & Hammer Fabric Softener & Dryer Sheets",
    "Arm & Hammer Fabric Refreshers",
    "Arm & Hammer All-puprpose Cleaners",
    "Arm & Hammer Cat Litter",
    "Arm & Hammer Pet Odor & Stain Removers",
    "Arm & Hammer Toothpaste",
    "Arm & Hammer Gender Neutral Deodorant & Antiperspirant",
    "Arm & Hammer Allergy & Sinus Medicines & Treatment",
    "Arm & Hammer Carpet Cleaner",
    "Arm & Hammer Pool & Spa Accessories",
    "Litehouse Spinach Parmesan Dip",
    "Lucky Charms Cereal Medium Size",
    "Lucky Charms Frosted Flakes Unicorn Cereal Medium Size",
    "Cascadian Farm Granola Bars",
    "Cocoa Puffs Lucky Charms Cereal",
    "Chocolate Lucky Charms Cereal Medium Size",
    "Lucky Charms Unicorn Cereal Family Size",
    "Lucky Charms Cereal Giant Size",
    "Lucky Charms Cereal Family Size",
    "Chocolate Lucky Charms Cereal",
    "Fruity Lucky Charms Cereal Family Size",
    "Georges Farmers Market Chicken",
    "Lucky Charms Unicorn Cereal Large Size",
    "Fruity Lucky Charms Cereal Medium Size",
    "Fruity Lucky Charms Cereal Econ Bag",
    "Modern Farmhouse Magazine",
    "Lucky Charms Limited Edition Cereal",
    "Lucky Charms Cereal Large Size",
    "Lucky Charms Cereal Honey Clovers - Family Size",
    "Lucky Charms Cereal",
    "Chocolate Lucky Charms Econ Bag",
    "Lucky Charms Oatmeal",
    "Petarmor - 6 Ct",
    "Sargento Grated Parmesan Cheese",
    "Cascadian Farm Cereal",
    "Lucky Charms Cereal Econ Bag",
    "Cascadian Farm Ancient Grains",
    "Once Upon A Farm Pouches",
    "Once Upon A Farm Frozen Meals",
    "Lucky Charms Unicorn Cereal Giant Size",
    "Pillsbury Lucky Charms Ready To Bake Sugar Cookies",
    "Cascadian Farm Granola",
    "Lucky Charms Cereal Honey Clovers - Medium Size",
    "Cascadian Farm Protein Bars",
    "Petarmor Capaction",
    "Lucky Charms Soft Baked Bars",
    "Lucky Charms Cereal Cup",
    "Chocolate Lucky Charms Cereal Family Size",
    "Lucky Charms Cereal Treats",
    "Chocolate Lucky Charms Haunted Marshmallows Cereal",
    "Lucky Charms Cereal Treats Multipack",
    "Arm & Hammer Mouthwash",
    "Lucky Charms Cereal Treats Single Count",
    "Hillshire Farm Deli Lunch Meat",
    "Lucky Charms Frosted Flakes Unicorn Cereal Family Size",
    "Arm & Hammer Baby Laundry Detergent",
    "Arm & Hammer Deep Clean Laundry Detergent",
    "Arm & Hammer Deep Clean Laundry Paks",
    "Petarmor - 3 Ct",
    "Hillshire Farm Cocktail Links",
    "Hillshire Farm Sausage Links & Bratwurst",
    "Hillshire Farm Summer Sausage",
    "Hillshire Farm Ham Halves & Quarters",
    "Hillshire Farm Smoked Sausage",
    "Hillshire Farm Snack Kits",
    "Zeiss Warming Eye Mask",
    "Foster Farms Chicken Fresh & Natural",
    "Foster Farms Turkey Fresh & Natural",
    "Foster Farms Chicken Simply Raised",
    "Foster Farms Turkey Simply Raised",
    "Foster Farms Chicken Organic",
    "Foster Farms Turkey Organic",
    "Foster Farms Take Out",
    "Foster Farms Chicken Refrigerated",
    "Foster Farms Corn Dogs",
    "Foster Farms Chicken Prepared Frozen",
    "Foster Farms Chicken Unprepared Frozen",
    "Foster Farms Turkey Deli Meat",
    "Foster Farms Chicken Deli Meat",
    "Foster Farms Chicken Franks",
    "Foster Farms Handcrafts",
    "Carmella Creeper Cereal",
    "Cascadian Farm Powered By Plants",
    "Cascadian Farm Riced Vegetables",
    "Cascadian Farm Soft Baked Squares",
]
