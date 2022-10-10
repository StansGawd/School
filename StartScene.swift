//
//  StartScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/27/22.
//

import Foundation
import SpriteKit

// This is the main menu screen, the first scene the user sees when the open the app
class StartScene: SKScene {
    
    // create a label that says start, will be used as a button later on to bring us
    // into the game scene
    let startLabel = SKLabelNode(fontNamed: "PixelHigh")
    
    // function that creates the view in our scene
    override func didMove(to view: SKView) {
        
        //create the background, background will be same for all scenes
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // create first label for the title of the app, there will be two lines for title
        let appLabel1 = SKLabelNode(fontNamed: "PixelHigh")
        appLabel1.text = "BANG BANG"
        appLabel1.fontSize = 170
        appLabel1.fontColor = SKColor.white
        appLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.70)
        appLabel1.zPosition = 100
        self.addChild(appLabel1)
        
        // create second label for the app name
        let appLabel2 = SKLabelNode(fontNamed: "PixelHigh")
        appLabel2.text = "PEW PEW"
        appLabel2.fontSize = 170
        appLabel2.fontColor = SKColor.white
        appLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.63)
        appLabel2.zPosition = 100
        self.addChild(appLabel2)
        
        // create the first label that says get 100 points to win a prize
        let prizeLabel1 = SKLabelNode(fontNamed: "PixelHigh")
        prizeLabel1.text = "Reach 100 Points"
        prizeLabel1.fontSize = 90
        prizeLabel1.fontColor = SKColor.white
        prizeLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.53)
        prizeLabel1.zPosition = 100
        self.addChild(prizeLabel1)

        // create the 2nd label for the prize
        let prizeLabel2 = SKLabelNode(fontNamed: "PixelHigh")
        prizeLabel2.text = "Get A Pleasant Surprise"
        prizeLabel2.fontSize = 90
        prizeLabel2.fontColor = SKColor.white
        prizeLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.48)
        prizeLabel2.zPosition = 100
        self.addChild(prizeLabel2)
        
        // sets up the label that says start game, will be used as a button later on
        startLabel.text = "START GAME"
        startLabel.fontSize = 95
        startLabel.fontColor = SKColor.orange
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.34)
        startLabel.zPosition = 100
        startLabel.name = "startButton"
        self.addChild(startLabel)
    }
    
    //function recognizes when the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            // find the location the user touches on the screen
            let pointOfTouch = touch.location(in: self)
            
            //if the location of user's touch is on the start game label, it will
            // bring the user onto the game scene
            if startLabel.contains(pointOfTouch) {
                // plays the sound of a button click
                startLabel.run(buttonClick)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                
                // switches scene
                let Transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Transition)
            }
        }
    }
}
