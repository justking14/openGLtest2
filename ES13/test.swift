//
//  test.swift
//  ES13
//
//  Created by Justin Buergi on 2/25/16.
//  Copyright © 2016 Justking Games. All rights reserved.
//

import Foundation
/*
// MATRIX INVERSE FUNCTION. ADD THIS TO YOUR MATRIX LIBRARY
mat4.inverse = function(mat, dest) {
    if(!dest) { dest = mat; }
    
    // Cache the matrix values (makes for huge speed increases!)
    var a00 = mat[0], a01 = mat[1], a02 = mat[2], a03 = mat[3];
    var a10 = mat[4], a11 = mat[5], a12 = mat[6], a13 = mat[7];
    var a20 = mat[8], a21 = mat[9], a22 = mat[10], a23 = mat[11];
    var a30 = mat[12], a31 = mat[13], a32 = mat[14], a33 = mat[15];
    
    var b00 = a00*a11 - a01*a10;
    var b01 = a00*a12 - a02*a10;
    var b02 = a00*a13 - a03*a10;
    var b03 = a01*a12 - a02*a11;
    var b04 = a01*a13 - a03*a11;
    var b05 = a02*a13 - a03*a12;
    var b06 = a20*a31 - a21*a30;
    var b07 = a20*a32 - a22*a30;
    var b08 = a20*a33 - a23*a30;
    var b09 = a21*a32 - a22*a31;
    var b10 = a21*a33 - a23*a31;
    var b11 = a22*a33 - a23*a32;
    
    // Calculate the determinant (inlined to avoid double-caching)
    var invDet = 1/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06);
    
    dest[0] = (a11*b11 - a12*b10 + a13*b09)*invDet;
    dest[1] = (-a01*b11 + a02*b10 - a03*b09)*invDet;
    dest[2] = (a31*b05 - a32*b04 + a33*b03)*invDet;
    dest[3] = (-a21*b05 + a22*b04 - a23*b03)*invDet;
    dest[4] = (-a10*b11 + a12*b08 - a13*b07)*invDet;
    dest[5] = (a00*b11 - a02*b08 + a03*b07)*invDet;
    dest[6] = (-a30*b05 + a32*b02 - a33*b01)*invDet;
    dest[7] = (a20*b05 - a22*b02 + a23*b01)*invDet;
    dest[8] = (a10*b10 - a11*b08 + a13*b06)*invDet;
    dest[9] = (-a00*b10 + a01*b08 - a03*b06)*invDet;
    dest[10] = (a30*b04 - a31*b02 + a33*b00)*invDet;
    dest[11] = (-a20*b04 + a21*b02 - a23*b00)*invDet;
    dest[12] = (-a10*b09 + a11*b07 - a12*b06)*invDet;
    dest[13] = (a00*b09 - a01*b07 + a02*b06)*invDet;
    dest[14] = (-a30*b03 + a31*b01 - a32*b00)*invDet;
    dest[15] = (a20*b03 - a21*b01 + a22*b00)*invDet;
    
    return dest;
};

// INITIALIZE
// get canvas from webpage
var canvas = document.getElementById("glcanvas");

// set canvas to use webgl functions (as opposed to, say, 2D line drawing or something)
var gl;
try {
    gl = canvas.getContext("webgl");
    gl.viewportWidth = canvas.width;
    gl.viewportHeight = canvas.height;
    gl.clearColor(1.0, 1.0, 1.0, 1.0);
    gl.enable(gl.DEPTH_TEST);
}
catch (e) {
    alert("Could not initialise WebGL.");
}

// DEFINE OBJECT'S MATRIX, VERTEX BUFFER AND SHADER PROGRAM:
// cube's individual transform - this is what we'll rotate (in tick()) to spin the cube
obj = [];
obj.matrix = mat4.create();
mat4.identity(obj.matrix);

//  Smoothed cube mesh. 24 vertices, each vertex (in this case) is represented by 9 floats
var vertArray = [-1.000000, -0.899410, 0.899410, -1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, -1.000000, 0.899410, 0.000000, -1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, -0.899410, 1.000000, 0.000000, 0.000000, 1.000000, 0.451000, 0.545000, 0.635
    ,0.899410, -1.000000, 0.899410, 0.000000, -1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,1.000000, -0.899410, 0.899410, 1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, -0.899410, 1.000000, 0.000000, 0.000000, 1.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, 1.000000, 0.899410, 0.000000, 1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-1.000000, 0.899410, 0.899410, -1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, 0.899410, 1.000000, 0.000000, 0.000000, 1.000000, 0.451000, 0.545000, 0.635
    ,1.000000, 0.899410, 0.899410, 1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, 1.000000, 0.899410, 0.000000, 1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, 0.899410, 1.000000, 0.000000, 0.000000, 1.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, 0.899410, -1.000000, 0.000000, 0.000000, -1.000000, 0.451000, 0.545000, 0.635
    ,-1.000000, 0.899410, -0.899410, -1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, 1.000000, -0.899410, 0.000000, 1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,1.000000, 0.899410, -0.899410, 1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, 0.899410, -1.000000, 0.000000, 0.000000, -1.000000, 0.451000, 0.545000, 0.635
    ,0.899410, 1.000000, -0.899410, 0.000000, 1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, -1.000000, -0.899410, 0.000000, -1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-1.000000, -0.899410, -0.899410, -1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,-0.899410, -0.899410, -1.000000, 0.000000, 0.000000, -1.000000, 0.451000, 0.545000, 0.635
    ,1.000000, -0.899410, -0.899410, 1.000000, 0.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, -1.000000, -0.899410, 0.000000, -1.000000, 0.000000, 0.451000, 0.545000, 0.635
    ,0.899410, -0.899410, -1.000000, 0.000000, 0.000000, -1.000000, 0.451000, 0.545000, 0.635
];

// allocate a block of GPU memory to hold the vertex array
obj.vertexBuffer = gl.createBuffer();
// make it active
gl.bindBuffer(gl.ARRAY_BUFFER, obj.vertexBuffer);
// send the data
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertArray), gl.STATIC_DRAW);

// the triangles that make up the smoothed cube, as indices to vertArray. Notice the values range from 0 to 23
var indices = [18,22,1,1,22,3,5,11,2,2,11,8,7,13,0,0,13,19,21,15,4,4,15,9,10,17,6,6, 			17,14,16,23,12,12,23,20,1,0,18,18,0,19,2,1,5,5,1,3,0,2,7,7,2,8,4,3,21,21, 			3,22,5,4,11,11,4,9,7,6,13,13,6,14,6,8,10,10,8,11,10,9,17,17,9,15,13,12,19, 			19,12,20,12,14,16,16,14,17,16,15,23,23,15,21,18,20,22,22,20,23,0,1,2,3,4,5,
    6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

// GL expects ints to be ints (go figure!) and Javascript only has one number type, so...
indices = new Uint16Array(indices);
// allocate a block of GPU memory to hold the index array
obj.indexBuffer = gl.createBuffer();
// make it active
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, obj.indexBuffer);
// send the data
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
// we'll need the number of indices for the draw call later
obj.indexBuffer.numItems = indices.length;


// BUILD VERTEX AND FRAGMENT SHADERS, LINK TOGETHER INTO A SHADER PROGRAM:

// create a vertex shader
var vertShader = gl.createShader(gl.VERTEX_SHADER);
// you'll almost always specify this in a separate text file
var vertShaderStr = "\
attribute vec3 aVertexPosition;\
attribute vec3 aVertexNormal;\
attribute vec3 aVertexColor;\
uniform mat4 uPMatrix; /* perspectiveView matrix */\
uniform mat4 uVMatrix; /* view matrix */\
uniform mat4 uOMatrix; /* object matrix */\
varying vec3 vNormal;\
varying vec3 vPos;\
varying vec3 vColor;\
void main(void) {\
    gl_Position = uPMatrix * uVMatrix * uOMatrix * vec4(aVertexPosition, 1.0);\
    vNormal = aVertexNormal;\
    vPos = aVertexPosition;\
    vColor = aVertexColor;\
}"

