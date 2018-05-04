//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Thiago Antonio Ramalho on 01/05/18.
//  Copyright © 2018 Tramalho. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
        
    }
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    
    private func reset() {
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
    }
    
    fileprivate func setupConstraints(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
    }
    
    fileprivate func setupButtonImagesStates(_ button: UIButton, _ emptyStar: UIImage, _ filledStar: UIImage, _ highlightedStar: UIImage) {
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])
    }
    
    private func setupButtons(){
        
        reset()
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = createStar(nameOf: "filledStar", bundleIn: bundle)
        let emptyStar = createStar(nameOf: "emptyStar", bundleIn: bundle)
        let highlightedStar = createStar(nameOf: "highlightedStar", bundleIn: bundle)

        for index in 0 ..< starCount {
            
            // Create the button
            let button = UIButton()
            
            // Add constraints
            setupConstraints(button)
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //config image background
            setupButtonImagesStates(button, emptyStar, filledStar, highlightedStar)

            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        //update rating value
        updateButtonSelectionStates()
    }
    
    private func createStar(nameOf name: String, bundleIn bundle : Bundle) -> UIImage {
        return UIImage(named: name, in: bundle, compatibleWith: self.traitCollection)!
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            setupAccessibility(index, button)
        }
    }
    
    fileprivate func setupAccessibility(_ index: Int, _ button: UIButton) {
        
        let hintString = (rating == index + 1) ?
            "Tap to reset the rating to zero." : nil
        
        // Calculate the value string
        let valueString: String
        switch (rating) {
        case 0:
            valueString = "No rating set."
        case 1:
            valueString = "1 star set."
        default:
            valueString = "\(rating) stars set."
        }
        
        // Assign the hint string and value string
        button.accessibilityHint = hintString
        button.accessibilityValue = valueString
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        // If the selected star represents the current rating, reset the rating to 0.
        // Otherwise set the rating to the selected star
        rating = (selectedRating == rating) ? 0 : selectedRating
    }
}
