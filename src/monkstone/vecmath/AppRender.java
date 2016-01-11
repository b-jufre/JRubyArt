package monkstone.vecmath;

import processing.core.PApplet;

/**
 *
 * @author Martin Prout
 */
public class AppRender implements JRender {

    final PApplet app;

    /**
     *
     * @param app
     */
    public AppRender(final PApplet app) {
        this.app = app;
    }

    /**
     *
     * @param x
     * @param y
     */
    @Override
    public void vertex(double x, double y) {
        app.vertex((float) x, (float) y);
    }
    
    /**
     *
     * @param x
     * @param y
     */
    @Override
    public void curveVertex(double x, double y) {
        app.curveVertex((float) x, (float) y);
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void vertex(double x, double y, double z) {
        app.vertex((float) x, (float) y, (float) z);
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void normal(double x, double y, double z) {
        app.normal((float) x, (float) y, (float) z);
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param u
     * @param v
     */
    @Override
    public void vertex(double x, double y, double z, double u, double v) {
        app.vertex((float) x, (float) y, (float) z, (float) u, (float) v);
    }
    
    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void curveVertex(double x, double y, double z) {
        app.curveVertex((float) x, (float) y, (float) z);
    }

}