// specify the previous string as being the source code for the vertex shader
gl.shaderSource(vertShader, vertShaderStr);
gl.compileShader(vertShader);
if (! gl.getShaderParameter(vertShader, gl.COMPILE_STATUS))
alert(gl.getShaderInfoLog(vertShader));

//create a fragment shader
var fragShader = gl.createShader(gl.FRAGMENT_SHADER);
// inline shader programming is gross and only used here for instructional purposes
var fragShaderStr = "precision mediump float;\
varying vec3 vColor;\
void main(void) {\
    gl_FragColor = vec4(vColor,1.);\
}"
gl.shaderSource(fragShader, fragShaderStr);
gl.compileShader(fragShader);
if (! gl.getShaderParameter(fragShader, gl.COMPILE_STATUS))
alert(gl.getShaderInfoLog(fragShader));

// create an empty shader program
obj.shaderProgram = gl.createProgram();
// attach and link our compiled shaders into one program
gl.attachShader(obj.shaderProgram, vertShader);
gl.attachShader(obj.shaderProgram, fragShader);
gl.linkProgram(obj.shaderProgram);

if (! gl.getProgramParameter(obj.shaderProgram, gl.LINK_STATUS))
alert("Could not initialise shaders");

// find, store, and enable the attribute variables of the shader program (position, normal vector, color)
obj.shaderProgram.vertexPositionAttribute =
gl.getAttribLocation(obj.shaderProgram, "aVertexPosition");
gl.enableVertexAttribArray(obj.shaderProgram.vertexPositionAttribute);

