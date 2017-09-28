//
//  HM3DNode.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 26/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HM3DNode.h"
#import <GLKit/GLKit.h>

@implementation HM3DNode

-(void)setUpBasic
{
    self.scene = [SCNScene scene];

}

-(void)setUp:(AVPlayer *)player
{
    pValue=SCNVector4Make(0, 0, 0, 0);

    
    
    cameraNode        = [SCNNode node];
    cameraNode.camera          = [SCNCamera camera];
    cameraNode.position        = SCNVector3Make(0, 0, 0);
    cameraNode.rotation        = SCNVector4Make(0, 0, 0, 0);
    cameraNode.eulerAngles     = SCNVector3Make(0, 0, 0);
    cameraNode.camera.xFov     = 80;
    cameraNode.camera.yFov     = 80;
    cameraNode.camera.zNear    = 20;
    cameraNode.camera.zFar     = 4000;
    cameraNode.camera.aperture = 0.125;
    [self.scene.rootNode addChildNode:cameraNode];
    
    
    
    SCNNode *lightNode          = [SCNNode node];
    lightNode.light             = [SCNLight light];
    lightNode.position          = SCNVector3Make(0, 0, 0);
    lightNode.rotation          = SCNVector4Make(0, 0, 0, 0);
    lightNode.light.color       = [UIColor whiteColor];
    lightNode.light.shadowColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.5];
    [self.scene.rootNode addChildNode:lightNode];

    CGSize videoSize=CGSizeMake(1920, 960);
    
    
    
    
    SKVideoNode *videoSpriteKitNode=[[SKVideoNode alloc] initWithAVPlayer:player];
    videoNode=[SCNNode node];
    videoNode.geometry=[SCNSphere sphereWithRadius:1000];
    SKScene *spriteKitScene=[SKScene sceneWithSize:videoSize];
    spriteKitScene.scaleMode=SKSceneScaleModeAspectFit;
    videoSpriteKitNode.position=CGPointMake(videoSize.width/2, videoSize.height/2);
    videoSpriteKitNode.size =spriteKitScene.size;
    [spriteKitScene addChild:videoSpriteKitNode];
    videoNode.geometry.firstMaterial.diffuse.contents = spriteKitScene;
    videoNode.geometry.firstMaterial.doubleSided = true;
    SCNMatrix4 transform = SCNMatrix4MakeRotation(M_PI, 0.0, 0.0, 1.0);
    transform = SCNMatrix4Translate(transform, 1.0, 1.0, 0.0);
    videoNode.pivot = SCNMatrix4MakeRotation(M_PI_2, 0.0, -1.0, 0.0);
    videoNode.geometry.firstMaterial.diffuse.contentsTransform = transform;
    videoNode.position = SCNVector3Zero;
    videoNode.eulerAngles=SCNVector3Zero;
    [self.scene.rootNode addChildNode:videoNode];
    [videoSpriteKitNode play];
    
    


}
-(void)cleanUp
{
    videoNode.geometry.firstMaterial.diffuse.contents = nil;
    [videoNode removeFromParentNode];
    [cameraNode removeFromParentNode];

    [self.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        
        [child removeFromParentNode];
    }];
    
}
-(void)dealloc
{
    int p=0;
}


#pragma mark - Add Player




-(void)setCameraAltitude:(CMAttitude *)currentAttitude
{
    SCNQuaternion quaternion = [self orientationFromCMQuaternion:currentAttitude.quaternion];

    BOOL needToApply=true;
    
    float x=pValue.x-quaternion.x;
    float y=pValue.y-quaternion.y;
    float z=pValue.z-quaternion.z;
    float w=pValue.w-quaternion.w;
    
    float max=x*x+y*y+z*z+w*w;
    
    
    if(max<0.00001)
    {
        needToApply=false;
        NSLog(@"%f",max);

    }
    else{

    }
    
    if(needToApply==true)
    {
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.1f];
    cameraNode.orientation = quaternion;
    [SCNTransaction commit];
    
 
    pValue=quaternion;
    }
    
}
- (SCNQuaternion)orientationFromCMQuaternion:(CMQuaternion)q
{
    GLKQuaternion gq1 =  GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(-90), 1, 0, 0); // add a rotation of the pitch 90 degrees
    GLKQuaternion gq2 =  GLKQuaternionMake(q.x, q.y, q.z, q.w); // the current orientation
    GLKQuaternion qp  =  GLKQuaternionMultiply(gq1, gq2); // get the "new" orientation
    CMQuaternion rq =   {.x = qp.x, .y = qp.y, .z = qp.z, .w = qp.w};
    
    return SCNVector4Make(rq.x, rq.y, rq.z, rq.w);
}


@end
