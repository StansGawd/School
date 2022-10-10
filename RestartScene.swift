//
//  RestartScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/26/22.
//

import SpriteKit
// scene is used to restart the game while the user is playing it
class RestartScene: SKScene {
    override func didMove(to view: SKView) {
        // create background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        background.zPosition = 0
        self.addChild(background)
        
        // create loading label
        let loadingLabel = SKLabelNode(fontNamed: "Hey Comic")
        loadingLabel.text = "Loading..."
        loadingLabel.fontColor = SKColor.white
        loadingLabel.fontSize = 125
        loadingLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.5)
        loadingLabel.zPosition = 1
        self.addChild(loadingLabel)
        
        // sets the scene to move to, which is game scene
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        // switches to game scene
        let Transition = SKTransition.fade(withDuration: 2)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
        
    }
}
