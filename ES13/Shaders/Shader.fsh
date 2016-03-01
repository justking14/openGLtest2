//
//  Shader.fsh
//  ES13
//
//  Created by Justin Buergi on 2/24/16.
//  Copyright © 2016 Justking Games. All rights reserved.
//

//precision mediump float;
//varying vec3 colorRRR;
varying lowp vec4 colorVarying;

void main()
{
    //gl_FragColor = vec4(colorRRR, 1.0);
    //gl_FragColor = colorVarying;
    gl_FragColor = vec4(0.451000, 0.545000, 0.635,1.);
}

//varying lowp vec2 TexCoordOut; // New
//uniform sampler2D Texture; // New

//void main(void) {
  //  gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
//}