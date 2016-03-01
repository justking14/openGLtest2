//
//  GameViewController.swift
//  ES13
//
//  Created by Justin Buergi on 2/24/16.
//  Copyright © 2016 Justking Games. All rights reserved.
//

import GLKit
import OpenGLES

func BUFFER_OFFSET(i: Int) -> UnsafePointer<Void> {
    let p: UnsafePointer<Void> = nil
    return p.advancedBy(i)
}

let UNIFORM_MODELVIEWPROJECTION_MATRIX = 0
let UNIFORM_NORMAL_MATRIX = 1
let UNIFORM_Perspective_MATRIX = 2
let UNIFORM_view_MATRIX = 3
let UNIFORM_object_MATRIX = 4


let UNIFORM_color_MATRIX = 5

var uniforms = [GLint](count: 6, repeatedValue: 0)

class gameObject{
    var vertexArray: GLuint = 0
    var vertexBuffer: GLuint = 0
    var indexBuffer: GLuint = 0
    var indices: [GLuint] = [];
    var gCubeVertexData: [GLfloat] = [];
    var gCubeNormalData: [GLfloat] = [];
    
    func getData(named: NSString){
        let truePath = NSBundle.mainBundle().pathForResource(named as String, ofType: "json")!
        let jsonData: NSData = NSData(contentsOfFile: truePath)!
        do{
            let jsonDict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as! NSDictionary
            for (key, _) in jsonDict {
                print(key)
            }
            gCubeVertexData = jsonDict.valueForKey("vertices") as! [GLfloat]
            gCubeNormalData = jsonDict.valueForKey("normals") as! [GLfloat]
            let test1: [UInt] = jsonDict.valueForKey("faces") as! [UInt]
            let test2: [UInt32] = test1.map{UInt32($0)}
            indices = test2 as [GLuint]
            print(gCubeVertexData.count)
            print(indices.count)
            var toThree: Int = 1
            var realCountUp: Int = 0
            var normalCountUp: Int = 0
            var RgCubeVertexData: [GLfloat] = [GLfloat](count: gCubeVertexData.count * 3, repeatedValue: GLfloat(0.0))
            
            for(var countUp = 0; countUp < gCubeVertexData.count - 1; countUp++){
                print("a")
                if(toThree == 1 || toThree == 2 || toThree == 3){
                    RgCubeVertexData[realCountUp] = gCubeVertexData[countUp]
                    if(toThree == 3){
                        toThree = 0
                        realCountUp++
                        normalCountUp++
                        RgCubeVertexData[realCountUp] = gCubeNormalData[normalCountUp]
                        realCountUp++
                        normalCountUp++
                        RgCubeVertexData[realCountUp] = gCubeNormalData[normalCountUp]
                        realCountUp++
                        normalCountUp++
                        RgCubeVertexData[realCountUp] = gCubeNormalData[normalCountUp]
                        
                        if(named == "top"){
                        realCountUp++
                        RgCubeVertexData[realCountUp] = 0.451000
                        realCountUp++
                        RgCubeVertexData[realCountUp] = 0.545000
                        realCountUp++
                        RgCubeVertexData[realCountUp] = 0.635
                        }else{
                            realCountUp++
                            RgCubeVertexData[realCountUp] = 0.951000
                            realCountUp++
                            RgCubeVertexData[realCountUp] = 0.245000
                            realCountUp++
                            RgCubeVertexData[realCountUp] = 0.635
                        }
                    }
                }
                toThree++
                realCountUp++
            }
            
            
            
            toThree = 1
            realCountUp = 0
            normalCountUp = 0
            var Rindecies: [GLuint] = [GLuint](count: indices.count * 3/11, repeatedValue: GLuint(0.0))
            
            for(var countUp = 0; countUp < Rindecies.count - 1; countUp++){
                print("a")
                if(toThree == 1){
                }else if(toThree == 2 || toThree == 3 || toThree == 4){
                    Rindecies[countUp] = indices[realCountUp] as GLuint
                    if(toThree == 4){
                        toThree = 0
                        realCountUp+=7
                        normalCountUp+=7
                    }
                }
                toThree++
                realCountUp++
            }
            
            //Rindecies
            indices = Rindecies
            print(indices)
            gCubeVertexData = RgCubeVertexData
        }catch _{
            
        }
    }
    
    
    func loadBuffers(){
        glGenVertexArraysOES(1, &vertexArray);
        glBindVertexArrayOES(vertexArray);
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(sizeof(GLfloat) * gCubeVertexData.count), &gCubeVertexData, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(sizeof(GLuint) * indices.count), &indices, GLenum(GL_STATIC_DRAW))
        
        
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Normal.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Color.rawValue))
        
        
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(GLfloat)) * 9, BUFFER_OFFSET(0)   )
        
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(GLfloat)) * 9, BUFFER_OFFSET(12)   )
        
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Color.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(GLfloat)) * 9, BUFFER_OFFSET(24)   )
        
        
        //glBindVertexArrayOES(0)
    }
    
    func render(){
        //print(indices)
       // print(gCubeVertexData)
        glBindVertexArrayOES(vertexArray);
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
}

