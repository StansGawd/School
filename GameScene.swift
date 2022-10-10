//
//  GameScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/21/22.
//

import SpriteKit
import GameplayKit

/**
 This is the main game scene, where all the actions happens, of moving the spaceship and shooting it, all
 the function will be in this scene file
 */

// create local game score so we can access it in other scenes and display it
var gameScore = 0;

let buttonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)

class GameScene: SKScene, SKPhysicsContactDelegate  {
     // global explosion sound for when bullet hits enemy or enemy hits player
    let playExplosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    
    var level = 0;
    
    // label for game purposes
    let scoreLabel = SKLabelNode(fontNamed: "PixelHigh")
    let restartLbl = SKLabelNode(fontNamed: "PixelHigh")
    let startLabel = SKLabelNode(fontNamed: "PixelHigh")

    let player = SKSpriteNode(imageNamed: "ship")
    
    // variable touching screen which will be used to fire bullets everytime the user holds down finger on the screen
    var touchingScreen = true
    
    // create an enumeration of where the state we are in the game, and depending on what state it is, we will continue/postpone certain actions
    enum gameState {
        case preGame
        case duringGame
        case postGame
    }
    
    // initialize game state as pre game since we haven't started playing the game
    var currentGameState = gameState.preGame
    
    // physics categories which will be used for collisions and physics in the game i.e. when spaceship hits enemy or enemy touches bullets
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Bullet: UInt32 = 0b10
        static let Enemy: UInt32 = 0b100
    }
    
    // create game area to get dimensions
    var gameArea: CGRect
    
    
    
    override init(size: CGSize){
        // make it so we can access the game area dimensions
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
            
        
        
    }
    
    // error check
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        // initialize physics into our game
        self.physicsWorld.contactDelegate = self
        
        // sets background and for loop makes background move up to make it look like the spaceship is moving
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed:"background" )
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            // actually makes the background move up
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        
        // create player and set it to its appropriate position at the start of the game
        player.setScale(8)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        //create physics body and assign categories to it
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        // make it so if player makes contact with enemy it'll notify us
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        // sets up the score label to show the user the score
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 150
        scoreLabel.fontColor = SKColor.orange
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        // sets up restart label so when user clicks on it it will restart the game
        restartLbl.text = "⏻"
        restartLbl.fontSize = 110
        restartLbl.fontColor = SKColor.red
        restartLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        restartLbl.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.9)
        restartLbl.zPosition = 100
        self.addChild(restartLbl)
        
        // if we haven't started the game, we will display a
        // tap to begin label that will start the game when we tap the screen
        if currentGameState == gameState.preGame {
            startLabel.text = "Tap To Begin"
            startLabel.fontSize = 100
            startLabel.zPosition = 100
            startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            startLabel.fontColor = SKColor.white
            self.addChild(startLabel)
        }
        
    }
    
    // function will add score, this will be ran everytime user kills an enemy
    func addScore(){
        // increments gamescore variable
        gameScore += 1
        
        // sets up score level thresholds
        let scoreLvl2 = 15
        let scoreLvl3 = 35
        
        // display score
        scoreLabel.text = "Score : \(gameScore)"
        
        // if gamescore is 100, game will dispay the end prize screen
        if gameScore == 100 {
            EndGame()
        }
        
        // if user reaches certain thresholds of their score, the level will increase by calling startnewlevel function
        if gameScore == scoreLvl2 || gameScore == scoreLvl3 {
            startNewLevel()
        }
    }
    
    // function gets called when user dies, this will do all the necessary actions to the game to make it game over
    func gameOver(){
        // modify the current game state
        currentGameState = gameState.postGame
        
        //remove all actions to stop them from happening
        self.removeAllActions()
        
        // stops bullet from firing and all their actions
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        // stop enemy from spawning and all their actions
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        // sets touching screen to false in case they try to fire
        touchingScreen = false
        
        // sets up the new change scene, and switches to the game over screen
        let changeScene = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    // function recognizes when user reaches the highest point possible in the game, and will bring the user to the end screen with their prize
    func EndGame(){
        /// modify the current game state
        currentGameState = gameState.postGame
        
        //remove all actions to stop them from happening
        self.removeAllActions()
        
        // stops bullet from firing and all their actions
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        // stop enemy from spawning and all their actions
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        // sets touching screen to false in case they try to fire
        touchingScreen = false
        
        
        // transitions to the end scene that displays the prize
        let changeScene = SKAction.run(ChangeToEndScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    // function runs when we restart the game, does everything necessary to restart it
    func RestartGame(){
        // sets current game state to not playing and remove all actions
        currentGameState = gameState.postGame
        self.removeAllActions()
        
        // remove all bullet actions
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        // remove all enemy actions
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        touchingScreen = false
        
        // transitions to the restart scene
        let changeScene = SKAction.run(ChangeToRestartScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0.25)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    //function brings us to the restart scene
    func ChangeToRestartScene(){
        let sceneToMoveTo = RestartScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
    }
    
    // function brings us to the end scene
    func ChangeToEndScene(){
        let sceneToMoveTo = EndGameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
    }
    
    // function brings us to the game over scene
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)

    }
    
    // function recognizes a physics contact, and will does the appropriate actions based on which physics body it is
    func didBegin(_ contact: SKPhysicsContact) {
        // creates the 2 physics body
        var b1 = SKPhysicsBody()
        var b2 = SKPhysicsBody()
        
        // sets the physics body based on the heirarchy of the physics category
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            b1 = contact.bodyA
            b2 = contact.bodyB
        }
        else {
            b1 = contact.bodyB
            b2 = contact.bodyA
        }
        
        // if bullet hits enemy
        if b1.categoryBitMask == PhysicsCategories.Bullet && b2.categoryBitMask == PhysicsCategories.Enemy{
            
            // makes sure enemy has to be on the screen to get hit
            if b2.node != nil {
                if b2.node!.position.y > self.size.height*0.97 {
                    return
                }
                //explode the enemy and adds score
                Explosion(spawnPosition: b2.node!.position)
                addScore()
            }
            // delete bullet and enemy
            b1.node?.removeFromParent()
            b2.node?.removeFromParent()
            
        }
        
        // if enemy hits palyer
        if b1.categoryBitMask == PhysicsCategories.Player && b2.categoryBitMask == PhysicsCategories.Enemy{
        
            // create explosion and delete the player and enemy
            if b1.node != nil && b2.node != nil {
                Explosion(spawnPosition: b1.node!.position)
                Explosion(spawnPosition: b2.node!.position)
            }
            b1.node?.removeFromParent()
            b2.node?.removeFromParent()
            
            // run the game over function to bring us to the game over screen
            gameOver()
        }
    }
    
    // function creates an explosion at a given point
    func Explosion(spawnPosition: CGPoint){
        // sets up the image for explosion
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.setScale(8)
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        // create the effect of the explosion growing bigger and then disappear
        let scaleBigger = SKAction.scale(to: 8, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let deleteExplosion = SKAction.removeFromParent()
        
        // run the explosion
        let explosionSequence = SKAction.sequence([playExplosionSound, scaleBigger, fadeOut, deleteExplosion])
        explosion.run(explosionSequence)
        
    }
    
    // function gets run to start a level, or when a user reaches a new level
    func startNewLevel(){
        
        level += 1
    
        
        // removes the label and stop spawning enemies for a quick moment
        let removeLabel = SKAction.removeFromParent()
        startLabel.run(removeLabel)
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
    
        var levelDuration = TimeInterval()
        var enemySpeed = Double(3)
        
        // modifies the speed of the enemy and spawn rate of the enemy
        if level == 1 {
            levelDuration = 1.2
            enemySpeed = 2.0
        }
        else if level == 2 {
            levelDuration = 0.75
            enemySpeed = 1
        }
        else if level == 3 {
            levelDuration = 0.65
            enemySpeed = 0.75
        }
        else {
            levelDuration = 0.3
            enemySpeed = 1;
            print("Level is invalid")
        }
        
        // spawn enemies by calling function giving their speed, as well as spawn enemies given their spawn rate
        let spawn = SKAction.run({self.spawnEnemy(spawnSpeed: Double(enemySpeed))})
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawnEnemies")
    }
    
    // function fires bullet
    func fireBullet(){
        // create bullet node
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(6)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        // create physics body, and notifies us when it makes contact with enemy
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        // create the animation of bullet moving upwards
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 0.3)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    // function spawn enemies given their speed
    func spawnEnemy(spawnSpeed: Double){
        // create a random x area given the range
        let XSpawn = CGFloat.random(in: -(gameArea.minX*2)...(gameArea.maxX)*1.45)
        
        // create the start point with the random x coordinate, and y will be outside the screen
        // we will create an end point for the enemy to travel to, which will be the player
        let startPoint = CGPoint(x: XSpawn, y: self.size.height*1.2)
        let endPoint = CGPoint (x: player.position.x, y: -self.size.height * 0.2)
        
        // create enemy node
        let enemy = SKSpriteNode(imageNamed:"meteor")
        enemy.name = "Enemy"
        enemy.setScale(6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        // sets up physics body for enemy and notifies us if it makes contact with bullet or player
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        self.addChild(enemy)
        
        // make the enemy move from the random spawn to the player
        let moveEnemy = SKAction.move(to: endPoint, duration: TimeInterval(spawnSpeed))
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        // makes sure to make the enemy spawn only if the game state is during the game
        if currentGameState == gameState.duringGame {
            enemy.run(enemySequence)
        }
        
        // based on their direction, rotate it so it will face towards the player when travelling
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let degreeRotation = atan2(dy,dx)
        enemy.zRotation = degreeRotation
    }
    
    // function recognizes when user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = true
        
        // if we're in pregame, that means we are starting the game, so we will start it and change the game state
        if currentGameState == gameState.preGame {
            currentGameState = gameState.duringGame
            startNewLevel()
        }
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            //turns this into a button, restartLabel will recognize when user touches on it
            if restartLbl.contains(pointOfTouch) {
                restartLbl.run(buttonClick)
                RestartGame()
                
            }
        }
    }
    
    
    // if touches cancelled the set touching screen false, will be used for holding down to shoot bullets, touchesEnded func is also used for the same purpose
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    // variables to use to move the background up
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    // function is used to move the background and fire the bullet when user touches the screen
    override func update(_ currentTime: TimeInterval) {
        
        // every time user holds down on the screen and is playing the game, we fire the bullet
        if touchingScreen == true && currentGameState == gameState.duringGame{
            fireBullet()
        }
        
        // increments the update time
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            
        }
        // find the difference between the times and keeps incrementing it
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        // sets how much the background moves based on the amount of time has passed
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        // actually moves the background
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            background.position.y -= amountToMoveBackground
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    // tracks the drag happening from the user
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            // finds the first and last point of touch from user to find the distance of their drag
            let pointofTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            // find the amount of drag in terms of x and y
            let distancex = pointofTouch.x - previousPointOfTouch.x
            let distancey = pointofTouch.y - previousPointOfTouch.y
            
            // moves the player based on the distance drag
            player.position.x += distancex
            player.position.y += distancey
            
            // sets up boundaries for the player, can't move it off the screen
            if (player.position.x < gameArea.minX + (player.size.width*2)){
                player.position.x = gameArea.minX + (player.size.width*2)
            }
      
            if (player.position.x > gameArea.maxX - (player.size.width*2)){
                player.position.x = gameArea.maxX - (player.size.width*2)
            }
            
            if player.position.y < gameArea.minY + (player.size.height*2){
                player.position.y = gameArea.minY + (player.size.height*2)
            }
            
            if player.position.y > gameArea.maxY - player.size.height*2 {
                player.position.y = gameArea.maxY - player.size.height*2
            }
        }
    }
}
