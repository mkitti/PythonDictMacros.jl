using PythonDictMacros
using PythonCall
using Test

@testset "PythonDictMacros.jl" begin
    pyd = @pythondict {
                       "driver": "n5",
                       "kvstore": {
                                   "driver": "file",
                                   "path": "tmp/dataset/",
                                  },
                       "metadata": {
                                    "compression": {
                                                    "type": "gzip"
                                                   },
                                    "dataType": "uint32",
                                    "dimensions": [1000, 20000],
                                    "blockSize": [100, 100],
                                   },
                       "create": True,
                       "delete_existing": True,
                      }
    @test pyeq(Bool, pyd["driver"], "n5")
    @test pyeq(Bool, pyd["kvstore"]["driver"], "file")
    @test pyeq(Bool, pyd["kvstore"]["path"], "tmp/dataset/")
    @test pyeq(Bool, pyd["metadata"]["compression"]["type"], "gzip")
    @test pyeq(Bool, pyd["metadata"]["dataType"], "uint32")
    @test pyeq(Bool, pyd["metadata"]["dimensions"], pylist([1000, 20000]))
    @test pyeq(Bool, pyd["metadata"]["blockSize"], pylist([100, 100]))
    @test pyeq(Bool, pyd["create"], true)
    @test pyeq(Bool, pyd["delete_existing"], true)

    pyd2 = @pythondict({
                        "driver":"neuroglancer_precomputed",
                        "kvstore":
                        "gs://neuroglancer-janelia-flyem-hemibrain/v1.1/segmentation/",
                        # Use 100MB in-memory cache.
                        "context": {
                                    "cache_pool": {
                                                   "total_bytes_limit": 100_000_000
                                                  }
                                   },
                        "recheck_cached_data":
                        "open",
                       })
    @test pyeq(Bool, pyd2["driver"], "neuroglancer_precomputed")
    @test pyeq(Bool, pyd2["kvstore"], "gs://neuroglancer-janelia-flyem-hemibrain/v1.1/segmentation/")
    @test pyeq(Bool, pyd2["context"]["cache_pool"]["total_bytes_limit"], 100_000_000)
    @test pyeq(Bool, pyd2["recheck_cached_data"], "open")
end
