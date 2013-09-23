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

import processing.core.PApplet;

import java.util.HashMap;

/**
 * A skeleton object which represents a user that is standing in front of the Kinect.
 * @author cketcham
 *
 */
public class Skeleton {

    // myParent is a reference to the parent sketch
    PApplet myParent;

    HashMap<String, Joint> mJoints = new HashMap<String, Joint>();

    int user;

    boolean visible = false;

    /**
     * Create a new skelton object with the given user_id. Normally,
     * the {@link OSCeletonWrapper} object will create a list of skeletons for you.
     * @param theParent
     * @param user
     */
    public Skeleton(PApplet theParent, int user) {
        myParent = theParent;
        this.user = user;
    }

    /**
     * Update the location of a Joint. Normally, the {@link OSCeletonWrapper} object will
     * handle this for you.
     * 
     * <p>
     * Name can be one of:
     * head, neck, torso, waist, l_collar, l_shoulder,
     * l_elbow, l_wrist, l_hand, l_fingertip, r_collar, r_shoulder,
     * r_elbow, r_wrist, r_hand, r_fingertip, l_hip, l_knee,
     * l_ankle, l_foot, r_hip, r_knee, r_ankle, r_foot;
     * </p>
     * 
     * @param name
     * @param joint
     */
    public void updateJoint(String name, Joint joint) {
        mJoints.put(name, joint);
    }

    /**
     * Get a specific joint
     * 
     * <p>
     * Name can be one of:
     * head, neck, torso, waist, l_collar, l_shoulder,
     * l_elbow, l_wrist, l_hand, l_fingertip, r_collar, r_shoulder,
     * r_elbow, r_wrist, r_hand, r_fingertip, l_hip, l_knee,
     * l_ankle, l_foot, r_hip, r_knee, r_ankle, r_foot;
     * </p>
     * 
     * @param name
     * @return the specific joint for this skeleton
     */
    public Joint get(String name) {
        Joint j = mJoints.get(name);
        return (j == null) ? new Joint(myParent) : j;
    }
    
    /**
     * @return the user id for this skeleton
     */
    public int getUser() {
        return user;
    }

    /**
     * To avoid concurrency problems all skeletons are built when the application
     * is started.
     * @return true if the skeleton is visible to the kinect.
     */
    public boolean isVisible() {
        return visible;
    }
    
    /**
     * @return the names of all the joints available.
     */
    public HashMap<String, Joint> getJointSet() {
        return mJoints;
    }
}