class GameViewController: GLKViewController {
    var modelViewProjectionMatrix:GLKMatrix4 = GLKMatrix4Identity
    var modelcolornMatrix:GLKMatrix3 = GLKMatrix3Identity
    var program: GLuint = 0
    
    var perspectiveMatrix:GLKMatrix4 = GLKMatrix4Identity
    var viewMatrix:GLKMatrix4 = GLKMatrix4Identity
    var objectMatrix:GLKMatrix4 = GLKMatrix4Identity
    
    
    var normalMatrix: GLKMatrix3 = GLKMatrix3Identity
    var rotation: Float = 0.0
    var context: EAGLContext? = nil
    var effect: GLKBaseEffect? = nil
    
    deinit {
        self.tearDownGL()
        
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    var TOP: gameObject = gameObject()
    var BOTTOM: gameObject = gameObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        //set context then
        self.context = EAGLContext(API: .OpenGLES2)
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        let view = self.view as! GLKView
        
        view.context = self.context!
        view.drawableDepthFormat = .FormatNone
        
        TOP.getData("bottom")
        BOTTOM.getData("top")
        self.setupGL()
    }
    
    
    
    
    func setupGL() {
        print("set up")
        EAGLContext.setCurrentContext(self.context)
        
        self.loadShaders()

        //glEnable(GLenum(GL_DEPTH_TEST))

        //self.effect = GLKBaseEffect()
        //self.effect!.light0.enabled = GLboolean(GL_TRUE)
        //self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 0.4, 0.4, 1.0)
       
        TOP.loadBuffers()
        BOTTOM.loadBuffers()
 
    }
    
    
    
    func loadShaders() -> Bool {
        print("load shaders")
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        var vertShaderPathname: String
        var fragShaderPathname: String
        
        // Create shader program.
        program = glCreateProgram()
        
        // Create and compile vertex shader.
        vertShaderPathname = NSBundle.mainBundle().pathForResource("Shader", ofType: "vsh")!
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false {
            print("Failed to compile vertex shader")
            return false
        }
        
        // Create and compile fragment shader.
        fragShaderPathname = NSBundle.mainBundle().pathForResource("Shader", ofType: "fsh")!
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
            print("Failed to compile fragment shader")
            return false
        }
        
        // Attach vertex shader to program.
        glAttachShader(program, vertShader)
        
