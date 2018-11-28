//
//  GameScene.swift
//  TreasureHunt
//
//  Created by Tom Shiflet on 11/15/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let DIMS:Int=100
    let moveSpeed:CGFloat = 20
    let TREECOUNT:Int = 1500
    
    let ZOOMMAX:CGFloat = 3.0
    let ZOOMMIN:CGFloat = 0.5
    
    let grasstile=SKSpriteNode(imageNamed: "grasstile")
    let grass01=SKTexture(imageNamed: "grasstile")
    let grass02=SKTexture(imageNamed: "grasstile01")
    let grass03=SKTexture(imageNamed: "grasstile02")
    
    let player=SKSpriteNode(imageNamed: "adventurer_back")

    let tree=SKSpriteNode(imageNamed: "tree01")
    
    
    var myCam:SKCameraNode?

    var playerLight=SKLightNode()
    
    
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    var upPressed:Bool=false
    var downPressed:Bool=false
    var zoomOutPressed:Bool=false
    var zoomInPressed:Bool=false
    
    
    
    override func didMove(to view: SKView) {
        myCam=SKCameraNode()
        self.camera=myCam!
        addChild(myCam!)
        myCam!.setScale(1.5)
        
        
        grasstile.setScale(0.5)
        
        player.zPosition=5
        addChild(player)
        
        playerLight.isEnabled=true
        playerLight.categoryBitMask=1
        playerLight.falloff=2.5
        player.addChild(playerLight)
        
        let lightFlickerAction = SKAction.sequence([SKAction.falloff(by: -0.4, duration: 0.08), SKAction.falloff(by: 0.4, duration: 0.08)])
        playerLight.run(SKAction.repeatForever(lightFlickerAction))
        
        
        
        // generate ground tiles
        for y in 1...DIMS
        {
            for x in 1...DIMS
            {
                let posX:CGFloat = (CGFloat(DIMS/2)*grasstile.size.width)-(CGFloat(DIMS-x)*grasstile.size.width)
                let posY:CGFloat = (CGFloat(DIMS/2)*grasstile.size.height)-(CGFloat(DIMS-y)*grasstile.size.height)
                let tempTile=grasstile.copy() as! SKSpriteNode
                tempTile.position.x=posX
                tempTile.position.y=posY
                tempTile.zPosition = -100000
                let tileVariant = random(min: 0, max: 9.99999)
                
                if tileVariant < 0.1
                {
                    tempTile.texture=grass03
                } // if tile 3
                else if tileVariant < 0.2
                {
                    tempTile.texture=grass02
                } // if tile 2
                else
                {
                    tempTile.texture=grass01
                } // otherwise default tile
        
                tempTile.lightingBitMask=1
                addChild(tempTile)
                
            } // for x
            
        } // for y
       
        // Generate Trees
        for _ in 1...TREECOUNT
        {
            let tempTree=tree.copy() as! SKSpriteNode
            let x=random(min: -(CGFloat((DIMS-1)/2)*grasstile.size.width), max: (CGFloat((DIMS-1)/2)*grasstile.size.width))
            let y = random(min: -(CGFloat((DIMS-1)/2)*grasstile.size.height), max: (CGFloat((DIMS-1)/2)*grasstile.size.height))
            tempTree.setScale(random(min: 0.2, max: 0.6))
            tempTree.position=CGPoint(x: x, y: y)
            tempTree.zPosition = -tempTree.position.y
            tempTree.lightingBitMask=1
            addChild(tempTree)
            
        } // for each tree
        
    } // func didMove
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {

        case 0:
            leftPressed=true
            
        case 2:
            rightPressed=true
            
        case 1:
            downPressed=true
            
        case 13:
            upPressed=true
            
        case 33:
            zoomOutPressed=true
            
        case 30:
            zoomInPressed=true
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    } // keyDown
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
            
        case 0:
            leftPressed=false
            
        case 2:
            rightPressed=false
            
        case 1:
            downPressed=false
            
        case 13:
            upPressed=false
            
        case 33:
            zoomOutPressed=false
            
        case 30:
            zoomInPressed=false
            
  
        default:
            break
        }
    } // keyUp
    
    
    func checkKeys()
    {
        if upPressed
        {
            if player.position.y < (CGFloat((DIMS-1)/2)*grasstile.size.height)-size.height/2*ZOOMMAX
            {
                myCam!.position.y += moveSpeed
            }
        }
        
        if downPressed
        {
            if player.position.y > -(CGFloat((DIMS-1)/2)*grasstile.size.height)+size.height/2*ZOOMMAX
            {
                myCam!.position.y -= moveSpeed
            }
        }
        
        if leftPressed
        {
            if player.position.x > -(CGFloat((DIMS-1)/2)*grasstile.size.width)+size.width/2*ZOOMMAX
            {
                    myCam!.position.x -= moveSpeed
            }
            
        }
        
        if rightPressed
        {
            if player.position.x < (CGFloat((DIMS-1)/2)*grasstile.size.width)-size.width/2*ZOOMMAX
            {
            myCam!.position.x += moveSpeed
            }
        }
        
        if zoomInPressed
        {
            if myCam!.xScale > ZOOMMIN
            {
                let scale=myCam!.xScale - 0.01
                myCam!.setScale(scale)
            }
        }
        
        if zoomOutPressed
        {
            if myCam!.xScale < ZOOMMAX
            {
                let scale=myCam!.xScale + 0.01
                myCam!.setScale(scale)
            }
        }
        
        player.position = myCam!.position
        player.zPosition = -player.position.y - player.size.height/2
        
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        checkKeys()
    }
}
