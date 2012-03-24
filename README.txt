Generative art project simulating an electic discharge into a glass black.

TODO:


Efficiency:

Add a connection count to particles. Particles with 4 connections are no longer collision-detected; a particle will hit one of its neighbors anyway.

Add a cleanup cycle, every second, or every 5 sec.
	Recenter the tree’s midpoint to the center of the particles’ bounding box, recalculate the bounding circle.
	Have two arrays. One holds all attached particles. The other holds all attached particles with less than 4 connections.
	Each time collisions are checked, save the lowest distance and position at that point. Then, don’t process collisions until the particle has travelled that distance minus a little from the saved point. This might need to be skipped if the lowest distance < 3 or 5.

Stop drawing the walker and clearing it 1/sec – just have a separate sprite with one dot that moves to match the walker’s position. Flash will display it just fine.


Awesomeness:

Use the particles’ position in the particles array to determine their color. Get an array of colors from a line drawn on a source image.

Add auto-zoom-out. Whenever the launch radius is close to any of the four sides, recenter the tree, change the zoom factor, and redraw all.

Calculate lines leading back to the seed. Each particle has a parent (seeds have parent = null). Count up all the particles that “pass through” each particle by running through all of its descendants (children, their children, etc). Then draw lines whose width is based on the number of descendants between a particle and its parent. This should result in something close to a Lichtenburg figure. Save the results as SVG.


Usefulness:

Make method to export and save the dots as an SVG file. Mostly this will be adding an eventlistener and prompting to save the file – most everything else is already in place.