//
//  ViewController.swift
//  rainbow
//
//  Created by Griffin Thompson on 5/19/21.
//  Copyright © Griffin Thompson. Licensed under the MIT License (if it ever gets released!)
//

import UIKit

class RainbowVC: UIViewController {
//---------------------------------------------
//------------VARIABLE DECLARATIONS------------
    let ratio: CGFloat = 0.03
    var currentEndColor : UIColor = Colors.red
    @IBOutlet weak var btnOutlet: UIButton!
//---------------------------------------------
//---------------------------------------------

    
//---------------------------------------------
//--------------OVERRIDE FUNCTIONS-------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting the view background color manually because otherwise
        // it's in a weird format that fucks up the interpolate() function
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(rainbow))
        displayLink.add(to: .main, forMode: .common)
    }
//---------------------------------------------
//---------------------------------------------
    

    
    @objc func rainbow()
    {
        interpolateTowards()
        let endColor = interpolate(startValue: view.backgroundColor!, endValue: currentEndColor)
        
        view.backgroundColor = endColor
    }
    
    func interpolate(startValue: UIColor, endValue: UIColor) -> UIColor
    {
        
        // Here we seperate the startValue and endValue into CGFloats which are things that
        // we can do maths on ex. multiply/divide
        
        // just using the force unwrap operator cause these things should never be empty
        let r1 = startValue.cgColor.components![0]
        let g1 = startValue.cgColor.components![1]
        let b1 = startValue.cgColor.components![2]
        
        let r2 = endValue.cgColor.components![0]
        let g2 = endValue.cgColor.components![1]
        let b2 = endValue.cgColor.components![2]
        
        
        // basically just making our starting color ratio % (currently 0.03 so 3%) closer to our end color.
        // for example, if you have white as your starting color and red as your end/"desired" color, the function would do this:
        // assuming the values of
        // white: r: 1, g: 1, b: 1
        // red: r: 1, g: 0, b: 0
        
        // interpRed   = (1 - 1) * 0.03 + 1 = 1
        // interpGreen = (0 - 1) * 0.03 + 1 = 0.97 NOTE: We're 3% closer to our desired value (0) here!
        // interpBlue  = (0 - 1) * 0.03 + 1 = 0.97
        
        // In the end, we get a color that's a little more red than we started with.
        // After enough calls of this function (every frame is when it's called)
        // we will get a more and more red tinted color.
        let interpRed = (r2 - r1) * ratio + r1
        let interpGreen = (g2 - g1) * ratio + g1
        let interpBlue = (b2 - b1) * ratio + b1
        
        
        // the fully constructed and ready to go color
        return UIColor(red: interpRed, green: interpGreen, blue: interpBlue, alpha: 1)
        
    }
    
    func interpolateTowards()
    {
        // getting the current color of the view.
        // basically, what color is the background right now?
        let currentRed = view.backgroundColor?.cgColor.components![0]
        let currentGreen = view.backgroundColor?.cgColor.components![1]
        let currentBlue = view.backgroundColor?.cgColor.components![2]
        
        // currentEndColor is the color that our interpolate() is making our starting color fade towards
        // The way the changing colors work is that we have the colors of the rainbow split into chunks
        // it's like this: at one moment, the program will be in "red mode" and will be working towards "orange mode"
        // and all calls of the interpolate function will make the red a little more orange.
        // after a few cycles, what used to be our red is now going to be very (almost completely) orange
        // obviously, we want to start transitioning towards the next color of the rainbow (yellow),
        // so the if statements inside the case check if we're orange enough to switch to "yellow mode"
        switch (currentEndColor)
        {
        case Colors.red:
            if (currentRed! > CGFloat(0.96))
            {
                // if you're confused why everything is 0.96 instead of something like 240,
                // it's because the RGB for UIKit is based on 0 to 1 instead of the
                // more standard 0 to 255 for RGB
                
                // Also, we just have to do the cast to CGFloat because it won't work with normal floats or doubles.
                currentEndColor = Colors.orange
                break
            }
        case Colors.orange:
            if (currentRed! > CGFloat(0.96) && currentGreen! > CGFloat(0.48))
            {
                currentEndColor = Colors.yellow
                break
            }
        case Colors.yellow:
            if (currentRed! > CGFloat(0.96) && currentGreen! > CGFloat(0.96))
            {
                currentEndColor = Colors.green
                break
            }
        case Colors.green:
            if (currentGreen! > CGFloat(0.48))
            {
                currentEndColor = Colors.cyan
                break
            }
        case Colors.cyan:
            if (currentGreen! > CGFloat(0.96) && currentBlue! > CGFloat(0.96))
            {
                currentEndColor = Colors.blue
                break
            }
            
        case Colors.blue:
            if (currentBlue! > CGFloat(0.96))
            {
                currentEndColor = Colors.purple
                break
            }
            
        case Colors.purple:
            if (currentRed! > CGFloat(0.48) && currentBlue! > CGFloat(0.96))
            {
                currentEndColor = Colors.red
                break
            }
        default:
            // this force crashes the app, but we should never get here anyways.
            fatalError("error changing colors!")
            
        }
    }

}

// basically an enum defining colors that we want to be available all the time.
// I could have declared them just normally without the struct but meh.
struct Colors
{
    // warm
    static let red = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    static let orange = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
    static let yellow = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    
    // cold
    static let green = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    static let cyan = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
    static let blue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    static let purple = UIColor(red: 0.5, green: 0, blue: 1, alpha: 1)
}

