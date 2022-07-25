//
//  example_usage.cpp
//  numpp
//
//  Created by Daniele Colombo on 24/07/2022.
//

#include <iostream>

#include "numpp.hpp"

int main() {
  using std::cout;
  using std::endl;

  /*
   * ARRAY CREATION AND RESHAPING
   */

  /* A multi-dimensional array can be created as follows: */
  npp::array<int> arr({{1, 2, 3}, {4, 5, 6}});
  cout << "npp::array<int> arr({{1, 2, 3}, {4, 5, 6}})\n";
  cout << "Size: " << arr.size() << endl;                                         // out: 6
  cout << "Number of dimensions: " << arr.shape().ndims() << endl;                // out: 2
  cout << "Shape: (" << arr.shape()[0] << ", " << arr.shape()[1] << ")" << endl;  // out: (2, 3)
  cout << "===================\n";

  npp::array<int> arr3D({{{1, 2, 3}, {4, 5, 6}}, {{7, 8, 9}, {10, 11, 12}}});
  cout << "npp::array<int> arr3D({  {{1, 2, 3}, {4, 5, 6}},  {{7, 8, 9}, {10, 11, 12}} })\n";
  cout << "Size: " << arr3D.size() << endl;                           // out: 12
  cout << "Number of dimensions: " << arr3D.shape().ndims() << endl;  // out: 3
  cout << "Shape: (" << arr3D.shape()[0] << ", " << arr3D.shape()[1] << ", " << arr3D.shape()[2]
       << ")" << endl;  // out: (2, 2, 3)
  cout << "===================\n";

  /* Reshaping can be done in-place using array.resize() or a new array (a view of the original
   * array) can be returned with array.reshape() */
  auto arr_reshape = arr.reshape({6});
  cout << "auto arr_reshape = arr.reshape({6})\n";
  cout << "Number of dimensions - arr: " << arr.shape().ndims()                // out: 2
       << "; arr_reshape: " << arr_reshape.shape().ndims() << endl;            // out: 1
  cout << "Shape - arr: (" << arr.shape()[0] << ", " << arr.shape()[1] << ")"  // out: (2, 3)
       << "; arr_reshape: (" << arr_reshape.shape()[0] << ")" << endl;         // out: (6)
  cout << "===================\n";

  arr.resize({3, 2});
  cout << "arr.resize({3, 2})\n";
  cout << "Number of dimensions - arr: " << arr.shape().ndims()                // out: 2
       << "; arr_reshape: " << arr_reshape.shape().ndims() << endl;            // out: 1
  cout << "Shape - arr: (" << arr.shape()[0] << ", " << arr.shape()[1] << ")"  // out: (3, 2)
       << "; arr_reshape: (" << arr_reshape.shape()[0] << ")" << endl;         // out: (6)
  cout << "===================\n";

  /* array.flatten() and array.resize_flat() respectively return a flattened view of array, and
   * flatten the array in place */
  auto arr_flat = arr.flatten();
  arr.resize_flat();
  cout << "auto arr_flat = arr.flatten()\n";
  cout << "arr.resize_flat()\n";
  cout << "Number of dimensions - arr: " << arr.shape().ndims()         // out: 1
       << "; arr_flat: " << arr_flat.shape().ndims() << endl;           // out: 1
  cout << "Shape - arr: (" << arr.shape()[0] << ")"                     // out: (6)
       << "; arr_reshape: (" << arr_reshape.shape()[0] << ")" << endl;  // out: (6)
  cout << "===================\n";

  /* full() and eye() are convenient functions that allow to create particular matrices */
  auto f = npp::full<double>({4, 3, 2}, 0.5);
  cout << "auto f = npp::full<double>({4,3,2}, 0.5)\n";
  cout << "Number of dimensions: " << f.shape().ndims() << endl;  // out: 3
  cout << "Shape: (" << f.shape()[0] << ", " << f.shape()[1] << ", " << f.shape()[2]
       << ")\n";  // out: (4, 3, 2)
  cout << "f[0], f[1], ..., f[-1]: " << f[0] << ", " << f[1] << ", ..., " << f[-1]
       << endl;  // out: 0.5, 0.5, ..., 0.5
  cout << "===================\n";

  auto e = npp::eye<int>(2, -1);
  cout << "auto e = npp::eye<int>(2, -1)\n";
  cout << "Number of dimensions: " << e.shape().ndims() << endl;        // out: 3
  cout << "Shape: (" << e.shape()[0] << ", " << e.shape()[1] << ")\n";  // out: (2, 2)
  cout << "e(0, 0), e(0, 1), e(1, 0), e(1, 1): " << e(0, 0) << ", " << e(0, 1) << ", " << e(1, 0)
       << ", " << e(1, 1) << endl;  // out: -1, 0, 0, -1
  cout << "===================\n";
  auto e1 = npp::eye<int>(2);
  cout << "auto e = npp::eye<int>(2)\n";
  cout << "Default value in diagonal is: " << e1(0, 0) << endl;  // out: 1
  cout << "===================\n";

  /*
   * ARRAY INDEXING
   */

  /* Arrays can be indexed in the following way (row-major order) */
  arr = {{1, 2, 3}, {4, 5, 6}};
  cout << "arr = {{1, 2, 3}, {4, 5, 6}}\n";
  cout << "arr(0, 0), arr(0, 1), arr(0, 2), ..., arr(1, 2): " << arr(0, 0) << ", " << arr(0, 1)
       << ", " << arr(0, 2) << ", ..., " << arr(1, 2) << endl;  // out: 1, 2, 3, ..., 6
  cout << "arr[0], arr[1], arr[2], ..., arr[5]: " << arr[0] << ", " << arr[1] << ", " << arr[2]
       << ", ..., " << arr[5] << endl;  // out: 1, 2, 3, ..., 6

  /* Negative indices are allowed. -1 indicates the last position, -2 the second-to-last, etc */
  cout << "arr(0, -1), arr(-1, 0), arr(-1, -1), arr(1, -2): " << arr(0, -1) << ", " << arr(-1, 0)
       << ", " << arr(-1, -1) << ", " << arr(1, -2) << endl;  // out: 3, 4, 6, 5
  cout << "arr[-1], arr[-2], arr[-6]: " << arr[-1] << ", " << arr[-2] << ", " << arr[-6]
       << endl;  // out: 6, 5, 1
  cout << "===================\n";

  /*
   * VIEWS AND COPIES
   */

  /* Views allow to create array that share (some of) the data of another array.
     Views can be resized differently than the array they share the data with */
  auto v = arr.view();
  v.resize({3, 2});
  cout << "auto v = arr.view()\n";
  cout << "v.resize({3, 2})\n";
  arr(0, 0) = 100;
  cout << "arr(0, 0) = 100\n";
  cout << "arr(0, 0), v(0, 0): " << arr(0, 0) << ", " << v(0, 0) << endl;  // out: 100, 100
  v(1, 0) = 300;
  cout << "v(1, 0) = 300\n";
  cout << "arr(0, 2), v(1, 0): " << arr(0, 2) << ", " << v(1, 0) << endl;  // out: 300, 300
  cout << "===================\n";

  /* Copies are arrays created equal to another array but that do not share the same data */
  auto c = arr.copy();
  cout << "auto c = arr.copy()\n";
  arr(0, 1) = 200;
  cout << "arr(0, 1) = 200\n";
  cout << "arr(0, 1), c(0, 1): " << arr(0, 1) << ", " << c(0, 1) << endl;  // out: 200, 2
  c(1, 0) = 400;
  cout << "c(1, 0) = 400\n";
  cout << "arr(1, 0), c(1, 0): " << arr(1, 0) << ", " << c(1, 0) << endl;  // out: 4, 400
  cout << "===================\n";

  /* Views can be made on sections of arrays using indices, range(), slice() and all() */
  arr = {{1, 2, 3}, {4, 5, 6}};
  cout << "arr = {{1, 2, 3}, {4, 5, 6}}\n";
  /* View on first row*/
  auto v1 = arr.view(0, npp::all());
  v1.resize_flat();
  cout << "auto v1 = arr.view(0, npp::all())\n";
  cout << "v1.resize_flat()\n";
  cout << "v1(0), v1(-1): " << v1(0) << ", " << v1(-1) << endl;  // out: 1, 3
  /* View on last column*/
  auto v2 = arr.view(npp::all(), -1);
  v2.resize_flat();
  cout << "auto v2 = arr.view(npp::all(), -1)\n";
  cout << "v2.resize_flat()\n";
  cout << "v2(0), v2(-1): " << v2(0) << ", " << v2(-1) << endl;  // out: 3, 6
  /* View on first and last column*/
  auto v3 = arr.view(npp::all(), npp::slice({0, -1}));
  cout << "auto v3 = arr.view(npp::all(), npp::slice({0, -1}))\n";
  cout << "v3(0, 0), v3(0, 1), v3(1, 0), v3(1, 1): " << v3(0, 0) << ", " << v3(0, 1) << ", "
       << v3(1, 0) << ", " << v3(1, 1) << endl;  // out: 1, 3, 4, 6
  /* View on first to third column */
  auto v4 = arr.view(npp::all(), npp::range(0, 2));
  cout << "auto v4 = arr.view(npp::all(), npp::range(0, 2))\n";
  cout << "v4(0, 0), v4(0, 2), v4(-1, -1): " << v4(0, 0) << ", " << v4(0, 2) << ", " << v4(-1, -1)
       << endl;  // out: 1, 3, 6
  cout << "===================\n";

  /* Diagonal and transpose also return views */
  auto d = arr.view(npp::slice({0, 1}), npp::slice({0, 1})).diagonal();
  cout << "auto d = arr.view(npp::slice({0, 1}), npp::slice({0, 1})).diagonal()\n";
  cout << "d(0), d(1): " << d(0) << ", " << d(1) << endl;  // out: 1, 5
  auto t = arr.transpose();
  cout << "auto t = arr.transpose()\n";
  cout << "t.shape()[0], t.shape()[1]: " << t.shape()[0] << ", " << t.shape()[1]
       << endl;  // out: 3, 2
  cout << "===================\n";

  /*
   * ARRAY OPERATIONS
   */

  /* Operations with scalars */
  arr = {{1, 2, 3}, {4, 5, 6}};
  cout << "arr = {{1, 2, 3}, {4, 5, 6}}\n";
  auto arr_plus = arr + 10;
  cout << "auto arr_plus = arr + 10\n";
  cout << "arr_plus(0, 0), arr_plus(-1, -1): " << arr_plus(0, 0) << ", " << arr_plus(-1, -1)
       << endl;  // out: 11, 16
  /* Other valid operations with scalars */
  arr - 5;
  arr * 2;
  arr / 10;
  arr % 3;
  cout << "arr - 5\n";
  cout << "arr * 2\n";
  cout << "arr / 10\n";
  cout << "arr % 3\n";
  cout << "===================\n";

  /* Element-wise operations with other arrays */
  auto arr2 = npp::array<int>({{10, 20, 30}, {40, 50, 60}});
  arr_plus = arr + arr2;
  cout << "auto arr2 = npp::array<int>({{10, 20, 30}, {40, 50, 60}})\n";
  cout << "arr_plus = arr + arr2\n";
  cout << "arr_plus(0, 0), arr_plus(-1, -1): " << arr_plus(0, 0) << ", " << arr_plus(-1, -1)
       << endl;  // out: 11, 66

  /* Other valid element-wise operations with other arrays */
  arr - arr2;
  arr* arr2;
  arr / arr2;
  arr % arr2;
  cout << "arr - arr2\n";
  cout << "arr * arr2\n";
  cout << "arr / arr2\n";
  cout << "arr % arr2\n";
  cout << "===================\n";

  /* Dot product: 1D * 1D */
  auto vec1 = npp::array<int>({1, 2});
  auto vec2 = npp::array<int>({3, 4});
  auto dot11 = vec1.dot(vec2);
  cout << "auto vec1 = npp::array<int>({1, 2})\n";
  cout << "auto vec2 = npp::array<int>({3, 4})\n";
  cout << "auto dot11 = vec1.dot(vec2)\n";
  cout << "dot11.size(): " << dot11.size() << endl;  // out: 1
  cout << "dot11(0): " << dot11(0) << endl;          // out: 11
  cout << "===================\n";

  /* Dot product: 2D * 1D */
  auto mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}});
  vec1 = npp::array<int>({1, 2});
  auto dot21 = mat.dot(vec1);
  cout << "auto mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}})\n";
  cout << "vec1 = npp::array<int>({1, 2})\n";
  cout << "auto dot21 = mat.dot(vec1)\n";
  cout << "Number of dimensions: " << dot21.shape().ndims() << endl;  // out: 1
  cout << "Shape: (" << dot21.shape()[0] << ")\n";                    // out: (3)
  cout << "dot21(0), dot21(1), dot21(2): " << dot21(0) << ", " << dot21(1) << ", " << dot21(2)
       << endl;  // out: 5, 11, 17
  cout << "===================\n";

  /* Dot product: 1D * 2D */
  mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}});
  vec1 = npp::array<int>({1, 2});
  auto dot12 = vec1.dot(mat.transpose());
  cout << "mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}})\n";
  cout << "vec1 = npp::array<int>({1, 2})\n";
  cout << "auto dot12 = vec1.dot(mat.transpose())\n";
  cout << "Number of dimensions: " << dot12.shape().ndims() << endl;  // out: 1
  cout << "Shape: (" << dot12.shape()[0] << ")\n";                    // out: (3)
  cout << "dot12(0), dot12(1), dot12(2): " << dot12(0) << ", " << dot12(1) << ", " << dot12(2)
       << endl;  // out: 5, 11, 17
  cout << "===================\n";

  /* Dot product: 2D * 2D */
  mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}});
  auto dot22 = mat.transpose().dot(mat);
  cout << "mat = npp::array<int>({{1, 2}, {3, 4}, {5, 6}})\n";
  cout << "auto dot22 = mat.transpose().dot(mat)\n";
  cout << "Number of dimensions: " << dot22.shape().ndims() << endl;            // out: 2
  cout << "Shape: (" << dot22.shape()[0] << ", " << dot22.shape()[1] << ")\n";  // out: (2, 2)
  cout << "dot22(0, 0), dot22(0, 1), dot22(1, 0), dot22(1, 1): " << dot22(0, 0) << ", "
       << dot22(0, 1) << ", " << dot22(1, 0) << ", " << dot22(1, 1) << endl;  // out: 35, 44, 44, 56
  cout << "===================\n";

  /*
   * COMPARISON OPERATORS
   */

  /* Comparison operators */
  auto first = npp::array<int>{1, 2, 3};
  auto second = npp::array<int>{2, 2, 2};
  auto comp = first == second;
  cout << "auto first = npp::array<int> {1, 2, 3}\n";
  cout << "auto second = npp::array<int> {2, 2, 2}\n";
  cout << "auto comp = first == second\n";
  cout << "comp(0), comp(1), comp(2): " << (bool)comp(0) << ", " << (bool)comp(1) << ", "
       << (bool)comp(2) << endl;  // out: 0, 1, 0

  /* Other comparison operators */
  cout << "first = npp::array<int> {1, 2, 3}\n";
  cout << "second = npp::array<int> {2, 2, 2}\n";
  comp = first > second;
  comp = first >= second;
  comp = first < second;
  comp = first <= second;
  cout << "comp = first > second\n";
  cout << "comp = first >= second\n";
  cout << "comp = first < second\n";
  cout << "comp = first <= second\n";
  cout << "===================\n";

  /* Scalar comparison operators */
  first = npp::array<int>{1, 2, 3};
  comp = first == 3;
  cout << "first = npp::array<int>{1, 2, 3}\n";
  cout << "comp = first == 3\n";
  cout << "comp(0), comp(1), comp(2): " << (bool)comp(0) << ", " << (bool)comp(1) << ", "
       << (bool)comp(2) << endl;  // out: 0, 0, 1

  /* Other scalar comparison operators */
  comp = first > 3;
  comp = first >= 3;
  comp = first < 3;
  comp = first >= 3;
  cout << "comp = first > 3\n";
  cout << "comp = first >= 3\n";
  cout << "comp = first < 3\n";
  cout << "comp = first <= 3\n";
  cout << "===================\n";

  /* any() and all() */
  first = npp::array<int>{1, 2, 3};
  comp = first == 3;
  cout << "first = npp::array<int>{1, 2, 3}\n";
  cout << "comp = first == 3\n";
  cout << "comp.any(), comp.all(): " << comp.any() << ", " << comp.all() << endl;  // out 1, 0

  comp = first <= 3;
  cout << "comp = first == 3\n";
  cout << "comp.any(), comp.all(): " << comp.any() << ", " << comp.all() << endl;  // out 1, 1

  return 0;
}
