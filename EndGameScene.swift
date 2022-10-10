//
//  endGame.swift
//  spaceship_game
//
//  Created by Khang Le on 4/26/22.
//

import AVKit
import AVFoundation
import UIKit
import Foundation
import SpriteKit

// this is the prize screen, if user gets 100 points it will bring them to the prize screen
class EndGameScene: SKScene {
    
    // global restartlabel so we can use it in other functions
    let restartLabel = SKLabelNode(fontNamed: "PixelHigh")
    
    override func didMove(to view: SKView) {
        
        // sets up backgruond
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // sets up congratulations label
        let congratulationsLabel = SKLabelNode(fontNamed: "PixelHigh")
        congratulationsLabel.text = "Congratulations!"
        congratulationsLabel.fontColor = SKColor.white
        congratulationsLabel.fontSize = 165
        congratulationsLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.70)
        congratulationsLabel.zPosition = 1
        self.addChild(congratulationsLabel)

        // sets up label for pin number of gift card
        let endGameLabel = SKLabelNode(fontNamed: "PixelHigh")
        endGameLabel.text = "6364 9110 0203 \n9933 187; \nPIN: 1695"
        endGameLabel.fontSize = 70
        endGameLabel.fontColor = SKColor.white
        endGameLabel.zPosition = 1
        endGameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(endGameLabel)
         
        
        // sets up restart label
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.red
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            //turns this into a button, restartLabel will recognize when user touches on it
            if restartLabel.contains(pointOfTouch) {
                restartLabel.run(buttonClick)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                
                let Transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Transition)
            }
        }
    }
    
    
}
