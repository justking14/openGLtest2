//
//  Shader.vsh
//  ES13
//
//  Created by Justin Buergi on 2/24/16.
//  Copyright © 2016 Justking Games. All rights reserved.
//




attribute vec4 position;
attribute vec3 normal;
varying lowp vec4 colorVarying;

uniform mat4 uPMatrix; /* perspectiveView matrix */\
uniform mat4 uVMatrix; /* view matrix */\
uniform mat4 uOMatrix; /* object matrix */\

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = colorVarying;
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    colorVarying = colorVarying;
    //colorVarying = diffuseColor * nDotVP;
    gl_Position = modelViewProjectionMatrix * position;
}

/*attribute vec3 aVertexPosition;
attribute vec3 aVertexNormal;
attribute vec3 aVertexColor;

varying vec3 vNormal;
varying vec3 vPos;
varying vec3 vColor;
void main(void) {
    gl_Position = uPMatrix * uVMatrix * uOMatrix * vec4(aVertexPosition, 1.0);\
    vNormal = aVertexNormal;
    vPos = aVertexPosition;
    vColor = aVertexColor;
}*/