        // Attach fragment shader to program.
        glAttachShader(program, fragShader)
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        glBindAttribLocation(program, GLuint(GLKVertexAttrib.Position.rawValue), "position")
        glBindAttribLocation(program, GLuint(GLKVertexAttrib.Normal.rawValue), "normal")
        glBindAttribLocation(program, GLuint(GLKVertexAttrib.Color.rawValue), "colorVarying")
        
        
        // Link program.
        if !self.linkProgram(program) {
            print("Failed to link program: \(program)")
            
            if vertShader != 0 {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0 {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if program != 0 {
                glDeleteProgram(program)
                program = 0
            }
            
            return false
        }
        
        // Get uniform locations.
        uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix")
        uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix")
 
        
        uniforms[UNIFORM_Perspective_MATRIX] = glGetUniformLocation(program, "uPMatrix")
        uniforms[UNIFORM_view_MATRIX] = glGetUniformLocation(program, "uVMatrix")
        uniforms[UNIFORM_object_MATRIX] = glGetUniformLocation(program, "uOMatrix")
        
        uniforms[UNIFORM_color_MATRIX] = glGetUniformLocation(program, "colorVarying")
        
        print(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX])
        
        // Release vertex and fragment shaders.
        if vertShader != 0 {
            glDetachShader(program, vertShader)
            glDeleteShader(vertShader)
        }
        if fragShader != 0 {
            glDetachShader(program, fragShader)
            glDeleteShader(fragShader)
        }
        
        return true
    }
    
    
    func compileShader(inout shader: GLuint, type: GLenum, file: String) -> Bool {
        print("compile shaders")
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding).UTF8String
        } catch {
            print("Failed to load vertex shader")
            return false
        }
        var castSource = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func linkProgram(prog: GLuint) -> Bool {
        print("link program")
        var status: GLint = 0
        glLinkProgram(prog)
        
        
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        //called every frame.  basically update
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
       // glBindVertexArrayOES(vertexBuffer)
       // glBindVertexArrayOES(indexBuffer)
        // Render the object with GLKit
        self.effect?.prepareToDraw()
        
        //glDrawArrays(GLenum(GL_TRIANGLES) , 0, 24)
        
        // Render the object again with ES2
        glUseProgram(program)
        
        withUnsafePointer(&perspectiveMatrix, {
            glUniformMatrix4fv(uniforms[UNIFORM_Perspective_MATRIX], 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&viewMatrix, {
            glUniformMatrix4fv(uniforms[UNIFORM_view_MATRIX], 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&objectMatrix, {
            glUniformMatrix4fv(uniforms[UNIFORM_object_MATRIX], 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&modelcolornMatrix, {
            glUniformMatrix4fv(uniforms[UNIFORM_color_MATRIX], 1, 0, UnsafePointer($0))
        })
        
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, UnsafePointer($0))
        })
        TOP.render()
        BOTTOM.render()
    }
    
    
    
    
    
    
    
    
    
    
    
    func update() {
        
        
        let aspect = fabsf(Float(self.view.bounds.size.width / self.view.bounds.size.height))
        //var projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        
        
        //var ppj: GLKMatrix4 = GLKMatrix4(m: )
        let pj: GLKMatrix4 = GLKMatrix4(m: (2.4142136573791504, 0.0, 0.0, 0.0, 0.0, 2.4142136573791504, 0.0, 0.0, 0.0, 0.0, -1.0202020406723022, -1.0, 0.0, 0.0, -0.20202019810676575, 0.0))
        
        self.effect?.transform.projectionMatrix =  pj;
        
       
        var baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -4.0)
        baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, rotation, 0.0, 1.0, 0.0)
        
        // Compute the model view matrix for the object rendered with GLKit
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -150)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0, 1.0, 1.0)
        modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix)
        
        self.effect?.transform.modelviewMatrix = modelViewMatrix
        
        // Compute the model view matrix for the object rendered with ES2
        modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, 3.0)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0, 1.0, 1.0)
        modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix)
        
        modelcolornMatrix = GLKMatrix3Make(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
        
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), nil)
        
        modelViewProjectionMatrix = GLKMatrix4Multiply(pj, modelViewMatrix)
        
        rotation += Float(self.timeSinceLastUpdate * 0.5)
      
        //send up the current uniform variables to their stored locations
      //  gl.uniformMatrix4fv(obj.shaderProgram.pMatrixUniform, false, proj);
       // gl.uniformMatrix4fv(obj.shaderProgram.vMatrixUniform, false, view);
        //gl.uniformMatrix4fv(obj.shaderProgram.oMatrixUniform, false, obj.matrix);
        
       // print(modelcolornMatrix.m)
        
    }
     
    
    
    
    
    func tearDownGL() {
        print("tear Down")
        EAGLContext.setCurrentContext(self.context)
        
       // glDeleteBuffers(1, &vertexBuffer)
       // glDeleteVertexArraysOES(1, &vertexArray)
       // glDeleteBuffers(1, &indexBuffer)
        self.effect = nil
        
        if program != 0 {
            glDeleteProgram(program)
            program = 0
        }
    }
 
    
 
    
    // MARK: -  OpenGL ES 2 shader compilation
    
 
    
 
    
    func validateProgram(prog: GLuint) -> Bool {
        print("validate")
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](count: Int(logLength), repeatedValue: 0)
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(log)")
        }
        
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0 {
            returnVal = false
        }
        return returnVal
    }
    
    
    
    override func didReceiveMemoryWarning() {
        print("memory")
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }


}

