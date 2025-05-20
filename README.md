# PythonDictMacros

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mkitti.github.io/PythonDictMacros.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mkitti.github.io/PythonDictMacros.jl/dev/)
[![Build Status](https://github.com/mkitti/PythonDictMacros.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/mkitti/PythonDictMacros.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Concept

This package implements a `@pythondict` macro. This allows for a `dict` expression in Python to be converted into a `PythonCall.pydict` call.

The inspiration came from trying to use the Python package TensorStore from Julia. TensorStore uses JSON-like `dict` expressions as arguments. This package makes it easier to copy and paste such expressions into Julia.

```julia-repl
julia> """
       {
       ...     'driver': 'n5',
       ...     'kvstore': {
       ...         'driver': 'file',
       ...         'path': 'tmp/dataset/',
       ...     },
       ...     'metadata': {
       ...         'compression': {
       ...             'type': 'gzip'
       ...         },
       ...         'dataType': 'uint32',
       ...         'dimensions': [1000, 20000],
       ...         'blockSize': [100, 100],
       ...     },
       ...     'create': True,
       ...     'delete_existing': True,
       ... }
       """ |> (x-> replace(x, "'" => '"', "... " => "")) |> println
{
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


julia> @pythondict {
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
Python: {'driver': 'n5', 'kvstore': {'driver': 'file', 'path': 'tmp/dataset/'}, 'metadata': {'compression': {'type': 'gzip'}, 'dataType': 'uint32', 'dimensions': [1000, 20000], 'blockSize': [100, 100]}, 'create': True, 'delete_existing': True}
```

## Application to TensorStore

```julia-repl
julia> using PythonCall, PythonDictMacros

julia> ts.open(@pythondict {
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
       }).result()
Python:
TensorStore({
  'context': {
    'cache_pool': {},
    'data_copy_concurrency': {},
    'file_io_concurrency': {},
    'file_io_sync': True,
  },
  'driver': 'n5',
  'dtype': 'uint32',
  'kvstore': {'driver': 'file', 'path': 'tmp/dataset/'},
  'metadata': {
    'blockSize': [100, 100],
    'compression': {'level': -1, 'type': 'gzip', 'useZlib': False},
    'dataType': 'uint32',
    'dimensions': [1000, 20000],
  },
  'transform': {
    'input_exclusive_max': [[1000], [20000]],
    'input_inclusive_min': [0, 0],
  },
})
```
