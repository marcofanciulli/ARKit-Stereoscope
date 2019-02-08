// ARKit-Stereoscope
// Copyright (c) 2019 Hartwell Fong. All rights reserved.
//
// Updated Feb 7, 2019.
//
// minimal codes to start ARKit, SceneKit (read 3D files, attact a virtual camera for lefteye to ARKit iPad camera righteye to make a stereoscope)
// no error checking
// codes hardwired for Apple 2018 9.7" iPad introduced at Apple Special Event March 27, 2018 in Chicago
// Tips:
// 1. If frame rate less than 60Hz, stop codes and run again
// 2. If frame rate still low, close other apps
// 3. Experiment with smaller size OBJ files (eg. resolution>=300 from NASA Moon Trek webpage)
// 15MB model.obj was generated from resolution=200
// 4. The Swift Playgrounds Blank template has logging (which takes memory) enabled (little boxes that appears on the right side of codes when "Run My Code"). Have not found a simple solution to turn off. However, can still do interesting things with ARKit and Scenekit.
// the codes doesn't look for a flat plane to put virtual objects on, instead the initial position of the iPad is the world origin when "Run My Code" is pressed
// all virtual objects are positioned and oriented according to this world origin (with righteye.debugOptions on, the world origin is XYZ or RGB axis)

// Credits
// TychoSkymap.t4_04096x02048.jpg from NASA/Goddard Space Flight Center Scientific Visualization Studio https://svs.gsfc.nasa.gov/3442
// model.obj and texture.txt from NASA https://trek.nasa.gov/moon

import ARKit
import PlaygroundSupport

var righteye = ARSCNView()
var right = SCNScene()
righteye.scene = right
righteye.scene.background.contents = UIImage(named: "TychoSkymap.t4_04096x02048.jpg")
righteye.showsStatistics = true  // can be commented out
righteye.automaticallyUpdatesLighting = false

var lefteye = SCNView()
var left = SCNScene()
lefteye.scene = right
lefteye.showsStatistics = true  // can be commented out

let config = ARWorldTrackingConfiguration()
righteye.session.run(config)

// next four lines can be commented out to turn off debug options

 righteye.debugOptions = [
 ARSCNDebugOptions.showFeaturePoints,
 ARSCNDebugOptions.showWorldOrigin
 ]

var box = SCNScene(named: "model.obj")!
let node = box.rootNode.childNodes[0]
let position = SCNVector3(x: 0, y: 0, z: 0)
node.position = position
node.eulerAngles = SCNVector3(-1.57, 3.14, 0)
node.scale = SCNVector3(0.01, 0.01, 0.01)
righteye.scene.rootNode.addChildNode(node)

let material = node.geometry?.firstMaterial
material?.emission.contents = UIImage(named: "texture.png")

var ipd = -0.063 // interpupillary distance (meter)
var cameraNode = SCNNode()  // make camera for left eye
let camera = SCNCamera()
camera.xFov = 43  // these four variables depend on righteye.frame
camera.yFov = 41
camera.zFar = 1000
camera.zNear = 0.1
cameraNode.camera = camera
cameraNode.position = SCNVector3(ipd,0,0)
righteye.pointOfView?.addChildNode(cameraNode)

lefteye.pointOfView = cameraNode

lefteye.isPlaying = true

// codes hardwired for The Owl Stereoscopic Viewer from The London Stereoscopic Company Ltd https://www.londonstereo.com
// the stereoscope is used with a 9.7" iPad in portrait orientation lock on

var imageView = UIImageView()

lefteye.frame = CGRect(x: 0, y: 0, width: 344, height: 340
)
imageView.addSubview(lefteye)

righteye.frame = CGRect(x: 344, y: 0, width: 344, height: 340)
imageView.addSubview(righteye)

PlaygroundPage.current.liveView = imageView

// in last line, change imageview to righteye if don't have a stereoscope
// or observe differences between mono and stereo views (stereopsis)









