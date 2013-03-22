var jspSourceTarget = {
  dropOptions: {
    hoverClass:"dragHover"
  },
  anchor: "Continuous"
};

var jspDefaults = {
  Connector: ["Bezier", {curviness: 50}],
  DragOptions: {cursor: "pointer", zIndex: 2000},
  PaintStyle: {strokeStyle: "gray", lineWidth: 2},
  Endpoint: ["Dot",{radius: 1}],
  EndpointStyle: {radius: 1, fillStyle: "gray"},
  HoverPaintStyle: {strokeStyle: "#ec9f2e"},
  EndpointHoverStyle: {fillStyle: "#ec9f2e"},
  Anchors: ["BottomCenter", "TopCenter"]
};

var jspReferenceConnection = {
  overlays: ["Arrow", [
    "Label", 
    {label: "?", location: 0.25, id: "myLabel"} 
  ]]
};

function jsPlumbPrepareWindow(obj) {
  jsPlumb.draggable(obj);
  jsPlumb.makeTarget(obj, jspSourceTarget);
  jsPlumb.makeSource(obj, jspSourceTarget);
}

;(function() {
	window.plumbGraph = {
	
  	init: function() {
      jsPlumb.importDefaults(jspDefaults);
		}
	
  };
})();

jsPlumb.bind("ready", function() {
  // chrome fix (from demo page)
  document.onselectstart = function() {
    return false;
  };
  
  jsPlumb.setRenderMode(jsPlumb.SVG);
  plumbGraph.init();
});

