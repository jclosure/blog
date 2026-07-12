---
layout: post
title: "Wrapping C and C++ APIs in Python"
date: 2019-12-16 17:24:10 -0600
categories: []
tags: ["C#", "Interop", "Python", "Speed"]
wordpress_id: 1124
original_url: "https://joelholder.com/2019/12/16/wrapping-c-apis-in-python/"
---

<figure class="wp-block-image size-full"><img decoding="async" src="/assets/wp/wrapping-c-apis-in-python/python-cpp-hero.jpg" alt="Line-art illustration of Python and C++ working together at a laptop"/></figure>

<p class="wp-block-paragraph">Python is usually where I want to orchestrate work: load data, shape inputs, run experiments, and glue systems together. C and C++ are where I want hot loops, existing native libraries, SIMD-heavy routines, mature systems code, and APIs that already exist outside the Python ecosystem.</p>



<p class="wp-block-paragraph">The useful question is not whether Python or C is better. The useful question is where the boundary should be. If the native side has a small stable ABI, <code>ctypes</code> is often enough. If the boundary needs C++ types, exceptions, RAII, overloaded functions, or a clean Python-facing module, reach for <code>pybind11</code>.</p>



<h2 class="wp-block-heading">Start with the ABI</h2>



<p class="wp-block-paragraph">For a C API, the minimum viable path is:</p>



<ul class="wp-block-list"><li>build a shared library for the target platform</li><li>load it with <code>ctypes.CDLL</code></li><li>declare each function&#8217;s argument types and return type</li><li>be explicit about memory ownership and error behavior</li></ul>



<p class="wp-block-paragraph">Using <a href="https://github.com/simplegeo/libgeohash">libgeohash</a> as an example, a simple Linux build might look like this:</p>



~~~ bash
gcc -O3 -fPIC -shared -o libgeohash.so geohash.c
~~~



<p class="wp-block-paragraph">On macOS that output would usually be a <code>.dylib</code>; on Windows, a <code>.dll</code>. The Python code should not assume the extension unless you control deployment.</p>



<h2 class="wp-block-heading">A small ctypes wrapper</h2>



<p class="wp-block-paragraph">The important part of <code>ctypes</code> is not the load call. It is declaring the ABI accurately. Without <code>argtypes</code> and <code>restype</code>, Python will guess, and those guesses are not a contract you want in production.</p>



~~~ python
from ctypes import CDLL, c_char_p, c_double, c_int
from pathlib import Path

lib = CDLL(str(Path(__file__).with_name("libgeohash.so")))

def bind(name, restype, *argtypes):
    fn = getattr(lib, name)
    fn.restype = restype
    fn.argtypes = list(argtypes)
    return fn

geohash_encode = bind(
    "geohash_encode",
    c_char_p,
    c_double,
    c_double,
    c_int,
)

raw = geohash_encode(41.41845703125, 2.17529296875, 5)
hash_value = raw.decode("ascii")
print(hash_value)  # sp3e9
~~~



<p class="wp-block-paragraph">That wrapper is intentionally boring. A Python call crosses into native code, the C function receives two doubles and an int, and the returned <code>char *</code> is exposed as bytes. The Python layer decodes it because the C ABI does not know about Python strings.</p>



<h2 class="wp-block-heading">Structs map cleanly when layout is simple</h2>



<p class="wp-block-paragraph">For plain C structs, define a matching <code>ctypes.Structure</code>. The order and C types must match the header. If the C side has packing pragmas, bitfields, platform-dependent integer sizes, or nested ownership, slow down and verify layout with tests.</p>



~~~ cpp
typedef struct GeoBoxDimensionStruct {
    double height;
    double width;
} GeoBoxDimension;

extern GeoBoxDimension geohash_dimensions_for_precision(int precision);
~~~



~~~ python
from ctypes import Structure, c_double, c_int

class GeoBoxDimension(Structure):
    _fields_ = [
        ("height", c_double),
        ("width", c_double),
    ]

geohash_dimensions_for_precision = bind(
    "geohash_dimensions_for_precision",
    GeoBoxDimension,
    c_int,
)

dims = geohash_dimensions_for_precision(6)
print(dims.height, dims.width)
~~~



<p class="wp-block-paragraph">This is a good shape for <code>ctypes</code>: value types cross the boundary, Python receives a small struct, and there is no lifecycle problem to solve.</p>



<h2 class="wp-block-heading">Out parameters and buffers</h2>



<p class="wp-block-paragraph">Many C APIs return status codes and write results through pointers. Model that directly. Do not pretend every C function is a Python function that returns one object.</p>



~~~ cpp
int geohash_decode_bbox(
    const char *hash,
    double *lat_min,
    double *lat_max,
    double *lng_min,
    double *lng_max
);
~~~



