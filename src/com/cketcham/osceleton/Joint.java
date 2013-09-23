/**
 * OSCeletonWrapper
 * Builds a skeleton object from OSC messages from OSCeleton.
 * http://skyra.github.io
 *
 * Copyright (c) 2013 Cameron Ketcham http://skyra.github.io
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author      Cameron Ketcham http://skyra.github.io
 * @modified    09/23/2013
 * @version     1.0.0 (1)
 */

package com.cketcham.osceleton;

import oscP5.OscMessage;
import processing.core.PApplet;

/**
 * This class holds the x, y, and z coordinates of a joint.
 * It has a helper method to parse a Joint OscMessage into a Joint object.
 * 
 * <p>
 * Normally, the {@link OSCeletonWrapper} object will create skeletons and joints for you.
 * </p>
 */
public class Joint {

    // myParent is a reference to the parent sketch
    PApplet myParent;

    public float x = 0, y = 0, z = 0;

    public Joint(PApplet theParent) {
        myParent = theParent;
    }

    public Joint(PApplet theParent, float x_, float y_, float z_) {
        x = x_;
        y = y_;
        z = z_;
    }

    public Joint(OscMessage theOscMessage) {
        x = theOscMessage.get(2).floatValue() * myParent.width;
        y = theOscMessage.get(3).floatValue() * myParent.height;
        z = theOscMessage.get(4).floatValue();
    }
}
