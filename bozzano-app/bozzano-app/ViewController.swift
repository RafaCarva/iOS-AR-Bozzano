//
//  ViewController.swift
//  bozzano-app
//
//  Created by Rafael Carvalho on 19/08/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //Create a new Scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        //Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object Detection, ARRG é o nome do seu AR Resource Group
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "ARRG", bundle: Bundle.main)!

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
            
        if let objectAnchor = anchor as? ARObjectAnchor {
            
            let plane = SCNPlane(
                width: CGFloat(objectAnchor.referenceObject.extent.x ),
                height: CGFloat(objectAnchor.referenceObject.extent.y / 2)
            )
            plane.cornerRadius = plane.width / 8
            
            let spriteKitScene = SKScene(fileNamed: "product") //é o nome do seu .sks (que tem o "bozzano" escrito)
            
            //Adicionaro o SK nao plane
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x,
                                                objectAnchor.referenceObject.center.y + 0.1,
                                                objectAnchor.referenceObject.center.z)
            
            planeNode.rotation = SCNVector4Make(0, 1, 0, Float.pi / 3.5)
            
            //planeNode.eulerAngles.x = Float.pi / -0.5
            node.addChildNode(planeNode)
            
        }else{
            print("não achou anchor")
        }
           
            return node
        }

}
