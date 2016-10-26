import OpenGLES
import GLKit

struct TexturedVertex {
    var geometryVertex = GLKVector2()
    var textureVertex = GLKVector2()
}

struct TexturedQuad {
    var bl = TexturedVertex()
    var br = TexturedVertex()
    var tl = TexturedVertex()
    var tr = TexturedVertex()
    init() { }
}

var _quad = TexturedQuad()

withUnsafePointer(&_quad.bl.geometryVertex) { (pointer) -> Void in
    glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue),
                          2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                          GLsizei(sizeof(TexturedVertex)), pointer)
}
withUnsafePointer(&_quad.bl.textureVertex) { (pointer) -> Void in
    glVertexAttribPointer(GLuint(GLKVertexAttrib.TexCoord0.rawValue),
                          2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                          GLsizei(sizeof(TexturedVertex)), pointer)
}