~~~ python
from ctypes import POINTER, byref, c_char_p, c_double, c_int

geohash_decode_bbox = bind(
    "geohash_decode_bbox",
    c_int,
    c_char_p,
    POINTER(c_double),
    POINTER(c_double),
    POINTER(c_double),
    POINTER(c_double),
)

def decode_bbox(hash_value: str):
    lat_min = c_double()
    lat_max = c_double()
    lng_min = c_double()
    lng_max = c_double()

    rc = geohash_decode_bbox(
        hash_value.encode("ascii"),
        byref(lat_min),
        byref(lat_max),
        byref(lng_min),
        byref(lng_max),
    )
    if rc != 0:
        raise ValueError(f"geohash_decode_bbox failed: {rc}")

    return lat_min.value, lat_max.value, lng_min.value, lng_max.value
~~~



<p class="wp-block-paragraph">The wrapper converts the C style into a Python style at the edge: allocate output slots, call the native function, check the return code, and return a tuple. That keeps the rest of the Python application free of pointer management.</p>



<h2 class="wp-block-heading">Use pybind11 when the boundary wants to be a module</h2>



<p class="wp-block-paragraph"><code>ctypes</code> works best against a C ABI. Once the native side is C++, or once you want a polished Python module instead of a thin ABI wrapper, <a href="https://github.com/pybind/pybind11">pybind11</a> is usually cleaner. You write a small C++ binding layer, compile it as a Python extension, and expose Python-native functions/classes.</p>



~~~ cpp
// bindings.cpp
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <stdexcept>
#include <string>

namespace py = pybind11;

extern "C" char *geohash_encode(double lat, double lng, int precision);

struct Box {
    double height;
    double width;
};

Box dimensions_for_precision(int precision) {
    // In real code this would call the native library.
    return Box{0.0054931640625, 0.010986328125};
}

std::string encode(double lat, double lng, int precision) {
    char *raw = geohash_encode(lat, lng, precision);
    if (raw == nullptr) {
        throw std::runtime_error("geohash_encode returned null");
    }
    return std::string(raw);
}

PYBIND11_MODULE(geohash_native, m) {
    m.doc() = "Native geohash bindings";

    py::class_<Box>(m, "Box")
        .def_readonly("height", &Box::height)
        .def_readonly("width", &Box::width);

    m.def("encode", &encode,
        py::arg("lat"),
        py::arg("lng"),
        py::arg("precision") = 12);

    m.def("dimensions_for_precision", &dimensions_for_precision);
}
~~~



<p class="wp-block-paragraph">A minimal build using <code>setuptools</code> can stay small:</p>



~~~ python
# setup.py
from pybind11.setup_helpers import Pybind11Extension, build_ext
from setuptools import setup

ext_modules = [
    Pybind11Extension(
        "geohash_native",
        ["bindings.cpp", "geohash.c"],
        cxx_std=17,
    ),
]

setup(
    name="geohash_native",
    ext_modules=ext_modules,
    cmdclass={"build_ext": build_ext},
)
~~~



~~~ bash
python -m pip install pybind11 setuptools wheel
python -m pip install -e .
~~~



~~~ python
import geohash_native

print(geohash_native.encode(41.41845703125, 2.17529296875, precision=5))

box = geohash_native.dimensions_for_precision(6)
print(box.height, box.width)
~~~



<p class="wp-block-paragraph">The tradeoff is build complexity. With <code>ctypes</code>, Python loads an existing shared object. With <code>pybind11</code>, you ship a compiled Python extension for each supported Python/platform/architecture combination. The upside is a nicer API, better C++ interop, and fewer pointer-shaped details leaking into application code.</p>



<h2 class="wp-block-heading">Rules of thumb</h2>



<ul class="wp-block-list"><li>Use <code>ctypes</code> when the native library already exposes a stable C ABI and the surface area is small.</li><li>Use <code>pybind11</code> when you own the native code, need C++ types, or want a Pythonic module.</li><li>Keep allocation and freeing on the same side of the boundary unless the API explicitly documents otherwise.</li><li>Turn C status codes into Python exceptions at the wrapper edge.</li><li>Write tests for struct layout, null pointers, invalid inputs, and at least one known-good result from the native library.</li><li>Benchmark the boundary. Crossing into native code is cheap enough for coarse operations, but not something to do once per scalar in a Python loop.</li></ul>



<p class="wp-block-paragraph">The clean version is simple: keep Python in charge of orchestration, keep native code responsible for the expensive or already-existing work, and make the boundary explicit. A thin wrapper is often enough, but the moment the boundary becomes part of your product API, give it the same design attention as any other public interface.</p>
