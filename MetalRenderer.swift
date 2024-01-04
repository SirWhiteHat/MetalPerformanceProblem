import MetalKit

var VERTEX_DATA: [SIMD3<Float>] =
[
    // v0
    [ 0.0,  1.0, 0.0], // position
    [ 1.0,  0.0, 0.0], // color
    // v1
    [-1.0, -1.0, 0.0],
    [ 0.0,  1.0, 0.0],
    // v2
    [ 1.0, -1.0, 0.0],
    [ 0.0,  0.0, 1.0]
]

let SHADERS_DIR_LOCAL_PATH        = "/Sources/Shaders"
let DEFAULT_SHADER_LIB_LOCAL_PATH = SHADERS_DIR_LOCAL_PATH + "/HelloTriangle.metallib"

class MetalRenderer : NSObject
{
    private let mPipeline:     MTLRenderPipelineState
    private let mCommandQueue: MTLCommandQueue
	
	var batch: Int = 0

	public init(device: MTLDevice?)
	{
		guard let cq = device!.makeCommandQueue() else
		{
			fatalError("Could not create command queue")
		}
		mCommandQueue = cq

		let library = device!.makeDefaultLibrary()
		let vertexFunction   = library!.makeFunction(name: "vertex_main")
		let fragmentFunction = library!.makeFunction(name: "fragment_main")

		let vertDesc = MTLVertexDescriptor()
		vertDesc.attributes[0].format      = .float3
		vertDesc.attributes[0].bufferIndex = 0
		vertDesc.attributes[0].offset      = 0
		vertDesc.attributes[1].format      = .float3
		vertDesc.attributes[1].bufferIndex = 0
		vertDesc.attributes[1].offset      = MemoryLayout<SIMD3<Float>>.stride
		vertDesc.layouts[0].stride         = MemoryLayout<SIMD3<Float>>.stride * 2

		let pipelineDescriptor = MTLRenderPipelineDescriptor()
		pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		pipelineDescriptor.vertexFunction                  = vertexFunction
		pipelineDescriptor.fragmentFunction                = fragmentFunction
		pipelineDescriptor.vertexDescriptor                = vertDesc

		guard let ps = try! device?.makeRenderPipelineState(descriptor: pipelineDescriptor) else
		{
			fatalError("Couldn't create pipeline state")
		}
		mPipeline = ps

		super.init()
	}

	func addView(view: MTKView) {
		view.delegate = self
	}

}

extension MetalRenderer: MTKViewDelegate
{
    public func draw(in view: MTKView)
    {
		let dataSize     = VERTEX_DATA.count * MemoryLayout.size(ofValue: VERTEX_DATA[0])
		VERTEX_DATA[0][0] += 0.01
		if (VERTEX_DATA[0][0] > 1) {
			VERTEX_DATA[0][0] = -1
		}
		let vertexBuffer = view.device?.makeBuffer(bytes:   VERTEX_DATA,
												  length:  dataSize,
												  options: [])

		let commandBuffer  = mCommandQueue.makeCommandBuffer()!

		let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
		commandEncoder?.setRenderPipelineState(mPipeline)
		commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
		commandEncoder?.drawPrimitives(type: .triangle,
									 vertexStart: 0,
									 vertexCount: 3,
									 instanceCount: 1)
		commandEncoder?.endEncoding()

		commandBuffer.present(view.currentDrawable!)
		commandBuffer.commit()
		commandBuffer.waitUntilCompleted()
	}
	
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        // This will be called on resize
    }
}
