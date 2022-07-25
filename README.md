# ***numpp***: NumPy-like C++ library for fast multi-dimensional arrays

***numpp*** is a C++ header-only library that allows to create and manipulate multi-dimensional dynamic arrays with syntax inspired from Python's  [NumPy](https://numpy.org).

## Table of Contents
1. [Table of Contents](#table-of-contents)
2. [How to include ***numpp*** in your code](#how-to-include-numpp-in-your-code)
3. [Usage](#usage)
   - [Array creation](#array-creation)
   - [Reshaping](#reshaping)
   - [Indexing](#indexing)
   - [Views and copies](#views-and-copies)
   - [Array operations](#array-operations)
   - [Comparison operators](#comparison-operators)

## How to include ***numpp*** in your code

Simply download the headers in the `Source/` sub-folder into your project or *include* directory, then simply `#include "numpp.hpp"`.

## Usage

The main interface defined by ***numpp*** is the `array<T>` template class in the `npp` namespace (`npp::array<T>`), and a few other utility functions defined again in the `npp` namespace.

The following sections give an overview on how to use the classes and functions offered by the library. 
`ExampleUsages/example_usage.cpp` contains similar examples.

### Array creation
An empty array can be created as follows:
```
npp::array<int> arr;
```

1-dimensional, 2-dimensional, 3-dimensional (and more) arrays can be created in the following ways:
```
// 1D array with shape (3)
npp::array<double> arr1d{1., 2., 3.};

// 2D array with shape (2, 3)
auto arr2d = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// 3D array with shape (2, 3, 4)
auto arr3d = npp::arr<int> {
    {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
    {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
};
```

`full()` and `eye()` allow to create arrays with certain shapes and values:
```
// array with shape (4, 3, 2) filled with 0.5 in all positions
auto f = npp::full<double>({4, 3, 2}, 0.5);

// array with shape (2, 2) with -1 on the main diagonal, 0 elsewhere
auto e = npp::eye<int>(2, -1);

// if a value is not specified, the main diagonal will be filled with 1
auto e1 = npp::eye<int>(3);
```

`array` properties can be inspected as follows:
```
// Create a 2D array with shape (2, 3)
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// array size
arr.size()                 // 6

// Let's get the shape
auto s = arr.shape()
s.ndims()                  // 2
s[0]                       // 2
s[1]                       // 3
```

### Reshaping
`array.resize()` and `array.resize_flat()` reshape the array in place:
```
// 2D array with shape (2, 3)
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// resize arr with shape (3, 2)
arr.resize({3, 2});

// flatten arr to 1 dimension with size 6
arr.resize_flat();
```

`array.reshape()` and `array.flatten()` return a reshaped view of the array:
```
// reshaped is a view of arr with shape (3, 2)
auto reshaped = arr.reshape({3, 2});

// flat is a flattened view of arr (1 dimension with size 6)
auto flat = arr.flatten();
```

### Indexing
Data in `array` is stored in row-major order. 
Data can be accessed as follows:
```
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// access element in row 0, column 1
int e = arr(0, 1);

// access element in row 1, column 0
e = arr(1, 0);

// elements can also be accessed sequentially (row-major order)
e = arr[0]                             // equivalent to arr(0, 0)
e = arr[1]                             // equivalent to arr(0, 1)
```

Negative indices are allowed. `-1` indicates the last position, `-2` the second-to-last position, etc:
```
// first row, last column
e = arr(0, -1)

// last row, second-to-last column
e = arr(-1, -2)

// last element (last row, last column)
e = arr[-1]

// second-to-last element (last row, second-to-last column)
e = arr[-2]
```

### Views and copies
Views allow to create array that share (some of) the data of another array.
They can be resized differently than the array they share the data with:
```
// Let's start with our usual array
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// v is a view of arr
auto v = arr.view();

// let's change v shape to (3, 2). arr shape remains (2, 3)
v.resize({3, 2});

// by changing values in arr we change values in v...
arr(0, 0) = 100;                    // both arr(0, 0) and v(0, 0) now equal 100

// ...and vice-versa 
v(1, 0) = 300;                      // v(1, 0) and arr(0, 2) (remember shapes are different!) are now 300
```

Copies are arrays created equal to another array but that do not share the same data:
```
// Let's start with our usual array
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// c is a copy of arr
auto c = arr.copy();

// changing arr content does not change c...
arr(0, 0) = 100;                    // arr(0, 0) is now 100, c(0, 0) is still 1

// ...and vice-versa
c(0, 1) = 200;                      // c(0, 1) is now 200, arr(0, 1) is still 2
```

We can make views on only some sections of an array using integer indices (such as `0`, `1` or `-1`) and helper functions such as `all()`, `range()` and `slice()`:
```
// Usual array
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// View on the first row
auto v = arr.view(0, npp::all());                     // v has shape (1, 3)

// View on the last column
auto v1 = arr.view(npp::all(), -1);                   // v1 has shape (2, 1)

// View on first and last column
auto v2 = arr.view(npp::all(), npp::slice({0, -1}));  // shape (2, 2)

// View on first up to third column
auto v2 = arr.view(npp::all(), npp::range(0, 2));     // shape (2, 3)

// Range accepts a step parameter (defaulting to 1)
// View on arr with columns reversed
auto v3 = arr.view(npp::all(), npp::range(0, -1, -1)) // v3(0, 0) is equal to arr(0, -1), i.e. arr(0, 2)
```

Note that `array.reshape()` and `array.flatten()` (discussed previously) return views of arrays.
In addition, one can use `array.diagonal()` and `array.transpose()` to return views of the main diagonal and of the transposed array:
```
// Let's make a (2, 2) array
auto square = npp::array<int> {{1, 2}, {3, 4}};

// view on main diagonal of square
auto diag = square.diagonal();                     // 1 dim with size 2
auto e = d(0);                                     // e is 1
e = d(1);                                          // e is 4

// transposed of our usual array
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}}; // shape (2, 3)
auto t = arr.transpose();                          // t has shape (3, 2)
e = t(0, 0)                                        // 1
e = t(0, 1)                                        // 4
e = t(1, 0)                                        // 2
```

### Array operations
`npp::array` overloads all arithmetical operators which can accept both scalars and arrays. If an operation involves two arrays, they must have the same shape and the
result is the element-wise application of the operation.

Operations with scalars:
```
// our usual array
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};

// add a scalar
auto result = arr + 1;                    // result(0, 0) is 2, result(0, 1) is 3, ..., result(-1, -1) is 7

// other operations are defined as well
result = arr - 1;
result = arr * 1;
result = arr / 1;
result = arr % 1;
```

Operations with other arrays are element-wise operations
```
// our usual array and a second array with same shape
auto arr = npp::array<int> {{1, 2, 3}, {4, 5, 6}};
auto other = npp::array<int> {{7, 8, 9}, {10, 11, 12}};

// add the two arrays
auto result = arr + other;                 // result(0, 0) is 8, ..., result(-1, -1) is 18

// other operations are defined as well
result = arr - other;
result = arr * other;
result = arr / other;
result = arr % other;
```

Matrix multiplication (dot product) can be performed with the `array.dot()` member function:
```
// one 2D array and two 1D arrays
auto mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}});   // shape: (3, 2)
auto vec1 = npp::array<int>({1, 2});                    // shape: (2)
auto vec2 = npp::array<int>({3, 4});                    // shape: (2)

// dot product of 2 1D arrays returns an array with size 1
auto dot = vec1.dot(vec2);                               // dot(0) is 11

// dot product of array (n, m) with array (m) returns array (n)
auto dot1 = mat.dot(vec1);                               // dot1(0), dot1(1), dot1(2) = 5, 11, 17

// dot product of array (m) with array (m, n) returns array (n)
auto dot2 = vec1.dot(mat.transpose());                   // dot2(0), dot2(1), dot2(2) = 5, 11, 17

// dot product of array (n, m) with array (m, k) returns array (n, k)
auto dot3 = mat.tranpose().dot(mat);                     // dot3(0, 0), dot3(0, 1), dot3(1, 0), dot3(1, 1) = 35, 44, 44, 56
```

### Comparison operators
Boolean comparisons can be made using scalars or arrays, which in both cases returns an array of booleans.
In case of comparisons between two arrays, the two must have the same shape.
Two member functions, `array.any()` and `array.all()` can be used to reduce a boolean array into a single boolean value.

Comparisons with scalars:
```
// define an array
auto arr = npp::array<int>{1, 2, 3};
auto comp = arr == 3;                     // array with values {false, false, true}

// other scalar comparison operations
comp = arr > 3;
comp = arr >= 3;
comp = arr < 3;
comp = arr <= 3;
```

Comparisons between arrays (element-wise comparisons):
```
// create two arrays
auto first = npp::array<int>{1, 2, 3};
auto second = npp::array<int>{2, 2, 2};

// compare the two
auto comp = first == second;              // array with values {false, true, false}

// other comparisons are defined as well
comp = first > second;
comp = first >= second;
comp = first < second;
comp = first <= second;
```

`array.any()` returns `true` if any element of the array is `true`, false otherwise; `array.all()` returns `true` if all elements of the array are `true`, false otherwise;
```
auto arr = npp::array<int>{1, 2, 3};

auto comp = arr == 3;
comp.any();                // true
comp.all()                 // false

auto comp = arr <= 3;
comp.any();                // true
comp.all()                 // true
```
