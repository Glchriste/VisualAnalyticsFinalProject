var Zoom = {
    current: 1, // current zoom level


    dozoom: function (id, zoom) {
        if (zoom == 1) Zoom.current = 1;
        else Zoom.current += zoom;

        svg = document.getElementById(id);
        svg.setAttribute("transform", "scale(" + Zoom.current + " " + Zoom.current +")");
        // without rounding, it shows 0.7999999999999 etc.
        document.getElementById('currentZoom').innerHTML = Math.round(Zoom.current * 10) / 10;
    }
};


// heavily inspired by http://www.cyberz.org/projects/SVGPan/SVGPan.js
var Pan = {
    state: null,        // state of panning: null, 'pan', 'drag'
    svg: null,          // svg root
    canvas: null,       // canvas (g) element which is the actual graphic
    stateTarget: null,  // state of target
    stateOrigin: null,  // state of origin
    stateTf: null,      // state of transformation


    setup: function(id) {
        Pan.svg = document.getElementsByTagName('svg')[0];

        var g = null;
        g = document.getElementById(Pan.canvasID);
        if (g == null) g = Pan.svg.getElementsByTagName('g')[0];
        if (g == null) alert('Unable to obtain SVG root element');
        Pan.setCTM(g, g.getCTM());
        g.removeAttribute('viewBox');
        Pan.canvas = g;

        Pan.setAttributes(Pan.svg, {
            "onmouseup" : "Pan.handleMouseUp(evt)",
            "onmousedown" : "Pan.handleMouseDown(evt)",
            "onmousemove" : "Pan.handleMouseMove(evt)",
            //"onmouseout" : "Pan.handleMouseUp(evt)", // Decomment this to stop the pan functionality when dragging out of the SVG element
        });

    },


    /**
     * Instance an SVGPoint object with given event coordinates.
     */
    getEventPoint: function(evt) {
        var p = Pan.svg.createSVGPoint();

        p.x = evt.clientX;
        p.y = evt.clientY;

        return p;
    },


    /**
     * Sets the current transform matrix of an element.
     */
    setCTM: function(element, matrix) {
        var s = "matrix(" + matrix.a + "," + matrix.b + "," + matrix.c + "," + matrix.d + "," + matrix.e + "," + matrix.f + ")";
        element.setAttribute("transform", s);
    },


    /**
     * Sets attributes of an element.
     */
    setAttributes: function(element, attributes) {
        for (var i in attributes)
            element.setAttributeNS(null, i, attributes[i]);
    },



    /**
     * Handle mouse move event.
     */
    handleMouseMove: function(evt) {
        if (evt.preventDefault) evt.preventDefault();
        evt.returnValue = false;

        if (Pan.state == 'pan') {
            var p = Pan.getEventPoint(evt).matrixTransform(Pan.stateTf);
            Pan.setCTM(Pan.canvas, Pan.stateTf.inverse().translate(
                p.x - Pan.stateOrigin.x, p.y - Pan.stateOrigin.y));
        } else if (Pan.state == 'drag') {
            var p = Pan.getEventPoint(evt).matrixTransform(Pan.canvas.getCTM().inverse());
            Pan.setCTM(Pan.stateTarget, Pan.svg.createSVGMatrix().translate(
                p.x - Pan.stateOrigin.x, p.y - Pan.stateOrigin.y).multiply(
                    Pan.canvas.getCTM().inverse()).multiply(Pan.stateTarget.getCTM()));
            Pan.stateOrigin = p;
        } else {
            if (evt.target.tagName != 'svg') {
                Pan.svg.style.cursor = 'default';
            } else {
                Pan.svg.style.cursor = 'pointer';
            }
        }
    },


    /**
     * Handle click event.
     */
    handleMouseDown: function(evt) {
        if (evt.preventDefault) evt.preventDefault();
        evt.returnValue = false;

        var tagName = evt.target.tagName;
        switch (tagName) {
            case 'svg':
                Pan.state = 'pan';
                Pan.stateTf = Pan.canvas.getCTM().inverse();
                Pan.stateOrigin = Pan.getEventPoint(evt).matrixTransform(Pan.stateTf);
                Pan.svg.style.cursor = 'move';
                break;

            case 'text':
            case 'rect':
            case 'line':
                Pan.svg.style.cursor = 'default';
                break;

            default:
                Pan.state = 'drag';
                Pan.stateTarget = evt.target;
                Pan.stateTf = Pan.canvas.getCTM().inverse();
                Pan.stateOrigin = Pan.getEventPoint(evt).matrixTransform(Pan.stateTf);
                Pan.svg.style.cursor = 'move';
        }
    },


    /**
     * Handle mouse button release event.
     */
    handleMouseUp: function(evt) {
        if (evt.preventDefault) evt.preventDefault();
        evt.returnValue = false;

        if (Pan.state == 'pan' || Pan.state == 'drag') {
            Pan.state = null;
            Pan.svg.style.cursor = 'pointer';
        }
    }
};
