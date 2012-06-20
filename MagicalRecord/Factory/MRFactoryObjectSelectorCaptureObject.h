//
//  MRFactoryObjectSelectorCaptureObject.h
//  MagicalRecord
//
//  Created by Saul Mora on 6/19/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRFactoryObject;

@interface MRFactoryObjectSelectorCaptureObject : NSObject

@property (nonatomic, weak) MRFactoryObject *factory;
@property (nonatomic, assign) SEL capturedSelector;

+ (id) capturerWithFactory:(MRFactoryObject *)factory;

@end
