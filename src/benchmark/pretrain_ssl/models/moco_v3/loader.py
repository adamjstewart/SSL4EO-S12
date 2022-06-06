# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.

# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

from PIL import Image, ImageFilter, ImageOps
import math
import random
import torchvision.transforms.functional as tf

import cv2

class TwoCropsTransform:
    """Take two random crops of one image"""

    def __init__(self, base_transform1, base_transform2):
        self.base_transform1 = base_transform1
        self.base_transform2 = base_transform2

    def __call__(self, x):
        im1 = self.base_transform1(x)
        im2 = self.base_transform2(x)
        return [im1, im2]


class GaussianBlur(object):
    """Gaussian blur augmentation from SimCLR: https://arxiv.org/abs/2002.05709"""

    def __init__(self, sigma=[.1, 2.]):
        self.sigma = sigma

    def __call__(self, x):
        sigma = random.uniform(self.sigma[0], self.sigma[1])
        #x = x.filter(ImageFilter.GaussianBlur(radius=sigma))
        #return x
        return cv2.GaussianBlur(x,(0,0),sigma)


class Solarize(object):
    """Solarize augmentation from BYOL: https://arxiv.org/abs/2006.07733"""

    def __call__(self, x):
        return ImageOps.solarize(x)
        
        
        
        
        
class cvGaussianBlur(object):
    """Gaussian blur augmentation in SimCLR https://arxiv.org/abs/2002.05709"""

    def __init__(self, p=0.5, sigma=[.1, 2.]):
        self.sigma = sigma
        self.prob = p

    def __call__(self, x):
        do_it = random.random() <= self.prob
        if not do_it:
            return x        
    
        sigma = random.uniform(self.sigma[0], self.sigma[1])
        #x = x.filter(ImageFilter.GaussianBlur(radius=sigma))
        #return x
        return cv2.GaussianBlur(x,(0,0),sigma)