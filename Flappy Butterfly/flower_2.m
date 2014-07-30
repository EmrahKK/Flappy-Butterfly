//
//  flower_2.m
//  Flappy Butterfly
//
//  Created by Emrah Küçükkaya on 28/07/14.
//  Copyright (c) 2014 Emrah Küçükkaya. All rights reserved.
//

#import "flower_2.h"

@implementation flower_2

- (instancetype)initWithGround:(SKNode*)ground atPoint:(CGPoint)point inScene:(SKScene*)scene inNode:(SKNode*)node {
    if (self = [super init]) {
        self = [flower_2 spriteNodeWithImageNamed:@"fl13"];
        
        // create physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 75 - offsetX, 320 - offsetY);
        CGPathAddLineToPoint(path, NULL, 110 - offsetX, 320 - offsetY);
        CGPathAddLineToPoint(path, NULL, 110 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 75 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.mass = 2.0f;
        
        [node addChild:self];
        
        float m_DampingRatio = 5.0f;
        float m_Stiffness = 1.5f;
        
        self.position = CGPointMake(point.x, point.y + self.frame.size.height/2);
        
        CGFloat px = point.x - 5;
        
        // create a joint between two bodies
        
        SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:self.physicsBody
                                                               bodyB:ground.physicsBody
                                                              anchor:CGPointMake(px, self.position.y - self.frame.size.height/2)];
        
        SKPhysicsJointSpring *springJointLeft = [SKPhysicsJointSpring jointWithBodyA:self.physicsBody
                                                                               bodyB:ground.physicsBody
                                                                             anchorA:CGPointMake(px, ground.position.y + 100)
                                                                             anchorB:CGPointMake(px - 100, ground.position.y)];
        
        SKPhysicsJointSpring *springJointRight = [SKPhysicsJointSpring jointWithBodyA:self.physicsBody
                                                                                bodyB:ground.physicsBody
                                                                              anchorA:CGPointMake(px, ground.position.y + 100)
                                                                              anchorB:CGPointMake(px + 100, ground.position.y)];
        springJointLeft.damping = m_DampingRatio;
        springJointLeft.frequency = m_Stiffness;
        
        springJointRight.damping = m_DampingRatio;
        springJointRight.frequency = m_Stiffness;
        
        [scene.physicsWorld addJoint:joint];
        [scene.physicsWorld addJoint:springJointLeft];
        [scene.physicsWorld addJoint:springJointRight];
    }
    return self;
}


@end
