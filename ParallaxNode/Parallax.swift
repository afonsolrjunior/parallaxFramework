//
//  Parallax.swift
//  MusicMaster
//
//  Created by Afonso Lucas e Marcos Fellipe Costa Silva on 02/06/17.
//  Copyright © 2017 Afonso Lucas & Marcos Silva. All rights reserved.
//

import SpriteKit

public class Parallax : SKSpriteNode {
    //MARK: Attributes
    private var backGroundWidth : CGFloat!
    private var repetitionsCount : Int!
    private var layerCount : Int!
    private var xPosition: CGFloat!
    private var yPosition: CGFloat!
    
    //MARK: Setup
    /**
     Método para inicializar o parallax.
     - Parameters:
     - backGroundWidth: Largura dos backgrounds.
     - repetionsCount: Quantidade de repetições que irá determinar a quantidade de nodes para cade layer.
     - layerCount: Quantidade de layers.
     - xPosition: Posição x do parallax
     - yPosition: Posição y do parallax
     */
    public func setup(backGroundWidth: CGFloat, repetitionsCount: Int, layerCount: Int, xPosition: CGFloat, yPosition: CGFloat) {
        self.backGroundWidth = backGroundWidth
        self.repetitionsCount = repetitionsCount
        self.layerCount = layerCount
        self.xPosition = xPosition
        self.yPosition = yPosition
    }
    
    //MARK: ManipulateLayers
    /**
     Método para adicionar os layers ao parallax.
     - Parameters:
     - namesOfImages: Array com os nomes das texturas.
     - namesOfBackground: Array com os nomes dos backgrounds.
     */
    public func addLayers(namesOfImages: [String], namesOfBackground: [String]) {
        
        if namesOfImages.count != layerCount || namesOfBackground.count != layerCount {
            fatalError("The size of one of the arrays does not match the layer count!")
        }
        
        for i in 0...self.repetitionsCount{
            
            for j in 0...self.layerCount - 1 {
                createLayer(backGroundZPosition: -15 - j, iterator: i, imageName: namesOfImages[j], backgroundName: namesOfBackground[j])
            }
            
        }
        
    }
    
    /**
     Método para criar uma layer e a adicionar ao parallax.
     - Parameters:
     - backGroundZPosition: zPosition do background.
     - iterator: Valor do iterador na repetição.
     - imageName: Nome da textura.
     - backgroundName: Nome do background.
     */
    private func createLayer(backGroundZPosition: Int, iterator: Int, imageName: String, backgroundName: String) {
        
        let backGround = SKSpriteNode(imageNamed: imageName)
        backGround.name = backgroundName
        backGround.anchorPoint  = CGPoint(x: 0.0, y: 0.0)
        backGround.size.height = 380
        backGround.position = CGPoint(x: self.xPosition + (CGFloat(iterator) * self.backGroundWidth), y: self.yPosition)
        backGround.zPosition = CGFloat(backGroundZPosition)
        addChild(backGround)
        
    }
    
    //MARK: - moveBackground
    /**
     Método para mover o parallax.
     - Parameters:
     - moveX: Velocidade do parallax.
     - cameraNode: Camera necessária para realização dos cálculos de posição.
     - layersNames: Array com os nomes dos layers.
     */
    public func moveBackGround(moveX : CGFloat, cameraNode: SKCameraNode, layersNames: [String]) {
        
        if layersNames.count != layerCount {
            fatalError("The size of the array does not match the layer count!")
        }
        
        for i in 0...self.layerCount - 1 {
            
            self.enumerateChildNodes(withName: layersNames[i], using: ({
                (node, error) in
                
                node.position.x += moveX / CGFloat((i + 1) * 2)
                if moveX < 0 {
                    self.repositionBackgroundAfter(backgroundNode: node as! SKSpriteNode, changeXPoint: cameraNode.position.x, repetitionCount: self.repetitionsCount)
                } else if moveX > 0 {
                    self.repositionBackgroundBefore(backgroundNode: node as! SKSpriteNode, changeXPoint: cameraNode.position.x, repetitionCount: self.repetitionsCount, cameraNode: cameraNode)
                }
                
            }))
            
        }
        
    }
    
    /**
     Método para reposicionar o node a direita do layer.
     - Parameters:
     - backGroundNode: Node a ser reposicionado.
     - changeXPoint: Posição chave para mudança de posição
     - repetionsCount: quantidade de repetições que irá determinar a quantidade de nodes para cade layer.
     */
    private func repositionBackgroundAfter(backgroundNode: SKSpriteNode, changeXPoint: CGFloat, repetitionCount: Int) {
        
        if (backgroundNode.position.x + ((backgroundNode.size.width-2) * 2)) <= changeXPoint {
            backgroundNode.position.x = backgroundNode.position.x + ((backgroundNode.size.width) * CGFloat(repetitionCount + 1))
        }
        
    }
    
    /**
     Método para reposicionar o node a esquerda do layer.
     - Parameters:
     - backGroundNode: Node a ser reposicionado.
     - changeXPoint: Posição chave para mudança de posição
     - repetionsCount: Quantidade de repetições que irá determinar a quantidade de nodes para cade layer.
     - cameraNode: Camera necessária para realização dos cálculos de posição.
     */
    private func repositionBackgroundBefore(backgroundNode: SKSpriteNode, changeXPoint: CGFloat, repetitionCount: Int, cameraNode: SKCameraNode) {
        
        if (backgroundNode.position.x - backgroundNode.size.width-2) >= (changeXPoint + cameraNode.frame.width) {
            backgroundNode.position.x = backgroundNode.position.x - ((backgroundNode.size.width) * CGFloat(repetitionCount + 1))
        }
        
    }
    
}

