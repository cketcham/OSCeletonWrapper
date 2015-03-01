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
 * @version     1.0.1 (1)
 */

package skyra.osceleton;

import oscP5.OscMessage;
import oscP5.OscP5;
import oscP5.OscEventListener;
import oscP5.OscStatus;
import processing.core.PApplet;

import java.util.ArrayList;

/**
 * The base class for reading skeletons from OSCeleton into Processing.
 * 
 * @author cketcham
 */
public class OSCeletonWrapper implements OscEventListener {

    private final PApplet myParent;
    private final OscP5 oscP5;
    private final ArrayList<Skeleton> mSkeletons = new ArrayList<Skeleton>(4);

    /**
     * Create a new {@link OSCeletonWrapper} object to get skeletons
     * @param theParent
     * @param port  the port OSCeleton is using
     */
    public OSCeletonWrapper(PApplet theParent, int port) {
        myParent = theParent;

        oscP5 = new OscP5(theParent, port);
        oscP5.addListener(this);
        for (int i = 0; i < 4; i++) {
            mSkeletons.add(new Skeleton(myParent, i));
        }
    }

    /**
     * @return a list of all the skeletons
     */
    public ArrayList<Skeleton> getSkeletons() {
        return mSkeletons;
    }

    /**
     * Finds the closest skeleton to the sensor. This implementation just looks
     * at the Z-coordinate of the heads of all the people it can see.
     * 
     * @return the closest skeleton
     */
    public Skeleton getClosest() {
        Float z = null;
        Skeleton closest = null;
        for (Skeleton sk : mSkeletons) {
            if (sk.isVisible() && sk.get("head").z != 0 && (z == null || z > sk.get("head").z)) {
                closest = sk;
                z = sk.get("head").z;
            }
        }
        return closest;
    }

    /**
     * Get skeleton by user id
     * 
     * @param user
     * @return The skeleton with that user id
     */
    public Skeleton getSkeleton(int user) {
        for (Skeleton sk : mSkeletons) {
            if (sk.user == user)
                return sk;
        }
        return null;
    }

    private Skeleton ensureSkeleton(int user) {
        Skeleton sk = getSkeleton(user);
        if (sk == null) {
            sk = new Skeleton(myParent, user);
            mSkeletons.add(sk);
        }
        sk.visible = true;
        return sk;
    }

    private void removeSkeleton(int user) {
        Skeleton sk = getSkeleton(user);
        sk.visible = false;
    }

    /* incoming osc message. */
    @Override
    public void oscEvent(OscMessage theOscMessage) {
        // System.out.print("### received an osc message."+theOscMessage);
        // System.out.print(" addrpattern: "+theOscMessage.addrPattern());
        // System.out.println(" typetag: "+theOscMessage.typetag());

        String addr = theOscMessage.addrPattern();

        if ("/joint".equals(addr)) {
            String joint = theOscMessage.get(0).stringValue();

            int user = theOscMessage.get(1).intValue();
            Skeleton sk = ensureSkeleton(user);

            sk.get(joint).updateLocation(theOscMessage);
        } else if ("/new_user".equals(addr) || "/reenter_user".equals(addr)) {
            int user = theOscMessage.get(0).intValue();
            ensureSkeleton(user);
        } else if ("/lost_user".equals(addr) || "/exit_user".equals(addr)) {
            int user = theOscMessage.get(0).intValue();
            removeSkeleton(user);
        }
    }

    @Override
    public void oscStatus(OscStatus status) {

    }
}
