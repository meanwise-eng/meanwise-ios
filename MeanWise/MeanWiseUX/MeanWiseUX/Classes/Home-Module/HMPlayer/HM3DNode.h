//
//  HM3DNode.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 26/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>


@interface HM3DNode : SCNView <SCNSceneRendererDelegate>
{
    
    SCNNode *videoNode;
    SCNVector4 pValue;
    
    SCNNode *cameraNode;
}
-(void)setUpBasic;

-(void)setUp:(AVPlayer *)player;
-(void)setCameraAltitude:(CMAttitude *)altitude;
-(void)cleanUp;

@end