obj.shaderProgram.vertexNormalAttribute =
gl.getAttribLocation(obj.shaderProgram, "aVertexNormal");
gl.enableVertexAttribArray(obj.shaderProgram.vertexNormalAttribute);

obj.shaderProgram.vertexColorAttribute =
gl.getAttribLocation(obj.shaderProgram, "aVertexColor");
gl.enableVertexAttribArray(obj.shaderProgram.vertexColorAttribute);

//find and store the uniform variables of the shader program
obj.shaderProgram.pMatrixUniform=gl.getUniformLocation(obj.shaderProgram, "uPMatrix");
obj.shaderProgram.vMatrixUniform=gl.getUniformLocation(obj.shaderProgram, "uVMatrix");
obj.shaderProgram.oMatrixUniform=gl.getUniformLocation(obj.shaderProgram, "uOMatrix");

// END SETUP

// Draw function for a single object
function drawObject(gl, obj) {
    gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	   
    // set the active shader to the object's material
    gl.useProgram(obj.shaderProgram);
    // set our object's array of verts to be active
    gl.bindBuffer(gl.ARRAY_BUFFER, obj.vertexBuffer);
    // set our object's array of indices to be active
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, obj.indexBuffer);
    
    // Explain how the vertex array is structured for the "attribute" variables in the shader
    gl.vertexAttribPointer( obj.shaderProgram.vertexPositionAttribute, //location of attribute in shader, stored on setup
        3, //number of elements (x, y ,z for position)
        gl.FLOAT, //data type of each component in the array
        false, //fixed-point data values should be normalized (true) or converted directly as fixed-point values (false)
        9 * Float32Array.BYTES_PER_ELEMENT, //stride (9 floats total in our vertex)
        0 //offset for position (position is the first three floats of the nine, so no offset)
    );
    gl.vertexAttribPointer( obj.shaderProgram.vertexNormalAttribute,
        3, //number of normal vector elements (x, y, z)
        gl.FLOAT,
        false,
        9 * Float32Array.BYTES_PER_ELEMENT, //stride
        3 * Float32Array.BYTES_PER_ELEMENT //offset for normal (second three floats of the nine, so offset of 3 floats)
    );
    gl.vertexAttribPointer( obj.shaderProgram.vertexColorAttribute,
        3, //number of color elements (r, g, b)
        gl.FLOAT,
        false,
        9 * Float32Array.BYTES_PER_ELEMENT, //stride
        6 * Float32Array.BYTES_PER_ELEMENT //offset for color (third three floats of the nine, so offset of 6 floats)
    );
    
    // Set the uniform variables for the shader program. Stuff that's the same for all verts in this mesh (like textures, time, etc.)
    // in this case, it's the cube's transform, the view matrix, and the perspective matrix
    var view = mat4.create();
    mat4.identity(view);
    var cam = mat4.create();
    mat4.identity(cam);
    // move the camera 5 units back. Probably should be doing this in update :-/
    mat4.translate(cam, vec3.create([0,0,5]));
    
    //REMEMBER: View matrix isn't the camera transform! It's the *inverse* of the camera transform.
    mat4.inverse(cam, view); //inverts cam, stores in view
    
    // projection matrix for a perspective camera
    // I'm doing the math for you right now
    var proj = [2.4142136573791504, 0, 0, 0, 0, 2.4142136573791504, 0, 0, 0, 0, -1.0202020406723022, -1, 0, 0, -0.20202019810676575, 0];
    
    //send up the current uniform variables to their stored locations
    gl.uniformMatrix4fv(obj.shaderProgram.pMatrixUniform, false, proj);
    gl.uniformMatrix4fv(obj.shaderProgram.vMatrixUniform, false, view);
    gl.uniformMatrix4fv(obj.shaderProgram.oMatrixUniform, false, obj.matrix);
    
    //finally, the actual draw call
    gl.drawElements(gl.TRIANGLES, obj.indexBuffer.numItems, gl.UNSIGNED_SHORT, 0);
}

// MASTER LOOP
var tick = function() {
		  
   	//UPDATE SCENE
   	mat4.rotateX(obj.matrix, 1/60);
   	mat4.rotateY(obj.matrix, 1/60);
    
   	//DRAW SCENE
   	drawObject(gl, obj);
    
   	// call this function again in ~1/60th of a second
   	requestAnimationFrame(tick);
};

// let's get started!
tick();

*/