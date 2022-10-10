//
//  GameOverScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/25/22.
//

import Foundation
import SpriteKit

// this is the game over screen, when the user dies it will bring us here
class GameOverScene: SKScene {
    
    // create restart label and made it global so that other function can access it
    let restartLabel = SKLabelNode(fontNamed: "PixelHigh")
    override func didMove(to view: SKView) {
        // create background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // create label that says game over
        let gameOverLabel = SKLabelNode(fontNamed: "PixelHigh")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 165
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        // create score label that shows the user what the score is
        let scoreLabel = SKLabelNode(fontNamed: "PixelHigh")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 125
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // create user, uses a key in order to save the high score and sets it
        // so if we access high score number through the key, it will save that value
        let Udefault = UserDefaults()
        var highScoreNumber = Udefault.integer(forKey: "HighScoreSaved")
        
        // changes high score if user got a higher score
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            Udefault.set(highScoreNumber, forKey: "HighScoreSaved")
        }
        
        // sets up the high score label and outputs it
        let highScoreLabel = SKLabelNode(fontNamed: "PixelHigh")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.fontColor = SKColor.white
        self.addChild(highScoreLabel)
        
        // sets up restart label and will be used as a button later on
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.red
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
    }
    
    // function recognizes when user touches the screen
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
